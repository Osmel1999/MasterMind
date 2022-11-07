import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:master_app/Provider/dreamProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Pages/SignIn/DreamPage.dart';
import '../../Preferencias/sharedPeference.dart';
import '../../navegationPage.dart';
import '../bigData.dart';
import 'fire_store.dart';

class FireAuth with ChangeNotifier {
  GoogleSignInAccount? currentUser;
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

  Future<void> signIn(BuildContext context, BigData bigData,
      FireStore fireStore, DreamProvider dreamProvider) async {
    await handleSignIn();
    bigData.bigData["User"]["Email"] = email;
    bigData.bigData["User"]["Name"] = displayName;
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
          builder: (BuildContext context) => const NavigationPage(),
        ),
      );
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

  Future<void> handleSignIn() async {
    try {
      currentUser = await googleSignIn.signIn();
      email = currentUser!.email;
      displayName = currentUser!.displayName!;
      print("EMAIL:::-> $email");
      credential = await signInWithGoogle(currentUser);
      // if (pref.autoAuth == false) pref.autoAuth = true;
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  Future<void> handleSignOut() => googleSignIn.disconnect();
}
