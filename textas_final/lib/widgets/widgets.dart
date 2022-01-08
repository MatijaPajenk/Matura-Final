import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar appBarMain() {
  return AppBar(
    title: Image.asset(
      "assets/images/logo_with_text.png",
      height: 45,
    ),
    toolbarHeight: 50,
  );
}
