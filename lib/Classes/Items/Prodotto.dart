import 'package:greet_food/Classes/Interfaces/Identifiable.dart';

/**
 * Classe rappresentante un prodotto nell'applicazione
 */
class Prodotto implements Identifiable{

  static int _currentCode = 0;

  int _id = 0;
  String _nome = "defaultName";
  String _marca = "defaultName";
  String _imagePath = "placeHolderPath";
  String _descripion = "defaultDescription";
  String? _barcode = "default";

  bool _alKg = false;

  Prodotto(String nome, String marca, String imagePath, String descripion, String? barcode, bool alKg){
    this._nome = nome;
    this._marca = marca;
    this._imagePath = imagePath;
    this._descripion = descripion;
    this._barcode = barcode;
    this._alKg = alKg;
  }


  static int get currentCode => _currentCode;

  int get id => _id;

  String get nome => _nome;

  String get marca => _marca;

  String get imagePath => _imagePath;

  String get descripion => _descripion;

  String? get barcode => _barcode;

  bool get alKg => _alKg;

  /**
   * Identificazione
   */
  @override
  bool checkCode(int code) {
    return (code == _id);
  }

  int getCode() {
    return this._id;
  }
}