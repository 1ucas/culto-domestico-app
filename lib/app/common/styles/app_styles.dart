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
          style: TextStyle(fontSize: 18, color: InactiveColor),
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

extension ToMaterialColor on Color {  
  MaterialColor toMaterialColor() {
    Map<int, Color> colorMap = {
      50: this.withOpacity(.1),
      100: this.withOpacity(.2),
      200: this.withOpacity(.3),
      300: this.withOpacity(.4),
      400: this.withOpacity(.5),
      500: this.withOpacity(.6),
      600: this.withOpacity(.7),
      700: this.withOpacity(.8),
      800: this.withOpacity(.9),
      900: this.withOpacity(1)
    };
    return MaterialColor(this.value, colorMap);
  }
}
