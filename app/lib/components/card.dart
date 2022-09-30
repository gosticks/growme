import 'package:flutter/material.dart';
import 'package:grow_me_app/colors.dart';
import 'package:grow_me_app/main.dart';

class GrowMeCard extends StatelessWidget {
  const GrowMeCard({this.child, this.backgroundColor, super.key});

  final Widget? child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor ?? sand,
        shape: BoxShape.rectangle,
        //border: Border.all(color: sand, width: 2, style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 15,
            offset: const Offset(0, 10), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
