import 'package:flutter/cupertino.dart';
import 'package:greet_food/Classes/Items/Articolo.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';
import 'package:greet_food/Classes/Items/Prodotto.dart';


/**
 * Classe che si occupa di genereare i widget per gli item che vanno visualizzati
 * in tale modo
 */

class FeedBuilder{

  /**
   * Data una lista di articoli viene prodotta una lista di widget che
   * rappresentano gli articoli
   */
  List<Widget> getFeedArticoli(List<Articolo> articoli){

    return [Text("Todo")];
  }

  /**
   * Data una lista di prodotti viene prodotta una lista di widget che
   * rappresentano gli prodotti
   */
  List<Widget> getFeedProdotti(List<Prodotto> prodotti){

    return [Text("Todo")];
  }

  /**
   * Data una lista di dispense viene prodotta una lista di widget che
   * rappresentano gli dispense
   */
  List<Widget> getFeedDispense(List<Dispensa> dispense){

    return [Text("Todo")];
  }
}