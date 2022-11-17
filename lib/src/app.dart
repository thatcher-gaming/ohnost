import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Application {
  static late final FluroRouter router;
  static final ThemeData theme = ThemeData(
      textTheme: TextTheme(
    bodyLarge: GoogleFonts.robotoSerif(fontSize: 13),
    bodyMedium: GoogleFonts.robotoSerif(fontSize: 14, height: 1.4),
    bodySmall: GoogleFonts.robotoSerif(fontSize: 10),
    headlineMedium: GoogleFonts.robotoSerif(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
  ));
}
