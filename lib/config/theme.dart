import 'package:flutter/material.dart';

const Color lightColor= Color.fromARGB(255, 9, 130, 56);
const Color lightColor2= Color(0xFFA8F2BF); 
const Color darkColor= Color(0xFFFF6D00);
const Color darkColor2= Color(0xFFF7CCAC);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: lightColor,
    brightness: Brightness.light,
    ).copyWith(
      primary: lightColor,
      secondary: lightColor2,
      surface: const Color(0xFFFBFBFF),
  ),
  scaffoldBackgroundColor: const Color(0xFFF3F4F9),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightColor, // Botón azul
      foregroundColor: Colors.white, // Texto blanco
      elevation: 2,
    ),
  )
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: darkColor,
    brightness: Brightness.dark,
  ).copyWith(
    primary: darkColor,
    secondary: darkColor2,
    surface: const Color(0xFF222326),
  ),
  scaffoldBackgroundColor: const Color(0xFF1A1B1E),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkColor, // Botón azul
      foregroundColor: Colors.white, // Texto blanco
      elevation: 2,
    ),
  )
);
