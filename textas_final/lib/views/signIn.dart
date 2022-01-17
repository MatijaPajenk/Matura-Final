// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:textas_final/services/auth.dart';
import 'package:textas_final/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Colors.orange.shade200,
                Colors.orange.shade700,
              ])),
          child: Center(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  minimumSize: Size(MediaQuery.of(context).size.width / 2, 50)),
              icon: const FaIcon(FontAwesomeIcons.google),
              label: const Text('Sign In With Google'),
              onPressed: () {
                AuthMethods().signInWithGoogle(context);
              },
            ),
          )),
        ));
  }
}
