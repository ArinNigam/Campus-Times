import 'package:flutter/material.dart';

class TimetableButton extends StatelessWidget {
  const TimetableButton(
      {super.key, required this.child, required this.onPressed});

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Color(0xff001219),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          side: const BorderSide(color: Colors.white, width: 1),
        ),
        child: child,
      ),
    );
  }
}
