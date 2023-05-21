import 'dart:io';

import 'package:flutter/material.dart';
import 'package:greet_food/Classes/Interfaces/Item.dart';

/**
 * Classe rappresentante un prodotto nell'applicazione
 */
class Prodotto implements Item{

  static String _DEFAULT_PRODOTTO_IMAGE = "Assets/Images/Picture.png";
  static int _currentCode = 0;

  int _id = 0;
  String _nome = "defaultName";
  String _marca = "defaultName";
  String _imagePath = "placeHolderPath";
  String _descripion = "defaultDescription";
  String? _barcode = "default";

  bool _alKg = false;

  Prodotto(
      {required String nome,
        required String marca,
        String imagePath = "",
        required String descripion,
        required String? barcode,
        required bool alKg}){
    this._nome = nome;
    this._marca = marca;
    if(imagePath == "") {
      this._imagePath = _DEFAULT_PRODOTTO_IMAGE;
    }else{
      this._imagePath = imagePath;
    }
    this._imagePath = imagePath;
    this._descripion = descripion;
    this._barcode = barcode;
    this._alKg = alKg;
  }

  /**
   * getter
   */

  static int get currentCode => _currentCode;

  int get id => _id;

  String get nome => _nome;

  String get marca => _marca;

  String get imagePath => _imagePath;

  String get descripion => _descripion;

  String? get barcode => _barcode;

  bool get alKg => _alKg;

  /**
   * Setter
   */

  set nome(String value) {
    _nome = value;
  }

  set marca(String value) {
    _marca = value;
  }

  set imagePath(String value) {
    _imagePath = value;
  }

  set descripion(String value) {
    _descripion = value;
  }

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

  /**
   * Serializzazione
   */

  Prodotto.fromJson(Map<String, dynamic> json){
    _id = json['_id'];
    _nome = json['_nome'];
    _marca = json['_marca'];
    _imagePath = json['_imagePath'];
    _descripion = json['_descripion'];
    _barcode = json['_barcode'];
  }

  Map<String, dynamic> toJson() => {
    '_id': _id,
    '_nome': _nome,
    '_marca': _marca,
    '_imagePath': _imagePath,
    '_descripion': _descripion,
    '_barcode': _barcode,
  };

  @override
  fromJson(Map<String, dynamic> json) {
    _id = json['_id'];
    _nome = json['_nome'];
    _marca = json['_marca'];
    _imagePath = json['_imagePath'];
    _descripion = json['_descripion'];
    _barcode = json['_barcode'];
  }

  @override
  refreshCode(int code) {
    this._id = code;
    Prodotto._currentCode = code + 1;
  }


  Image getImage(){
    Image image;
    if(this._imagePath != _DEFAULT_PRODOTTO_IMAGE) {
      File file = File(this._imagePath);
      image = Image.file(file);
    }
    else{
      image = Image.asset(_DEFAULT_PRODOTTO_IMAGE);
    }

    return image;
  }

}