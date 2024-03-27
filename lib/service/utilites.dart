import 'dart:math';

import 'package:flutter/material.dart';

class Utilities {
  static void showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 1),
    ));
  }

  static String randomID() {
    Random random = Random();
    String result = "";
    for (int i = 0; i < 9; i++) {
      result += random.nextInt(9).toString();
    }
    return result;
  }

  static String randomPassword(bool hasLower, bool hasUpper, bool hasSymbol,
      bool hasNumber, int length, String custom) {
    StringBuffer buffer = StringBuffer();
    StringBuffer resultBuffer = StringBuffer();
    if (hasLower) {
      buffer.write("abcdefghijklmnopqrstuvwzxyz");
    }
    if (hasUpper) {
      buffer.write("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    }
    if (hasSymbol) {
      buffer.write("!@#%^&*()+}{|?><}");
    }
    if (hasNumber) {
      buffer.write("0123456789");
    }
    Random random = Random();
    for (int i = 0; i < length - custom.length; i++) {
      resultBuffer.write(buffer.toString()[random.nextInt(buffer.length)]);
    }
    int index = random.nextInt(resultBuffer.length);
    String result = resultBuffer.toString();
    return "${result.substring(0, index)}$custom${result.substring(index)}";
  }
}
