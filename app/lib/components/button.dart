import 'package:flutter/material.dart';
import 'package:grow_me_app/colors.dart';
import 'package:grow_me_app/main.dart';

enum ButtonType {
  normal,
  outlined,
  inverted,
}

class Button extends StatelessWidget {
  Button(this.text, this.onTap, {super.key, this.type});

  ButtonType? type = ButtonType.normal;
  final void Function() onTap;
  final String text;

  Color _getTextColor() {
    if (type == null) {
      return sand;
    }

    switch (type!) {
      case ButtonType.normal:
        return sand;
      case ButtonType.inverted:
      case ButtonType.outlined:
        return green;
    }
  }

  Color _getBackgroundColor() {
    if (type == null) {
      return green;
    }

    switch (type!) {
      case ButtonType.normal:
        return green;
      case ButtonType.inverted:
        return sand;
      case ButtonType.outlined:
        return Colors.transparent;
    }
  }

  BoxBorder? _getBorderStyle() {
    if (type == null) {
      return null;
    }

    switch (type!) {
      case ButtonType.normal:
        return null;
      case ButtonType.inverted:
        return null;
      case ButtonType.outlined:
        return Border.all(
          color: green,
          width: 2,
        );
    }
  }

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
            color: _getBackgroundColor(),
            shape: BoxShape.rectangle,
            border: _getBorderStyle()),
        child: Center(
            child: Text(
          text,
          textScaleFactor: 1.25,
          style: TextStyle(color: _getTextColor()),
        )),
      ),
    );
  }
}
