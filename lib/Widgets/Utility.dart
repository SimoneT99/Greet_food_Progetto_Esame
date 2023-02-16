import 'package:flutter/material.dart';

/**
 * Metodi di utility
 */

List<BottomNavigationBarItem> getBottomBarItems(){
  return [
    BottomNavigationBarItem(
        icon: Icon(Icons.punch_clock),
        label: 'Scadenze',
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Dispense',
    ),
  ];
}