import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'Utility.dart';

/**
 * Widget per la pagina di creazione dispense
 */

class PaginaCreazioneDispense extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PaginaCreazioneDispenseState();
  }
}

class PaginaCreazioneDispenseState extends State<PaginaCreazioneDispense>{

  final int _bottomBarIndex = 2;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBackAppbar(), //gestire il warning
      body: Text("TODO"),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomBarIndex,
        items : getBottomBarItems(),
      ),
    );
  }
}