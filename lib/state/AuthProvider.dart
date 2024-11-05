import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ubb_flutter_pt_app/model/login_method.dart';
import 'package:ubb_flutter_pt_app/utils/toast.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  AuthMethod? _loginMethod;

  bool get isLoggedIn => _isLoggedIn;
  AuthMethod? get loginMethod => _loginMethod;



  void login(BuildContext context, AuthMethod loginMethod) async {
    switch (loginMethod) {
      case AuthMethod.google:
        _loginWithGoogle(context);
        break;
      case AuthMethod.github:
        _loginWithGithub(context);
    }
  }

  _setLoggedInAndNotify() {
    _isLoggedIn = true; // Set the value
    notifyListeners(); // Notify listeners about the change
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();

    _isLoggedIn = false;
    notifyListeners();
  }

  void _loginWithGoogle(BuildContext context) async {
    GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleSignInAuthentication =
    await googleSignInAccount?.authentication;

    AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    try {
      UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(authCredential);

      if (userCredential.user != null) {
        _handleSuccessFullLogin(context, userCredential);
      }
    } on FirebaseAuthException catch (e) {
      String message;

      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        log(e.message!); // Log the error for debugging
        return;
      }

      if (context.mounted) {
        showToast(context, message);
      }
    }
  }

  void _loginWithGithub(BuildContext context) async {
    GithubAuthProvider githubAuthProvider = GithubAuthProvider();
    UserCredential userCredential =
      await FirebaseAuth.instance.signInWithProvider(githubAuthProvider);

    if (userCredential.user != null) {
      _handleSuccessFullLogin(context, userCredential);
    }
  }

  void _handleSuccessFullLogin(BuildContext context,
      UserCredential userCredential) {

    _setLoggedInAndNotify();

    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      showToast(context, "Successfully logged in");
    }
  }
}