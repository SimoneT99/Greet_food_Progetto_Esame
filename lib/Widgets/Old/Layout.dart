import 'package:flutter/material.dart';
import 'package:greet_food/main.dart';
import 'PaginaDispense.dart';
import 'PaginaScadenze.dart';
import 'PaginaHome.dart';

abstract class AppLayout extends StatefulWidget{
}


abstract class AppLayoutState<T extends AppLayout> extends State<T>{

  int _bottomBarIndex = 1; //default a 1 che è quella centrale

  final List<Widget> _bottomBarPages = <Widget>[
    PaginaScadenze(),
    PaginaHome(),
    PaginaDispense(),
  ];

  void _onBottomBarClick(int index){
    setState(() {
      _bottomBarIndex = index;
    });
  }

  @protected
  AppBar appBar(){
    print("_appBar: layout");
    return AppBar();
  }

  @protected
  Widget body(){
    print("_body: layout");
    return Scaffold();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
      // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomBarIndex,
        onTap: _onBottomBarClick,
        items : [
          BottomNavigationBarItem(
              icon: Icon(Icons.punch_clock),
              label: 'Scadenze',
              backgroundColor: (_bottomBarIndex == 0 ? Colors.blueGrey : Colors.white)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: (_bottomBarIndex == 1 ? Colors.blueGrey : Colors.white)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Dispense',
              backgroundColor: (_bottomBarIndex == 2 ? Colors.blueGrey : Colors.white)
          ),
        ],
      ),
    );
  }
}