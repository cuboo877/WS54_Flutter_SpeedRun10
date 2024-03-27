import 'package:flutter/material.dart';

Widget fast_text(String text, Color color, int size, bool isBold) {
  return Text(
    text,
    style: TextStyle(
        color: color,
        fontSize: size.toDouble(),
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
  );
}
