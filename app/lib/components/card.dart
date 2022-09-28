import 'package:flutter/material.dart';

class GrowMeCard extends StatelessWidget {
  const GrowMeCard({this.child, super.key});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(
            color: Colors.grey.shade200, width: 2, style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
