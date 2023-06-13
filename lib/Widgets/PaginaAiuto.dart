import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/AppBars.dart';

/**
 * Pagina con informazioni per l'utente
 */

class PaginaAiuto extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar,
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
              "a destra nella schermata che appare premendo sfoglia prodotti"
  ),
  _Help(
      problem: "Come cambio il numero di giorni usati per considerare un alimento in scadenza?",
      answer: "Puoi cambiare il numero di giorni dalle impostazioni modificando il campo \"Giorni anticipo scadenza\"."
          "Puoi accedere a questo menù dalla home screen cliccando sull'icona a forma di ingranaggio"
  ),
  _Help(
      problem: "Come elimino una dispensa?",
      answer: "Puoi eliminare una dispensa tenendone premuta la card nella sezione dispense"
  ),
  _Help(
      problem: "Come modifico una dispensa o un prodotto?",
      answer: "Puo modificare una dispensa o un prodotto cliccando nell'icona in alto a destra nella"
          " pagina della dispensa o del prodotto che vui modificare"
  ),
  _Help(
      problem: "Come rimuovo un articolo da quelli che possiedo?",
      answer: "Innanzitutto trova l'articolo che vuoi rimuovere, puo cercarlo in una specifica dispensa "
          "o tra gli articoli scaduti/in scadeza. Quando lo hai trovato puoi cliccarci sopra e selezionare consuma/butta via"
  ),

];