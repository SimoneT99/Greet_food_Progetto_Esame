import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';

/**
 * Pagina con informazioni per l'utente
 */

class PaginaAiuto extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBackAppbar(),
      body: ListView.builder(
        itemCount: _tips.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpansionTile(
              title: Text(_tips[index]._problem),
              children: <Widget>[
                ListTile(title: Text(_tips[index]._answer)),
              ],
            );
          }
      ),
    );
  }
}

class _Help{
  late final String _problem;
  late final String _answer;

  _Help({required String problem, required String answer}){
    this._problem = problem;
    this._answer = answer;
  }
}


/**
 * Lista di aiuti a disposizione dell'utente
 */
List<_Help> _tips = <_Help>[

  _Help(
    problem: "Come aggiungo una dispensa?",
    answer: "Vai nella sezione dispense e premi il pulsante aggiungi"
  ),
  _Help(
      problem: "Come aggiungo un prodotto?",
      answer: "Puoi aggiungere un prodotto scannerizzandone uno per la prima volta "
              "se questo ha un codice a barre, oppure premendo nell'icona in alto"
              "a destra nella schermata che appare premendo su no codice"
  ),
  _Help(
      problem: "TODO",
      answer: "TODO"
  ),
  _Help(
      problem: "TODO",
      answer: "TODO"
  ),
  _Help(
      problem: "TODO",
      answer: "TODO"
  ),
  _Help(
      problem: "TODO",
      answer: "TODO"
  ),
  _Help(
      problem: "TODO",
      answer: "TODO"
  ),
  _Help(
      problem: "TODO",
      answer: "TODO"
  ),
];