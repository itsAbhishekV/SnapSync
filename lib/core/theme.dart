import 'package:flutter/material.dart';

final theme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Inter',
  primaryColor: Colors.deepPurple,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: Colors.deepPurple,
  appBarTheme: appBarTheme,
  snackBarTheme: snackBarTheme,
  scaffoldBackgroundColor: Colors.white,
);

const appBarTheme = AppBarTheme(
  titleTextStyle: TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  backgroundColor: Colors.white,
  centerTitle: true,
);

final snackBarTheme = SnackBarThemeData(
  backgroundColor: Colors.deepPurple,
  elevation: 8.0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),
  behavior: SnackBarBehavior.floating,
  contentTextStyle: const TextStyle(
    color: Colors.white,
  ),
  actionBackgroundColor: Colors.white,
);
