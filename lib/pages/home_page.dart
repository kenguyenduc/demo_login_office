import 'package:demo_login_office/core/firebase_login.dart';
import 'package:demo_login_office/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut ().then((value) {
                    Navigator.pop(context);
                    return null;
                  });
                },
                child: const Text('LOGOUT'),
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              title: 'Logout google',
              onPressed: () {
                FirebaseLogin.I.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
