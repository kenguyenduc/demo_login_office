import 'package:demo_login_office/core/firebase_login.dart';
import 'package:demo_login_office/pages/home_page.dart';
import 'package:demo_login_office/utils/app_logger.dart';
import 'package:demo_login_office/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final FirebaseAuth FirebaseLogin.I.auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login page'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('UserName'),
                  TextField(
                    controller: _userNameController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  const Text('Password'),
                  TextField(
                    controller: _passwordController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: const Text('LOGIN'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const HomePage(),
                        //   ),
                        // );
                        // await performLogin("microsoft.com", ["email openid"],
                        await performLogin("microsoft.com", ["email openid "],
                            {'tenant': myTenantId});
                      },
                      child: const Text('LOGIN WITH OFFICE 365'),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      child: const Text('LOGOUT'),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await loginWithMicrosoft().then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ));
                          return;
                        });
                      },
                      child: const Text('loginWithMicrosoft'),
                    ),
                  ),
                  CustomButton(
                    title: 'login with google',
                    onPressed: () async {
                      final User? result = await FirebaseLogin.I.signInGoogle();
                      if (result != null) {
                        logger.d(result);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                    },
                  ),
                  CustomButton(
                    title: 'Logout google',
                    onPressed: () {
                      FirebaseLogin.I.logout();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String myTenantId = 'cd61f176-1d9b-44fb-94a3-563affcaf249';
  final List<String> _SCOPES = [
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

  Future<void> performLogin(String provider, List<String> scopes,
      Map<String, String> parameters) async {
    try {
      await FirebaseAuth.instance.signOut();
      User? user = FirebaseAuth.instance.currentUser;
      // User? user2 = await FirebaseAuthOAuth().openSignInFlow(
      // User? user2 = await FirebaseAuthOAuth().openSignInFlow(
      //   "microsoft.com",
      //   ["email", "openid", "User.Read"],
      //   {'tenant': myTenantId},
      // );
      // User? user2 = await FirebaseAuthOAuth(app: FirebaseLogin.I.auth.app).linkExistingUserWithCredentials(
      User? user2 =
          await FirebaseAuthOAuth(app: FirebaseLogin.I.auth.app).openSignInFlow(
        "microsoft.com",
        _SCOPES,
        {'tenant': myTenantId, "locale": "en"},
      );

      // final AuthCredential credential = GoogleAuthProvider.credential(
      //   accessToken: oAuthCredential.accessToken,
      //   idToken: oAuthCredential.idToken,
      // );
      // final User? user2 = (await FirebaseLogin.I.auth.signInWithCredential(credential)).user;

      logger.d('--------Success------------/n$user2');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } on PlatformException catch (error, s) {
      logger.e("${error.code}: ${error.message}");
    }
  }

  ///just support for web
  Future<UserCredential?> loginWithMicrosoft() async {
    OAuthProvider provider = OAuthProvider('microsoft.com');
    provider.setCustomParameters({
      "tenant": "your-tenant-id",
    });
    provider.addScope('user.read');
    provider.addScope('profile');
    provider.addScope('openid');

    try {
      OAuthCredential? oAuthCredential =
          await FirebaseAuthOAuth(app: FirebaseLogin.I.auth.app).signInOAuth(
        "microsoft.com",
        ["email openid", "profile", "user.read"],
        {'tenant': myTenantId, "locale": "en"},
      );

      // User is signed in.
      // IdP data available in authResult.additionalUserInfo.profile.
      // OAuth access token can also be retrieved:
      // authResult.credential.accessToken
      // OAuth ID token can also be retrieved:
      // authResult.credential.idToken

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: oAuthCredential.accessToken,
        idToken: oAuthCredential.idToken,
      );
      final User? user2 =
          (await FirebaseLogin.I.auth.signInWithCredential(credential)).user;

      // final userCredential =
      //     await FirebaseAuth.instance.signInWithPopup(provider);

      // User? user2 = await FirebaseAuthOAuth(app: FirebaseAuth.instance.app)
      //     .openSignInFlow(
      //   "microsoft.com",
      //   ["email", "user.read", "profile"],
      //   {'tenant': myTenantId},
      // ).then((value) {
      //   logger.d('--------Success------------');
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const HomePage(),
      //     ),
      //   );
      //   return null;
      // });
      // return userCredential;
    } on FirebaseAuthException catch (err) {
      logger.e(err.message);
      // Handle FirebaseAuthExceptions
      // ex: firebaseFirebaseLogin.I.auth/account-exists-with-different-credential
    }
    return null;
  }
}
