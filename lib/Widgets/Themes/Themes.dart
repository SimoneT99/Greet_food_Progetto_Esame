import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/**
 * GreetFood themes
 */

class GreetFoodTheme{

  static TextTheme testo = TextTheme(
    headline1: GoogleFonts.nunito(
        fontSize: 102,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5
    ),
    headline2: GoogleFonts.nunito(
        fontSize: 64,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5
    ),
    headline3: GoogleFonts.nunito(
        fontSize: 51,
        fontWeight: FontWeight.w400
    ),
    headline4: GoogleFonts.nunito(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25
    ),
    headline5: GoogleFonts.nunito(
        fontSize: 25,
        fontWeight: FontWeight.w400
    ),
    headline6: GoogleFonts.nunito(
        fontSize: 21,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15
    ),
    subtitle1: GoogleFonts.nunito(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15
    ),
    subtitle2: GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1
    ),
    bodyText1: GoogleFonts.nunitoSans(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5
    ),
    bodyText2: GoogleFonts.nunitoSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25
    ),
    button: GoogleFonts.nunitoSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25
    ),
    caption: GoogleFonts.nunitoSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4
    ),
    overline: GoogleFonts.nunitoSans(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5
    ),
  );

  /**
   * IL tema è pensato per combinare una buona visibilità dei soggetti anziani
   * ed una estetica che possa favorire l'idea dell'applicazione
   *
   * https://webflow.com/blog/best-color-combinations
   *
   * Island green & white
   * (modificati)
   */
  static Color _primaryColor = const Color(0xFF1B9653);
  static Color _primaryColorDark = const Color(0xFF06381B);
  static Color _secondaryColor1 = const Color(0xFFFCF6F5);
  static Color _secondaryColor2 = const Color(0xFFDCD4D4);


  static ThemeData light(){

    return ThemeData(

      primaryColorDark: _primaryColorDark,
      primaryColor: _primaryColor,

      colorScheme: ColorScheme.light().copyWith(
        primary: _primaryColor,
        secondary: _secondaryColor1,
      ),

      scaffoldBackgroundColor: _secondaryColor2,

      //AppBar
      appBarTheme: AppBarTheme(
        elevation: 2,
        centerTitle: true,
        titleTextStyle: testo.headline5?.copyWith(
          color: _primaryColor,
        ),
        backgroundColor: _secondaryColor1,
        foregroundColor: _primaryColor,
      ),

      //BottomBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 4,
        selectedIconTheme: IconThemeData(
          size: 30
        ),
        selectedLabelStyle: testo.caption,
        backgroundColor: _secondaryColor1,
      ),

      //Elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: _secondaryColor1,
            textStyle: testo.button?.copyWith(
              fontSize: 20,
            ),
            shadowColor: _primaryColor,
            elevation: 4,
          )
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: _primaryColor
          )
        )
      ),

      tabBarTheme: const TabBarTheme(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        indicatorColor: Color(0xFF2BAE66),
      ),

      cardColor: _secondaryColor1,

      //Tema delle card
      cardTheme: CardTheme(
        color: _secondaryColor1,
        shadowColor: _secondaryColor2,
        elevation: 5,
        margin: EdgeInsets.all(10.0)
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: _secondaryColor2,
        width: 200,
        shadowColor: _secondaryColor2,
      ),

      listTileTheme: ListTileThemeData(
        tileColor: _secondaryColor1,
        minVerticalPadding: 10
      )


    );
  }
}