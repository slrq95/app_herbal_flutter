import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_herbal_flutter/src/tools/custom_error.dart';

void errorDialog(BuildContext context, CustomError e) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            e.code,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), // Font size updated ✅
          ),
          content: Text(
            '${e.plugin}\n${e.message}',
            style: const TextStyle(fontSize: 16.0), // Font size updated ✅
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold), // Font size updated ✅
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            e.code,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), // Font size updated ✅
          ),
          content: Text(
            '${e.plugin}\n${e.message}',
            style: const TextStyle(fontSize: 24.0), // Font size updated ✅
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold), // Font size updated ✅
              ),
            ),
          ],
        );
      },
    );
  }
}
