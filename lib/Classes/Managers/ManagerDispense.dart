import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Items/Dispensa.dart';

/**
 * Classe che gestise le dispense
 * Usare il metodo istance() per accedere all'istanza
 */

class ManagerDispense extends ChangeNotifier{

  List<Dispensa> _dispense = [getDebugDispensa(),
    getDebugDispensa(),
    getDebugDispensa(),
    getDebugDispensa(),
    getDebugDispensa(),
    getDebugDispensa(),
    getDebugDispensa(),
    getDebugDispensa(),
  ];

  /**
   * Aggiunta di una dispensa
   */
  void addDispensa(Dispensa dispensa) {
    //TODO logica creazione dispensa
    this.notifyListeners();
  }

  void removeDispensa(String id){
    //TODO logica cancellazione dispensa
    this.notifyListeners();
  }

  void updateDispensa(String id){
    //TODO logica modifica dispensa
    this.notifyListeners();
  }

  List<Dispensa> getAllDispense({orderedByName = false}){
    if(kDebugMode){
      print("ManagerDipepense: requested all dispense");
    }

    return List.unmodifiable(_dispense);
  }

  /**
   * Dato un id di una dispensa viene ritornata la dispensa con tale codice se presente
   * altrimenti viene ritornato null
   */
  Dispensa? getDispensa(int code){
    for(int i=0; i<_dispense.length; i++){
      if(_dispense[i].checkCode(code)){
        return _dispense[i];
      }
    }
    return null;
  }
}