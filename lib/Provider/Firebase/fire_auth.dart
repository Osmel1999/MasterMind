import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../navegationPage.dart';
import '../bigData.dart';
import 'fire_store.dart';

class FireAuth with ChangeNotifier {
  GoogleSignInAccount? currentUser;
  String email = '';
  late UserCredential credential;
  late GoogleSignIn _googleSignIn;

  FireAuth() {
    _googleInit();
  }

  _googleInit() {
    _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        // 'https://www.googleapis.com/auth/analytics.readonly',
      ],
    );

    // _googleSignIn.onCurrentUserChanged
    //     .listen((GoogleSignInAccount? account) async {
    //   currentUser = account;
    //   if (currentUser != null) {
    //     // _handleGetContact(_currentUser!);
    //     handleGetData(currentUser!);

    //     notifyListeners();
    //   }
    // });
    _googleSignIn.signInSilently();
    notifyListeners();
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

  Future<void> handleSignIn(BuildContext context) async {
    try {
      currentUser = await _googleSignIn.signIn();
      email = currentUser!.email;
      print("EMAIL:::-> $email");
      credential = await signInWithGoogle(currentUser);
      print(credential.user!.uid);
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();
}
