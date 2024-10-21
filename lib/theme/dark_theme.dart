import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DarkTheme{

  ThemeData get darkTheme {
    return ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white12,
        hintColor: Colors.white54,

        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
        ),
        textTheme: TextTheme(
          titleMedium: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold
          ),
          titleSmall: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold
          ),
          titleLarge: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 30.sp,
              fontWeight: FontWeight.bold
          ),
          bodyMedium: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.normal
          ),
          bodySmall: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 12.sp,
              fontWeight: FontWeight.normal
          ),

        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(
            color: Colors.red,
          ),
          unselectedIconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: Colors.grey.shade900,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Colors.white
        ),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                iconColor: WidgetStatePropertyAll(Colors.white)
            )
        ),
      dividerColor: Colors.white24,
      // Define more dark theme properties here
    );
  }
}