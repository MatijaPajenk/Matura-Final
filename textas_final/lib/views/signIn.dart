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
          title: Center(
            child: Image.asset(
              "assets/images/text_only.png",
              height: 45,
              color: Theme.of(context).scaffoldBackgroundColor ==
                      const Color(0xfffec47f)
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          toolbarHeight: 70,
        ),
        body: Center(
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                // primary: ThemeMode.system == ThemeMode.light
                //     ? Colors.red
                //     : Colors.black54,
                // onPrimary: Colors.white,
                minimumSize: Size(MediaQuery.of(context).size.width / 2, 50)),
            icon: const FaIcon(FontAwesomeIcons.google),
            label: const Text('Sign In With Google'),
            onPressed: () {
              AuthMethods().signInWithGoogle(context);
            },
          ),
        )));
  }
}
