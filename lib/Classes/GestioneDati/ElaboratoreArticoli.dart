import 'package:greet_food/Classes/Items/Prodotto.dart';

import '../Items/Articolo.dart';
import '../Items/Dispensa.dart';

/**
 * Classe che ha la responsabilità di elaborare delle liste di articoli
 */

class EleboratoreArticoli{

  List<Articolo> lista_articoli = [];

  EleboratoreArticoli(this.lista_articoli);

  /**
   * Cambiare la lista degli articoli dell'elaboratore
   * I filtri verranno poi applicati a questa lista
   */
  void setListaArticoli(List<Articolo> lista){
    this.lista_articoli = lista;
  }

  /**
   * Ottenere gli articoli scaduti
   */
  List<Articolo> filtraPerArticoliScaduti(){
    List<Articolo> articoli_scaduti = [];
    for(int i = 0; i<lista_articoli.length; i++){
      if(_scaduto(lista_articoli[i])){
        articoli_scaduti.add(lista_articoli[i]);
      }
    }
    return articoli_scaduti;
  }

  bool _scaduto(Articolo articolo){
    return articolo.dataScadenza.isBefore(DateTime.now());
  }

  /**
   * Ottenere gli articoli in scadenza
   */
  List<Articolo> filtraPerArticoliInScadenza(int intervalloGiorni){
    List<Articolo> articoli_in_scadenza = [];
    for(int i = 0; i<lista_articoli.length; i++){
      if(_inScadenza(lista_articoli[i], intervalloGiorni)){
        articoli_in_scadenza.add(lista_articoli[i]);
      }
    }
    return articoli_in_scadenza;
  }

  bool _inScadenza(Articolo articolo, int daysInterval){
    return articolo.dataScadenza.isBefore(DateTime.now().add(new Duration(days: daysInterval)));
  }

  /**
   * Ottenere gli articoli filtrati per uno specifico prodotto
   */
  List<Articolo> filtraPerProdotto(Prodotto prodotto){
    List<Articolo> articoliFiltrati = [];
    for(int i = 0; i<lista_articoli.length; i++){
      if(lista_articoli[i].idProdotto == prodotto.id){
        articoliFiltrati.add(lista_articoli[i]);
      }
    }
    return articoliFiltrati;
  }

  List<Articolo> filtraPerIdProdotto(int id_prodotto){
    List<Articolo> articoliFiltrati = [];
    for(int i = 0; i<lista_articoli.length; i++){
      if(lista_articoli[i].idProdotto == id_prodotto){
        articoliFiltrati.add(lista_articoli[i]);
      }
    }
    return articoliFiltrati;
  }

  /**
   * Ottenere gli articoli filtrati per una specifica dispensa
   */
  List<Articolo> filtraPerDispensa(Dispensa dispensa){
    List<Articolo> articoliFiltrati = [];
    for(int i = 0; i<lista_articoli.length; i++){
      if(lista_articoli[i].idDispensa == dispensa.id){
        articoliFiltrati.add(lista_articoli[i]);
      }
    }
    return articoliFiltrati;
  }

  List<Articolo> filtraPerIdDispensa(int id_dispensa){
    List<Articolo> articoliFiltrati = [];
    for(int i = 0; i<lista_articoli.length; i++){
      if(lista_articoli[i].idDispensa == id_dispensa){
        articoliFiltrati.add(lista_articoli[i]);
      }
    }
    return articoliFiltrati;
  }

  /**
   * Ottenere gli articoli lasciati scadere
   * (tutti gli articoli che sono scaduti o chesono stati consumati dopo la data
   * di scadenza)
   */

  List<Articolo> filtraPerLasciatiScadere(){
    List<Articolo> articoliLasciatiScadere = [];
    for(int i = 0; i<lista_articoli.length; i++){
      if(lista_articoli[i].lasciatoScadere()){
        articoliLasciatiScadere.add(lista_articoli[i]);
      }
    }
    return articoliLasciatiScadere;
  }

  /**
   * Ottenere gli articoli consumati (o non)
   */

  List<Articolo> filtraPerConsumati({bool consumato = true}){
    List<Articolo> articoli = [];
    for(int i = 0; i<lista_articoli.length; i++){
      if(lista_articoli[i].isConsumed() == consumato){
        articoli.add(lista_articoli[i]);
      }
    }
    return articoli;
  }

}