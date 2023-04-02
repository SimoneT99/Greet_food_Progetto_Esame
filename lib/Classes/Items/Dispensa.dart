import 'package:greet_food/Classes/Interfaces/Item.dart';

/**
 * Classe rappresentante un prodotto nell'applicazione
 */

class Dispensa implements Item{

  static int _currentCode = 0;

  int _id = 0;
  String _nome = "defaultName";
  String _imagePath = "placeHolderPath";
  String _descripion = "defaultDescription";
  String _posizione = "defaultPosition";

  Dispensa(String nome, String imagePath, String descripion, String posizione){
    this._id = _currentCode++;
    this._nome = nome;
    this._imagePath = imagePath;
    this._descripion = descripion;
    this._posizione = posizione;
  }

  @override
  bool checkCode(int code) {
    return this._id == code;
  }

/**
 * Getter
 */
  String get descripion => _descripion;

  String get imagePath => _imagePath;

  String get nome => _nome;

  int get id => _id;

  static int get currentCode => _currentCode;

  int getCode() {
    return this._id;
  }

/**
 * Controlli
 */
  bool hasImage(){
    return imagePath!="";
  }

//Serializzazione

  Dispensa.fromJson(Map<String, dynamic> json){
    _id = json['_id'];
    _nome = json['_nome'];
    _imagePath = json['_imagePath'];
    _descripion = json['_descripion'];
    _posizione = json['_posizione'];
  }

  Map<String, dynamic> toJson() => {
    '_id': _id,
    '_nome': _nome,
    '_imagePath': _imagePath,
    '_descripion': _descripion,
    '_posizione': _posizione,
  };

  @override
  fromJson(Map<String, dynamic> json) {
    _id = json['_id'];
    _nome = json['_nome'];
    _imagePath = json['_imagePath'];
    _descripion = json['_descripion'];
    _posizione = json['_posizione'];
  }

  @override
  refreshCode(int code) {
    this._id = code;
    Dispensa._currentCode = code + 1;
  }

}