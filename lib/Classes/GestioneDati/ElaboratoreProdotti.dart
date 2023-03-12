import '../Items/Prodotto.dart';

/**
 * Classe con la responsabilità di eseguire delle operazioni sulle liste di prodotti
 */

class ElaboratoreProdotti{

  List<Prodotto> _currentList = [];

  ElaboratoreProdotti(List<Prodotto> listaProdotti){
    this._currentList = listaProdotti;
  }

  /**
   * Metodi dell'elaboratore
   */
  Prodotto getProdottoByBarcode(String barcode){
    for(int i = 0; i<_currentList.length; i++){
      if(_currentList[i].barcode != null){
        if(_currentList[i].barcode == barcode){
          return _currentList[i];
        }
      }
    }

    throw Exception("Nessun prodotto con tale codice a barre");
  }

  /**
   * Dato un nome di un prodotto viene ritornata la lista dei prodotti con
   * quel nome
   */
  List<Prodotto> filtraPerNome(String nome, {bool changeState  = false}){
    List<Prodotto> prodotti = [];
    for(int i = 0; i<_currentList.length; i++){
      if(_currentList[i].nome == nome){
        prodotti.add(_currentList[i]);
      }
    }
    if(changeState){
      this._currentList = prodotti;
    }
    return prodotti;
  }


  /**
   * Data la marca di un prodotto viene ritornata la lista dei prodotti con
   * quella marca
   */
  List<Prodotto> filtraPerMarca(String marca, {bool changeState  = false}){
    List<Prodotto> prodotti = [];
    for(int i = 0; i<_currentList.length; i++){
      if(_currentList[i].marca == marca){
        prodotti.add(_currentList[i]);
      }
    }
    if(changeState){
      this._currentList = prodotti;
    }
    return prodotti;
  }
}