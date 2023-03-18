import 'package:flutter/material.dart';
import 'Enumerations.dart';

/**
 * Appbar solo con il titolo dell'applicazione
 */

const String APP_NAME = "GreetFood";
const double HEIGHT = 50;

/**
 * Appbar preimpostate
 */
AppBar emptyAppbar = AppBar(
  toolbarHeight: HEIGHT,
  title: Text(APP_NAME),
);

AppBar backAppbar = AppBar(
  toolbarHeight: HEIGHT,
  title: Text(APP_NAME),
  leading: BackButton(),
);

AppBar endFormAppbar (void Function()? action) {
  return AppBar(
    toolbarHeight: HEIGHT,
    title: Text(APP_NAME),
    leading: BackButton(),
    actions: [
      Container(
        padding: EdgeInsets.all(10),
        child: OutlinedButton(
          onPressed: action,
          child: const Text('Fine'),
        ),
      ),
    ],
  );
}