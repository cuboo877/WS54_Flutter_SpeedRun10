import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun10/constant/style_guide.dart';

Widget customButton(String text, int fontSize, Color color, onPressed) {
  return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(45))),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: AppColor.white, fontSize: fontSize.toDouble()),
      ));
}
