import 'package:flutter/material.dart';
import 'package:grow_me_app/main.dart';

class Button extends StatelessWidget {
  const Button(this.text, this.onTap, {super.key});

  final void Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: primarySwatch,
          shape: BoxShape.rectangle,
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(color: lightBackgroundColor),
        )),
      ),
    );
  }
}
