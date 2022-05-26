import 'package:demo_login_office/core/firebase_login.dart';
import 'package:demo_login_office/pages/home_page.dart';
import 'package:demo_login_office/utils/app_logger.dart';
import 'package:demo_login_office/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                  CustomButton(
                    title: 'LOGIN WITH OFFICE 365',
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      final User? user =
                          await FirebaseLogin.I.signInMicrosoft();
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(user: user),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    title: 'login with google',
                    onPressed: () async {
                      final User? result = await FirebaseLogin.I.signInGoogle();
                      if (result != null) {
                        logger.d(result);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              user: result,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    title: 'LOGOUT',
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

// final String _tenantId = 'cd61f176-1d9b-44fb-94a3-563affcaf249';
// final List<String> _scopes = [
//   "openid",
//   "email",
//   "offline_access",
//   "profile",
//   "User.ReadBasic.All",
//   "User.Read",
//   // "User.Read.All",
//   // "Directory.Read.All",
//   // "Directory.AccessAsUser.All"
// ];
//
// Future<void> performLogin(String provider, List<String> scopes,
//     Map<String, String> parameters) async {
//   try {
//     await FirebaseAuth.instance.signOut();
//     // User? user = FirebaseAuth.instance.currentUser;
//     User? user =
//         await FirebaseAuthOAuth(app: FirebaseLogin.I.auth.app).openSignInFlow(
//       "microsoft.com",
//       _scopes,
//       {'tenant': _tenantId, "locale": "en"},
//     );
//     logger.d('--------Success------------/n$user');
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const HomePage(),
//       ),
//     );
//   } on PlatformException catch (error, s) {
//     logger.e("${error.code}: ${error.message}");
//   }
// }
}
