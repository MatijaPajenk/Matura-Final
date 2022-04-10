// ignore_for_file: unnecessary_null_comparison
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textas_final/heleperFunctions/sharedPrefrencesHelper.dart';
import 'package:textas_final/services/database.dart';
import 'package:textas_final/views/home.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    User userDetails = userCredential.user!;

    if (userCredential != null) {
      SharedPreferencesHelper().saveUserEmail(userDetails.email as String);
      SharedPreferencesHelper().saveUserId(userDetails.uid);
      SharedPreferencesHelper()
          .saveDisplayName(userDetails.displayName as String);
      SharedPreferencesHelper()
          .saveUserProfileUrl(userDetails.photoURL as String);
      SharedPreferencesHelper()
          .saveUserName(userDetails.email!.replaceAll("@gmail.com", ""));

      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "userName": userDetails.email!.replaceAll("@gmail.com", ""),
        "name": userDetails.displayName,
        "profileUrl": userDetails.photoURL,
      };

      DatabaseMethods()
          .addUserInfoToDB(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      });
    }
  }

  Future signOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    await auth.signOut();
  }
}
