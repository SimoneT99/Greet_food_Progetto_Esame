import 'package:greet_food/Classes/Interfaces/Identifiable.dart';

/**
 * Classe rappresentante un articolo
 */

String articoloTableName = 'Articolo';

class Articolo implements Identifiable{

  static int _currentCode = 0;

  /**
   * IDs
   */
  int _id = 0;
  int _idProdotto = 0;
  int _idDispensa = 0;

  /**
   * Dati articolo obbligatori
   */
  double _prezzo = 0;
  DateTime _dataScadenza = DateTime.now();
  DateTime _dataInserimento = DateTime.now();
  bool consumed = false;
  DateTime consumedDate = DateTime.now();

  /**
   * Dati articolo opzionali
   */
  double _weight = -1;


  /**
   * Costruttore
   */

  Articolo(
      {required int idProdotto,
      required int idDispensa,
      required double prezzo,
        double peso = -1,
      required DateTime dataScadenza,
      required DateTime dataInserimento}){
    this._id = _currentCode++;
    this._idProdotto = idProdotto;
    this._idDispensa = idDispensa;
    this._prezzo = prezzo;
    this._weight = weight;
    this.consumed = false;
    this._dataInserimento = dataInserimento;
    this._dataScadenza = dataScadenza;
  }

  @override
  bool checkCode(int code) {
    return (code == _id);
  }

  /**
   * Consumo articoli
   */

  void consume(){
    consumed = true;
  }

  bool isConsumed(){
   return consumed;
  }

  /**
   * Getter
   */

  DateTime get dataScadenza => _dataScadenza;

  DateTime get dataInserimento => _dataInserimento;

  double get weight => _weight;

  double get prezzo => _prezzo;

  int get idDispensa => _idDispensa;

  int get idProdotto => _idProdotto;

  @override
  int getCode() {
    return this._id;
  }

  /**
   * Altri metodi
   */
  bool lasciatoScadere(){
    if(consumed){
      return consumedDate.isAfter(this.dataScadenza);
    }
    return DateTime.now().isAfter(this.dataScadenza);
  }

  /**
   * Altri metodi
   */
  bool ScadutoNonConsumato(){
    if(consumed){
      return consumedDate.isAfter(this.dataScadenza);
    }
    return DateTime.now().isAfter(this.dataScadenza);
  }
}