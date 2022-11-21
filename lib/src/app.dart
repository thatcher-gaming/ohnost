import 'dart:ui';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Application {
  static const String authCookie = "xxx";
  static late final FluroRouter router;
  static final ThemeData theme = ThemeData(
      fontFamily: 'Roboto Serif',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 13),
        bodyMedium: TextStyle(
            color: Colours.stone900,
            fontSize: 15,
            height: 1.6,
            fontVariations: [FontVariation('opsz', 18)]),
        bodySmall: TextStyle(fontSize: 10),
        labelSmall: TextStyle(
            fontSize: 12,
            color: Colours.stone900,
            fontVariations: [
              FontVariation('wght', 500),
              FontVariation('opsz', 14)
            ]),
        labelMedium: TextStyle(
            fontSize: 15,
            color: Colours.stone900,
            fontVariations: [
              FontVariation('wght', 400),
              FontVariation('opsz', 18)
            ]),
        headlineLarge: TextStyle(
            fontSize: 22,
            color: Colours.stone900,
            fontVariations: [FontVariation('wght', 700)]),
        displaySmall: TextStyle(
            fontSize: 18,
            color: Colours.black,
            fontVariations: [
              FontVariation('wght', 400),
              FontVariation('opsz', 22)
            ]),
        displayMedium: TextStyle(
            fontSize: 20,
            color: Colours.stone900,
            fontVariations: [FontVariation('wght', 400)]),
      ));
  static ScrollController scrollControl = ScrollController();
}

// these are taken from tailwindcss's palette, because it's pretty good!
class Colours {
  static const Color black = Color.fromARGB(255, 0, 0, 0);

  static const Color stone050 = Color.fromARGB(255, 250, 250, 249);
  static const Color stone100 = Color.fromARGB(255, 245, 245, 244);
  static const Color stone200 = Color.fromARGB(255, 231, 229, 228);
  static const Color stone300 = Color.fromARGB(255, 214, 211, 209);
  static const Color stone400 = Color.fromARGB(255, 168, 162, 158);
  static const Color stone500 = Color.fromARGB(255, 120, 113, 108);
  static const Color stone600 = Color.fromARGB(255, 87, 83, 78);
  static const Color stone700 = Color.fromARGB(255, 68, 64, 60);
  static const Color stone800 = Color.fromARGB(255, 41, 37, 36);
  static const Color stone900 = Color.fromARGB(255, 28, 25, 23);

  static const Color purple050 = Color.fromARGB(255, 250, 245, 255);
  static const Color purple100 = Color.fromARGB(255, 243, 232, 255);
  static const Color purple200 = Color.fromARGB(255, 233, 213, 255);
  static const Color purple300 = Color.fromARGB(255, 216, 180, 254);
  static const Color purple400 = Color.fromARGB(255, 192, 132, 252);
  static const Color purple500 = Color.fromARGB(255, 168, 85, 247);
  static const Color purple600 = Color.fromARGB(255, 147, 51, 234);
  static const Color purple700 = Color.fromARGB(255, 126, 34, 206);
  static const Color purple800 = Color.fromARGB(255, 107, 33, 168);
  static const Color purple900 = Color.fromARGB(255, 88, 28, 135);
}
