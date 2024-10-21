import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/theme.dart';

mixin UIToolMixin {
  void showMessage(String message, BuildContext context,
      {Color color = kAppBlue}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 1000),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
