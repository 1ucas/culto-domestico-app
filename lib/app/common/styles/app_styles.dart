import 'dart:ui';

import 'package:flutter/material.dart';

class AppStyle {
  static const PrimaryColor = Color.fromARGB(255, 38, 70, 83);
  static const SecondaryColor = Color.fromARGB(255, 42, 157, 143);
  static const WarningColor = Color.fromARGB(255, 233, 196, 106);
  static const AccentColor = Color.fromARGB(255, 244, 162, 97);
  static const DangerColor = Color.fromARGB(255, 231, 111, 81);
  static const InactiveColor = Colors.black54;

  static Widget titulo(String texto) {
    return Row(
      children: [
        Text(
          texto,
          style: TextStyle(fontSize: 18, color: SecondaryColor),
        ),
      ],
    );
  }

  static Widget subTitulo(String texto) {
    return Row(
      children: [
        Text(
              texto,
              style: TextStyle(fontSize: 18, color: AppStyle.InactiveColor),
            ),
      ],
    );
  }
}
