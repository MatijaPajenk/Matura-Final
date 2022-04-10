// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:textas_final/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor:
            Theme.of(context).scaffoldBackgroundColor == const Color(0xfffec47f)
                ? Colors.black
                : Colors.white,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              const SizedBox(
                height: 128,
              ),
              Theme.of(context).scaffoldBackgroundColor ==
                      const Color(0xfffec47f)
                  ? Image.asset(
                      'assets/images/logo_in_app.png',
                      alignment: Alignment.center,
                      height: 220,
                    )
                  : Image.asset(
                      'assets/images/logo_in_app_dark.png',
                      alignment: Alignment.center,
                      height: 220,
                    ),
              const SizedBox(
                height: 64,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width / 2, 50)),
                icon: const FaIcon(FontAwesomeIcons.google),
                label: const Text('Sign In With Google'),
                onPressed: () {
                  AuthMethods().signInWithGoogle(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
