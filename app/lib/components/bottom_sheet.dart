import 'package:flutter/material.dart';
import 'package:grow_me_app/colors.dart';

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(
          minHeight: 200.0,
          maxHeight: 500.0,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: sand,
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 3,
              blurRadius: 25,
              offset: const Offset(0, 10), // changes position of shadow
            ),
          ],
        ),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: sand.shade900,
                ),
                child: const SizedBox(height: 10, width: 60),
              )),
          Expanded(
              child: SingleChildScrollView(
                  child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: child,
          )))
        ]));
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
