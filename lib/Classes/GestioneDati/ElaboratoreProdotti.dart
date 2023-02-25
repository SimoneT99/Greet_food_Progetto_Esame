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
}