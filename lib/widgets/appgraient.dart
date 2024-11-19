import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xff6A42BF),
      Color(0xff271748),
      Colors.black,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient secondaryGradient = LinearGradient(colors: [
    Color.fromARGB(255, 91, 55, 168),
    Color.fromARGB(255, 60, 36, 112),
    Color.fromARGB(255, 40, 22, 77),
    Color.fromARGB(255, 20, 6, 48)
  ], end: Alignment.bottomCenter, begin: Alignment.topCenter);
  static const LinearGradient thirdGradient = LinearGradient(colors: [
          Color(0xff704BBE),
          Color(0xff43297A),
          Color(0xff19093B),
          Colors.black
        ], begin: Alignment.topLeft);
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
}