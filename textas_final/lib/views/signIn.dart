// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:textas_final/services/auth.dart';
import 'package:textas_final/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(),
        body: Center(
            // child:
            // GestureDetector(
            //     onTap: () {
            //       AuthMethods().signInWithGoogle(context);
            //     },
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                primary: Colors.orange.shade600,
                onPrimary: Colors.white,
                minimumSize: Size(MediaQuery.of(context).size.width / 2, 50)),
            icon: const FaIcon(FontAwesomeIcons.google),
            label: const Text('Sign In With Google'),
            onPressed: () {
              AuthMethods().signInWithGoogle(context);
            },
          ),
        )));
    // Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(24),
    //     color: Color(0xffDB4437),
    //   ),
    //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //   child: Text(
    //     "Sign In with Google",
    //     style: TextStyle(fontSize: 16, color: Colors.white),
    //   ),
    // ),
    // ),
    //   ),
    // );
  }
}
