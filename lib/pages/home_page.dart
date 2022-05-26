import 'package:demo_login_office/core/firebase_login.dart';
import 'package:demo_login_office/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    this.user,
  }) : super(key: key);

  final User? user;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.user?.toString() ?? '',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                title: 'LOGOUT',
                onPressed: () async {
                  await FirebaseLogin.I.logout().then((value) {
                    Navigator.pop(context);
                    return null;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
