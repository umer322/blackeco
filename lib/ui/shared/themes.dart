

import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primaryColorLight: Colors.grey[200],
    primaryColorDark: Colors.black,
    canvasColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black)
    ),
    primaryColor: Color(0xfff8b633),
    accentColor: Colors.grey[300],
    hintColor: Colors.grey,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(0xfff8b633),
      selectionHandleColor: Color(0xfff8b633),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xfff8b633))),
    ),
    primarySwatch: Colors.blue,
    iconTheme: IconThemeData(color: Colors.black),
    buttonColor: Colors.green,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    primaryColorLight: Colors.black54,
    primaryColorDark: Colors.white,
    canvasColor: Colors.black,
    appBarTheme: AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white)
    ),
    primaryColor: Color(0xfff8b633),
    accentColor: Colors.grey[400],
    hintColor: Colors.grey,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(0xfff8b633),
      selectionHandleColor: Color(0xfff8b633),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xfff8b633))),
    ),
    primarySwatch: Colors.blue,
    shadowColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    buttonColor: Colors.green,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
      ),
      headline5: TextStyle(
        color: Colors.white,
      ),
      headline4: TextStyle(
        color: Colors.white,
      ),
      headline3: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}