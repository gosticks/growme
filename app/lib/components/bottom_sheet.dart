import 'package:flutter/material.dart';

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(
            color: Colors.grey.shade300, width: 1, style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 3,
            blurRadius: 25,
            offset: const Offset(0, 10), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 15),
        child: child,
      ),
    );
  }
}

Future showCustomModalBottomSheet(BuildContext context, Widget child) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomSheet(child: child);
      });
}
