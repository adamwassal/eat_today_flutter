import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Btn extends StatelessWidget {
  String showText;
  Function()? func;
  Btn({super.key, required this.showText, required this.func});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: func,
        child: Text('$showText'),
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Color(0xFF2D9BF0)),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            padding: WidgetStatePropertyAll(EdgeInsets.all(20.0))),
      ),
    );
  }
}
