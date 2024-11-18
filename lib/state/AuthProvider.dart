import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubb_flutter_pt_app/dao/UserDataDao.dart';
import 'package:ubb_flutter_pt_app/model/login_method.dart';
import 'package:ubb_flutter_pt_app/utils/toast.dart';

import '../model/shared_pref_constants.dart';
import '../model/user_role.dart';
import '../model/userdata.dart';

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GitHubSignIn _githubSignIn = GitHubSignIn(
    clientId: "Ov23lioY4FNIQrb8gQRR",
    clientSecret: "eefb7e3f64908c1e835fbad6f7a5843d8b6c433a",
    redirectUrl: "https://ubb-flutter-pt-app.firebaseapp.com/__/auth/handler",
    title: "GitHub Connection",
    centerTitle: false
  );
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserDataDao _userDataDao = UserDataDao();

  AuthProvider();

  AuthProvider.withAuthenticated(String authMethod, String accessToken,
      String idToken) {
    if (authMethod == AuthMethod.google.value) {
      _loginWithGoogleAtAppStart(idToken, accessToken);
      _isLoggedIn = true;
    } else if (authMethod == AuthMethod.github.value) {
      _isLoggedIn = true;
    } else {
      log("Unknown auth method: $authMethod");
    }
  }

  bool _isLoggedIn = false;
  UserData? _userData;

  bool get isLoggedIn => _isLoggedIn;
  UserData? get userData => _userData;

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
    await _firebaseAuth.signOut();
    _deleteUserFromSharedPreferences();

    _isLoggedIn = false;
    _userData = null;
    notifyListeners();
  }

  void _loginWithGoogleAtAppStart(String idToken, String accessToken) async {
    OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );

    _trySigningInWithAuthCredential(AuthMethod.google, oAuthCredential, null);
  }

  void _loginWithGoogle(BuildContext context) async {
    // Stop automatic login
    await _googleSignIn.signOut();
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    GoogleSignInAuthentication? googleSignInAuthentication =
    await googleSignInAccount?.authentication;

    OAuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    _trySigningInWithAuthCredential(AuthMethod.google, authCredential,
        context);
  }

  void _loginWithGithub(BuildContext context) async {
    var result = await _githubSignIn.signIn(context);
    if (result.status != GitHubSignInResultStatus.ok) {
      _handleErrorLogin(context, "Error logging in with GitHub");
      return;
    }

    OAuthCredential githubAuthCredential = GithubAuthProvider
        .credential(result.token!);

    _trySigningInWithAuthCredential(AuthMethod.github, githubAuthCredential,
        context);
  }

  void _trySigningInWithAuthCredential(AuthMethod authMethod,
      OAuthCredential oauthCredential, BuildContext? context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        if (authMethod == AuthMethod.google) {
          var checkUserData = UserData(userCredential.user!.email!, authMethod,
              UserRole.user);
          _handleSuccessFullLogin(context, oauthCredential, checkUserData);
        } else if (authMethod == AuthMethod.github) {
          var userEmail = userCredential.user!.providerData[0].email;
          var checkUserData = UserData(userEmail!, authMethod, UserRole.user);
          _handleSuccessFullLogin(context, oauthCredential, checkUserData);
        }

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

      if (context != null && context.mounted) {
        showToast(context, message);
      }
    }
  }

  void _registerUserIfNotExists(UserData checkUserData) async {
    var foundUserData = await _userDataDao.getUserData(checkUserData.email,
        checkUserData.authMethod);
    if (foundUserData != null) {
      _userData = UserData(foundUserData.email, foundUserData.authMethod,
          foundUserData.userRole);
    } else {
      await _userDataDao.saveUserData(
          UserData(checkUserData.email, checkUserData.authMethod,
              UserRole.user));
      _userData = UserData(checkUserData.email, checkUserData.authMethod,
          UserRole.user);
    }

    _setLoggedInAndNotify();
  }

  void _saveUserDataToSharedPreferences(OAuthCredential oauthCredential,
      AuthMethod authMethod) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    if (authMethod == AuthMethod.google) {
      await sharedPreferences.setString(idTokenKey,
          oauthCredential.idToken!);
      await sharedPreferences.setString(accessTokenKey,
          oauthCredential.accessToken!);
    } else if (authMethod == AuthMethod.github) {
      await sharedPreferences.setString(accessTokenKey,
          oauthCredential.accessToken!);
    }

    await sharedPreferences.setString(authMethodKey, authMethod.value);
  }

  void _deleteUserFromSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(idTokenKey);
    await sharedPreferences.remove(accessTokenKey);
    await sharedPreferences.remove(authMethodKey);
  }

  void _handleSuccessFullLogin(BuildContext? context,
      OAuthCredential oauthCredential, UserData checkUserData) async {

    _registerUserIfNotExists(checkUserData);
    _saveUserDataToSharedPreferences(oauthCredential, checkUserData.authMethod);

    if (context != null && context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      showToast(context, "Successfully logged in");
    }
  }

  void _handleErrorLogin(BuildContext context, String message) {
    if (context.mounted) {
      showToast(context, message);
    }
  }
}