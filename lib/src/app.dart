import 'dart:ui';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Application {
  static late final FluroRouter router;
  static final ThemeData theme = ThemeData(
      fontFamily: 'Roboto Serif',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 13),
        bodyMedium: TextStyle(fontSize: 15, height: 1.4),
        bodySmall: TextStyle(fontSize: 10),
        headlineMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ));
}
