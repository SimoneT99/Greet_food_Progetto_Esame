import 'package:flutter/material.dart';
import '../Enumerations.dart';

/**
 * Appbar solo con il titolo dell'applicazione
 */

const String APP_NAME = "GreetFood";

class AppBarFactory{

  static AppBar getEmptyAppbar({text = APP_NAME}){
    return AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      toolbarHeight: 50,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text)
        ],
      ),
    );
  }

  static AppBar getSideMenuAppbar(){

    //TODO

    return AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(APP_NAME)
        ],
      ),
    );
  }

  /**
   * Appbar con pulsante per tornare indietro
   */
  static AppBar getBackAppbar(){

    return AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(APP_NAME)
        ],
      ),
      leading: BackButton(
        color: Colors.black,
      ),
    );
  }


  /**
   * Metodo con la responsabilità di passare la top bar adatta alla sezione desiderata
   */
  static AppBar getAppbar(MainSections section){
    switch (section) {
      case MainSections.scadenze:
        return getEmptyAppbar(text: "scadenze");
        break;
      case MainSections.home:
        return getEmptyAppbar(text: "home");
        break;
      case MainSections.dispense:
        return getEmptyAppbar(text: "dispense");
        break;
    }
  }
}
