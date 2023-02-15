import 'package:flutter/material.dart';
import '../Items/Prodotto.dart';

/**
 * Classe che gestise le dispense
 * Usare il metodo istance() per accedere all'istanza
 */

class ManagerProdotti extends ChangeNotifier{

  List<Prodotto> _prodotti = [];

  /**
   * Aggiunta di una dispensa
   */
  void addProdotto(Prodotto prodotto) {
    //TODO logica creazione dispensa
    this.notifyListeners();
  }

  void removeProdotto(String id){
    //TODO logica cancellazione dispensa
    this.notifyListeners();
  }

  void updateProdotto(String id){
    //TODO logica modifica dispensa
    this.notifyListeners();
  }

  List<Prodotto>? getAllProdotti({orderedByName = false}){
    return _prodotti;
  }


  /**
   * Dato un id di una dispensa viene ritornata la dispensa con tale codice se presente
   * altrimenti viene ritornato null
   */
  Prodotto? getProdotto(int code){
    for(int i=0; i<_prodotti.length; i++){
      if(_prodotti[i].checkCode(code)){
        return _prodotti[i];
      }
    }
    return null;
  }
}