import 'package:greet_food/Classes/Interfaces/Item.dart';

/**
 * Classe rappresentante un articolo
 */

String articoloTableName = 'Articolo';

class Articolo implements Item{

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
  bool _consumed = false;
  DateTime _consumedDate = DateTime.now();

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
      required double peso,
      required DateTime dataScadenza,
      required DateTime dataInserimento}){

    this._id = _currentCode++;

    this._idProdotto = idProdotto;
    this._idDispensa = idDispensa;
    this._prezzo = prezzo;
    this._weight = weight;
    this._consumed = false;
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
    _consumed = true;
  }

  bool isConsumed(){
   return _consumed;
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
    if(_consumed){
      return _consumedDate.isAfter(this.dataScadenza);
    }
    return DateTime.now().isAfter(this.dataScadenza);
  }

  /**
   * Altri metodi
   */
  bool ScadutoNonConsumato(){
    if(_consumed){
      return _consumedDate.isAfter(this.dataScadenza);
    }
    return DateTime.now().isAfter(this.dataScadenza);
  }


  /**
 * Serializzazione
 */

  Articolo.fromJson(Map<String, dynamic> json){
    _id = json['_id'];
    _idProdotto = json['_idProdotto'];
    _idDispensa = json['_idDispensa'];

    /**
     * Dati articolo obbligatori
     */
    _prezzo = json['_prezzo'];
    _dataScadenza =   DateTime.parse(json['_dataScadenza']);
    _dataInserimento =  DateTime.parse(json['_dataInserimento']);
    _consumed = json['_consumed'];
    _consumedDate =  DateTime.parse(json['_consumedDate']);

    /**
     * Dati articolo opzionali
     */
    _weight = json['_weight'];
  }

  Map<String, dynamic> toJson() => {
    '_id': _id,
    '_idProdotto': _idProdotto,
    '_idDispensa': _idDispensa,
    '_prezzo': _prezzo,
    '_dataScadenza': _dataScadenza.toString(),
    '_dataInserimento': _dataInserimento.toString(),
    '_consumed': _consumed,
    '_consumedDate': _consumedDate.toString(),
    '_weight': _weight,
  };

  @override
  fromJson(Map<String, dynamic> json) {
    _id = json['_id'];
    _idProdotto = json['_idProdotto'];
    _idDispensa = json['_idDispensa'];

    /**
     * Dati articolo obbligatori
     */
    _prezzo = json['_prezzo'];
    _dataScadenza = DateTime.parse(json['_dataScadenza']);
    _dataInserimento = DateTime.parse(json['_dataInserimento']);
    _consumed = json['_consumed'];
    _consumedDate = DateTime.parse(json['_consumedDate']);

    /**
     * Dati articolo opzionali
     */
    _weight = json['_weight'];
  }

  @override
  refreshCode(int code) {
    this._id = code;
    Articolo._currentCode = code + 1;
  }
}