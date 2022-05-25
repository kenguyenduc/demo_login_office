import 'dart:async';

// import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:demo_login_office/utils/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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

  // final FacebookAuth _facebookAuth = FacebookAuth.instance;

  // Future<bool> isAppleSignInAvailable() => AppleSignIn.isAvailable();

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

  // Future<User> signInApple() async {
  //   final AuthorizationResult loginResult = await AppleSignIn.performRequests([
  //     const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  //   ]);
  //   switch (loginResult.status) {
  //     case AuthorizationStatus.authorized:
  //     // here we're going to sign in the user within firebase
  //       break;
  //     case AuthorizationStatus.error:
  //     // do something
  //       throw loginResult.error;
  //
  //     case AuthorizationStatus.cancelled:
  //       throw AuthCanceled();
  //   }
  //
  //   final AppleIdCredential appleIdCredential = loginResult.credential;
  //
  //   final AuthCredential credential = OAuthProvider('apple.com').credential(
  //     accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
  //     idToken: String.fromCharCodes(appleIdCredential.identityToken),
  //   );
  //
  //   final UserCredential result = await _auth.signInWithCredential(credential);
  //   final User user = result.user;
  //   logger.d('Signed in with apple ${user.uid}');
  //   return user;
  // }

  // Future<User> signInFacebook() async {
  //   await logout();
  //   final LoginResult result = await _facebookAuth.login(loginBehavior: LoginBehavior.WEB_VIEW_ONLY);
  //   final String accessToken = result?.accessToken?.token;
  //   if (accessToken == null) {
  //     return null;
  //   }
  //   final AuthCredential facebookAuthCred = FacebookAuthProvider.credential(accessToken);
  //   final User user = (await _auth.signInWithCredential(facebookAuthCred)).user;
  //   return user;
  // }

  Future<void> logout() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
      // if (await _facebookAuth.accessToken != null) {
      //   await _facebookAuth.logOut();
      // }
      await _auth.signOut();
    } catch (e) {
      logger.e(e);
    }
  }
}

// class UserSocialData {
//   UserSocialData._({this.name, this.email, this.photoUrl});
//
//   factory UserSocialData.fromApple(AuthorizationResult result, User user) {
//     // final AppleIdCredential appleIdCredential = result.credential;
//     // final PersonNameComponents nameComponents = appleIdCredential.fullName;
//     final String name = <String>[
//       nameComponents.namePrefix,
//       nameComponents.givenName,
//       nameComponents.middleName,
//       nameComponents.familyName,
//       nameComponents.nameSuffix,
//     ].where((String element) => element != null).join(' ') ??
//         'Apple ID';
//
//     final String email = appleIdCredential.email ?? user?.providerData?.first?.email;
//     return UserSocialData._(name: name, email: email, photoUrl: null);
//   }
//
//   factory UserSocialData.fromGoogle(GoogleSignInAccount account) {
//     return UserSocialData._(
//       name: account.displayName,
//       email: account.email,
//       photoUrl: account.photoUrl,
//     );
//   }
//
//   factory UserSocialData.fromFacebook(UserCredential result) {
//     final Map<String, dynamic> profile = result.additionalUserInfo.profile;
//     final String name = profile['name'] as String ?? result.user.displayName;
//     final String email = profile['email'] as String ?? result.user.email;
//     final String pictureData = (profile['picture'] as Map<dynamic, dynamic>)['data'] as String;
//     final String photoUrl = (pictureData as Map<dynamic, dynamic>)['url'] as String;
//     return UserSocialData._(name: name, email: email, photoUrl: photoUrl);
//   }
//
//   final String name;
//   final String email;
//   final String photoUrl;
// }
