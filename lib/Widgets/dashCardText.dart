import 'package:flutter/material.dart';

class DashCardText extends StatelessWidget {
  String boldText, subtitle;
  DashCardText({Key? key, required this.boldText, required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          boldText,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
