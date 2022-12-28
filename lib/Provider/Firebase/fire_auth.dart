import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:master_app/Provider/dreamProvider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart';

import '../../Pages/SignIn/DreamPage.dart';
import '../../Preferencias/sharedPeference.dart';
import '../../navegationPage.dart';
import '../bigData.dart';
import 'fire_store.dart';

class FireAuth with ChangeNotifier {
  GoogleSignInAccount? currentUser;
  UserCredential? appleUser;
  final pref = PreferenciasUsuario();
  String email = '';
  String displayName = '';
  late UserCredential credential;
  late GoogleSignIn googleSignIn;

  FireAuth() {
    _googleInit();
  }

  _googleInit() {
    googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        // 'https://www.googleapis.com/auth/analytics.readonly',
      ],
    );

    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      currentUser = account;
      if (currentUser != null) {
        // _handleGetContact(_currentUser!);
        // handleGetData(currentUser!);

        notifyListeners();
      }
    });
    googleSignIn.signInSilently();
    notifyListeners();
  }

  Future<void> signIn(
      BuildContext context,
      BigData bigData,
      FireStore fireStore,
      DreamProvider dreamProvider,
      String botonTapped) async {
    bool canLog = false;
    canLog = (botonTapped == "Apple")
        ? await apple_Sign_In(context, dreamProvider, bigData)
        : await handleSignIn(bigData);
    if (canLog) {
      Map<String, dynamic> _temp = await bigData.logIn(fireStore);
      if (_temp["User"]["Mentor"] == null) {
        if ((await fireStore.bajarDataCloud(email, "Datos Personales"))
            .isNotEmpty) {
          await bigData.migData(FireStore(), email);
          await bigData.uploadMigData(FireStore(), email);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const NavigationPage(),
            ),
          );
        } else {
          // Lo iniciamos dentro de Phlow (Planification Flow).
          await dreamProvider.dowloadDreams(fireStore);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const Dreams(),
            ),
          );
        }
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const NavigationPage(),
          ),
        );
      }
    }
  }

  Future<UserCredential> signInWithGoogle(
      GoogleSignInAccount? googleUser) async {
    // Trigger the authentication flow

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<bool> handleSignIn(BigData bigdata) async {
    try {
      currentUser = await googleSignIn.signIn();
      email = currentUser!.email;
      displayName = currentUser!.displayName!;
      print("EMAIL:::-> $email");
      bigdata.bigData["User"]["Email"] = email;
      bigdata.bigData["User"]["Name"] = displayName;
      credential = await signInWithGoogle(currentUser);

      bigdata.save();
      return true;
    } catch (error) {
      print(error);
    }
    notifyListeners();
    return false;
  }

  Future<bool> apple_Sign_In(BuildContext context, DreamProvider dreamProvider,
      BigData bigdata) async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    if (credential.email != null &&
        credential.email!.contains("@privaterelay.appleid.com") == false) {
      email = credential.email!;
      displayName = credential.givenName ?? credential.email!;
      print("EMAIL:::-> $email");
      bigdata.bigData["User"]["Email"] = email;
      bigdata.bigData["User"]["Name"] = displayName;
      appleFire_Auth(dreamProvider, credential);
      return true;
    } else {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("Alerta"),
              content: const Text(
                  "Por favor ingresar con un email valido, desactive el modo ( ocultar correo ) \n Configuraciones > Apple ID, iCloud, iTunes & App Store > Contraseñas & Seguridad > Apps que usan el Apple ID, toca en Master Mind y toca en Dejar de usar Apple ID. "),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Listo"))
              ],
            );
          });
      return false;
    }
  }

  appleFire_Auth(DreamProvider dreamProvider,
      AuthorizationCredentialAppleID appleCredential) async {
    print("successfull sign in");

    OAuthProvider oAuthProvider = OAuthProvider("apple.com");
    final AuthCredential credential = oAuthProvider.credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    appleUser = await FirebaseAuth.instance.signInWithCredential(credential);
    // await dreamProvider.dowloadDreams(FireStore());
    print(appleUser);
    notifyListeners();
  }

  Future<void> handleSignOut() => googleSignIn.disconnect();
}
