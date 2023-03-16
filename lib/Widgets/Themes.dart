import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * GreetFood themes
 */

class GreetFoodTheme{


  /**
   * IL tema è pensato per combinare una buona visibilità dei soggetti anziani
   * ed una estetica che possa favorire l'idea dell'applicazione
   *
   * https://webflow.com/blog/best-color-combinations
   *
   * Island green & white
   */
  static Color _primaryColor = Color(0xFF2BAE66);
  static Color _secondaryColor = Color(0xFFFCF6F5);

  static ThemeData light(){

    return ThemeData(

      colorScheme: ColorScheme.light().copyWith(
        primary: _primaryColor,
        secondary: _secondaryColor,
      ),

      appBarTheme: AppBarTheme(
        foregroundColor: _secondaryColor,
        backgroundColor: _primaryColor,
        elevation: 2,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),

      tabBarTheme: const TabBarTheme(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        indicatorColor: Color(0xFF2BAE66),
      ),
    );
  }
}