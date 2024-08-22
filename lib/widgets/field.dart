import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Field extends StatelessWidget {
  String hint;
  var controller;
  bool secure = false;

  Field({super.key, required this.hint, required this.controller, required this.secure});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: TextField(
        controller: controller,
          obscureText: secure,
        style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: '$hint',
          hintStyle: TextStyle(color: Color.fromARGB(255, 155, 155, 155)),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
