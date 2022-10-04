import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final lightMode = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    primaryColor: Colors.green,
    brightness: Brightness.light,
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.green, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
      fillColor: Colors.white,
    ),
  );
  static final darkMode = ThemeData(
    scaffoldBackgroundColor: const Color(0xff1f1f21),
    backgroundColor: Color(0xff1f1f21),
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.green, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
      fillColor: const Color(0xff1f1f21),
    ),
  );
  TextStyle get subtitleStyle {
    return GoogleFonts.bitter(
      fontSize: 18,
      color: Colors.grey,
    );
  }

  TextStyle get titleStyle {
    return GoogleFonts.bitter(fontSize: 20, fontWeight: FontWeight.bold);
  }

  TextStyle get dateStyle {
    return GoogleFonts.bitter(fontSize: 18, fontWeight: FontWeight.w500);
  }

  TextStyle get dayStyle {
    return GoogleFonts.bitter(fontSize: 12, fontWeight: FontWeight.w500);
  }

  TextStyle get monthStyle {
    return GoogleFonts.bitter(fontSize: 12, fontWeight: FontWeight.w500);
  }

  TextStyle get labelStyle {
    return GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500);
  }
}
