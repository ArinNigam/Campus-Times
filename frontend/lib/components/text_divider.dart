import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const Expanded(
          child: Divider(
        color: Colors.white,
        thickness: 0.2,
      )),
      Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 0.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          )),
      const Expanded(
          child: Divider(
        color: Colors.white,
        thickness: 0.2,
      )),
    ]);
  }
}
