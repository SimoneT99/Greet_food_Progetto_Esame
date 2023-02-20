import 'package:greet_food/Classes/Items/Articolo.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';
import 'package:greet_food/Classes/Items/Prodotto.dart';

/**
 * Classe che gestise gli articoli
 */

class ManagerArticoli extends ChangeNotifier{

  List<Articolo> _articoli = [];

  /**
   * Aggiunta di un articolo
   */
  void addArticolo(Articolo articolo) {
    this._articoli.add(articolo);
    this.notifyListeners();
  }

  /**
   * Aggiunta di più di un articolo
   */
  void addArticoli(List<Articolo> articoli) {
    this._articoli + articoli;
    this.notifyListeners();
  }


  /**
   * Un articolo non viene mai effettivamente rimosso ma si segna solo lo stato come consumato
   */
  void removeArticolo(int id){
    for (int i = 0; i < _articoli.length; i++) {
      if (_articoli[i].checkCode(id)) {
        _articoli[i].consume();
      }
    }
    this.notifyListeners();
  }

  void updateArticolo(Articolo articolo){
    //TODO
    this.notifyListeners();
  }

  List<Articolo> getAllArticoli({orderedByName = false}){
    return _articoli;
  }

  List<Articolo> getAllArticoliNonConsumati({orderedByName = false}){

    List<Articolo> notConsumed = <Articolo>[];

    for (int i = 0; i < _articoli.length; i++) {
      if (_articoli[i].isConsumed()) {
        notConsumed.add(_articoli[i]);
      }
    }
    return notConsumed;
  }

  /**
   * Gestione scadenze
   */

  List<Articolo> getArticoliInScadenza(int intervalDays, {orderedByName = false}){

    List<Articolo> inScadenza = <Articolo>[];

    for (int i = 0; i < _articoli.length; i++) {
      if (_articoli[i].dataScadenza.isBefore(DateTime.now().add(Duration(days: intervalDays))) &&
          !(_articoli[i].isConsumed())){
        inScadenza.add(_articoli[i]);
      }
    }
    return inScadenza;
  }

  List<Articolo> getArticoliScaduti({orderedByName = false}){

    List<Articolo> scaduti = <Articolo>[];

    for (int i = 0; i < _articoli.length; i++) {
      if (_articoli[i].dataScadenza.isBefore(DateTime.now()) &&
          !(_articoli[i].isConsumed())){
        scaduti.add(_articoli[i]);
      }
    }
    return scaduti;
  }

  /**
   * Dato un id di una dispensa viene ritornata la dispensa con tale codice se presente
   * altrimenti viene ritornato null
   */
  Articolo? getArticolo(int code) {
    for (int i = 0; i < _articoli.length; i++) {
      if (_articoli[i].checkCode(code)) {
        return _articoli[i];
      }
    }
    return null;
  }

  List<Articolo> getArticoliDispensa(Dispensa dispensa) {
    //TODO
    return [
      Articolo(0, 0, 0, 0, DateTime.now()),
      Articolo(0, 0, 0, 0, DateTime.now()),
      Articolo(0, 0, 0, 0, DateTime.now()),
      Articolo(0, 0, 0, 0, DateTime.now()),
    ];
  }

  List<Articolo> getArticoliScadutiFinoOggi(Dispensa dispensa) {
    //TODO
    return [];
  }

  Prodotto getProdottoPreferito(Dispensa dispensa) {
    //TODO
    return Prodotto("default", "marca_default", "imagePath", "descr", "sdasd");
  }
}