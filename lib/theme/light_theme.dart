import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LightTheme{

  ThemeData get lightTheme {
    return ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black12,
        hintColor: Colors.black54,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black
        ),
        textTheme: TextTheme(
          titleMedium: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.normal,
          ),
          bodySmall: GoogleFonts.poppins(
            color: Colors.black54,
            fontSize: 12.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.black,
          selectedIconTheme: IconThemeData(
            color: Colors.pink,
          ),
          unselectedIconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.black,
        ),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                iconColor: WidgetStatePropertyAll(Colors.black)
            )
        ),
      dividerColor: Colors.black26,

      // Define more light theme properties here
    );

  }
}