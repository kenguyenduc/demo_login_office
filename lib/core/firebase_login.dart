import 'dart:async';
import 'package:demo_login_office/utils/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCanceled implements Exception {
  @override
  String toString() => 'AuthCanceled: cancelled by user';
}

class UserNotAuthorized implements Exception {
  @override
  String toString() => 'User not authorized!';
}

class FirebaseLogin {
  FirebaseLogin._();

  static final FirebaseLogin I = FirebaseLogin._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInGoogle() async {
    await logout();
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final User? user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  Future<User?> signInMicrosoft() async {
    const String tenantId = 'cd61f176-1d9b-44fb-94a3-563affcaf249';
    String provider = "microsoft.com";
    List<String> scopes = [
      "openid",
      "email",
      "offline_access",
      "profile",
      "User.ReadBasic.All",
      "User.Read",
      // "User.Read.All",
      // "Directory.Read.All",
      // "Directory.AccessAsUser.All"
    ];
    Map<String, String> parameters = {'tenant': tenantId, "locale": "en"};
    try {
      await logout();
      // User? user = FirebaseAuth.instance.currentUser;
      User? user = await FirebaseAuthOAuth(app: _auth.app).openSignInFlow(
        provider,
        scopes,
        parameters,
      );
      logger.d('--------Success------------/n$user');
      return user;
    } on PlatformException catch (error) {
      logger.e("${error.code}: ${error.message}");
    }
    return null;
  }

  Future<void> logout() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
      await _auth.signOut();
    } catch (e) {
      logger.e(e);
    }
  }
}
