import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'package:flutter/foundation.dart';
import 'package:greet_food/Widgets/PaginaAggiuntaArticolo.dart';


/**
 * Sezione home dell'applicazione
 */

class Homepage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HomeScreenbuttonContainer(child: AggiungiArticolo()),
            HomeScreenbuttonContainer(child: CercaProdotto()),
            HomeScreenbuttonContainer(
                child: SplittedContainterButtons(
                  left_child: Aiuto(),
                  right_child: Impostazioni(),
                )
            ),
          ],
        ),
      );
    }
}

/**
 * Container per i pulsanti della home screen
 */

class HomeScreenbuttonContainer extends StatelessWidget {

  final Widget child;


  HomeScreenbuttonContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.4,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        child: this.child,
      ),
    );
  }
}

/**
 * Pulsanti principali della home page
 */

class AggiungiArticolo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _button_pressed(context);
      },
      child: Text("Aggiungi articolo"),
    );
  }

  void _button_pressed(BuildContext context){
    debugPrint("richiesta aggiunta articolo");
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) {
          return PaginaAggiuntaArticolo();
        }
    ));
  }
}

class CercaProdotto extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _button_pressed,
      child: Text("Cerca prodotto"),
    );
  }

  void _button_pressed(){
    debugPrint("richiesta ricerca prodotto");
  }
}

/**
 * Pulsanti secondari della home page
 */

class SplittedContainterButtons extends StatelessWidget{

  final Widget left_child;
  final Widget right_child;

  SplittedContainterButtons({required this.left_child, required this.right_child});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 13.0),
            child: left_child,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: right_child,
          ),
        )
      ],
    );
  }
}

class Aiuto extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {print("richiesta aggiunta articolo"); },
      child: Text("Aiuto"),
    );
  }
}

class Impostazioni extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {print("richiesta aggiunta articolo"); },
      child: Text("Settings"),
    );
  }
}