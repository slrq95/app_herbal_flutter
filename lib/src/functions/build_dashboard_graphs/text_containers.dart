  import'package:flutter/material.dart';

 Widget buildTextNumberContainer(String text1, double number1, String text2, double number2) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text1,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        Text(
          number1.toInt().toString(),
          style: const TextStyle(color: Colors.greenAccent, fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          text2,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        Text(
          number2.toInt().toString(),
          style: const TextStyle(color: Colors.redAccent, fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }