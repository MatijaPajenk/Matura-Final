import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar appBarMain() {
  return AppBar(
    title: Center(
      child: Image.asset(
        "assets/images/text_only.png",
        height: 45,
      ),
    ),
    toolbarHeight: 70,
  );
}
