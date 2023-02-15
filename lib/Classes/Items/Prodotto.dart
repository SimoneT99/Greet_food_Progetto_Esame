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
  String _barcode = "default";

  Prodotto(String nome, String marca, String imagePath, String descripion, String barcode){
    this._nome = nome;
    this._marca = marca;
    this._imagePath = imagePath;
    this._descripion = descripion;
    this._barcode = barcode;
  }


  @override
  bool checkCode(int code) {
    return (code == _id);
  }
}