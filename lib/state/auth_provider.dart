import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubb_flutter_pt_app/dao/user_data_dao.dart';
import 'package:ubb_flutter_pt_app/model/login_method.dart';
import 'package:ubb_flutter_pt_app/state/navigation_service.dart';
import 'package:ubb_flutter_pt_app/utils/toast.dart';

import '../model/shared_pref_constants.dart';
import '../model/user_role.dart';
import '../model/store/userdata.dart';

class AuthProvider extends ChangeNotifier {
  final String KEY_EMAIL = "email";
  final String KEY_NAME = "name";

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  /*final GitHubSignIn _githubSignIn = GitHubSignIn(
    clientId: "Ov23lioY4FNIQrb8gQRR",
    clientSecret: "eefb7e3f64908c1e835fbad6f7a5843d8b6c433a",
    redirectUrl: "https://ubb-flutter-pt-app.firebaseapp.com/__/auth/handler",
    title: "GitHub Connection",
    centerTitle: false
  );*/
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserDataDao _userDataDao = UserDataDao();

  AuthProvider();

  AuthProvider.withAuthenticated(String authMethod, String accessToken,
      String idToken) {
    if (authMethod == AuthMethod.google.value) {
      _isLoggedIn = true;
      _loginWithGoogleAtAppStart(idToken, accessToken, null);
    } else {
      log("Unknown auth method: $authMethod");
    }
  }

  static bool _isLoggedIn = false;
  static UserData? _userData;

  bool get isLoggedIn => _isLoggedIn;
  static bool get isLoggedInStatic => _isLoggedIn;
  UserData? get userData => _userData;
  static UserData? get userDataStatic => _userData;

  void login(BuildContext context, AuthMethod loginMethod) async {
    switch (loginMethod) {
      case AuthMethod.google:
        _loginWithGoogle(context);
        break;
      case AuthMethod.facebook:
        break;
    }
  }

  _setLoggedInAndNotify(UserData userData) {
    _isLoggedIn = true; // Set the value
    _userData = userData;
    notifyListeners(); // Notify listeners about the change
  }

  void logout() async {
    await _firebaseAuth.signOut();
    _deleteUserFromSharedPreferences();

    _isLoggedIn = false;
    _userData = null;
    notifyListeners();
  }

  void _loginWithGoogleAtAppStart(String idToken, String accessToken,
      BuildContext? context) async {
    OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );

    try {
      await _trySigningInWithAuthCredential(AuthMethod.google, oAuthCredential,
          context);
    } finally {
      Navigator.of(NavigationService.navigatorKey.currentContext!)
          .pushNamedAndRemoveUntil('/', (route) => false);
      FlutterNativeSplash.remove();
    }
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

  /*
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
  }*/

  Future<void> _trySigningInWithAuthCredential(AuthMethod authMethod,
      OAuthCredential oauthCredential, BuildContext? context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        if (authMethod == AuthMethod.google) {
          if (!userCredential.additionalUserInfo!.profile!.containsKey(KEY_EMAIL)) {
            _handleErrorLogin(context, "No email found in Google profile");
            return;
          }

          if (!userCredential.additionalUserInfo!.profile!.containsKey(KEY_NAME)) {
            _handleErrorLogin(context, "No name found in Google profile");
            return;
          }

          final String email = userCredential.additionalUserInfo!.profile![KEY_EMAIL];
          final String name = userCredential.additionalUserInfo!.profile![KEY_NAME];
          var checkUserData = UserData(email, name, authMethod, UserRole.user);
          await _handleSuccessFullLogin(context, oauthCredential, checkUserData);
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

  Future<void> _registerUserIfNotExists(UserData checkUserData) async {
    UserData? foundUserData = await _userDataDao.getUserData(checkUserData.email,
        checkUserData.authMethod);

    if (foundUserData != null) {
      _setLoggedInAndNotify(foundUserData);
    } else {
      final UserData userData = UserData(checkUserData.email,
          checkUserData.name, checkUserData.authMethod, UserRole.user);
      await _userDataDao.saveUserData(userData);
      _setLoggedInAndNotify(userData);
    }
  }

  Future<void> _saveUserDataToSharedPreferences(OAuthCredential oauthCredential,
      AuthMethod authMethod) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    if (authMethod == AuthMethod.google) {
      await sharedPreferences.setString(idTokenKey,
          oauthCredential.idToken!);
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

  Future<void> _handleSuccessFullLogin(BuildContext? context,
      OAuthCredential oauthCredential, UserData checkUserData) async {

    await _registerUserIfNotExists(checkUserData);
    await _saveUserDataToSharedPreferences(oauthCredential,
        checkUserData.authMethod);

    if (context != null && context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      showToast(context, "Successfully logged in");
    }
  }

  void _handleErrorLogin(BuildContext? context, String message) {
    if (context != null && context.mounted) {
      showToast(context, message);
    }
  }
}