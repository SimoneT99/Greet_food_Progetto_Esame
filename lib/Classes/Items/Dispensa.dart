import 'dart:io';

import 'package:flutter/material.dart';
import 'package:greet_food/Classes/Interfaces/Item.dart';

/**
 * Classe rappresentante un prodotto nell'applicazione
 */

class Dispensa implements Item{

  static String _DEFAULT_DISPENSA_IMAGE = "Assets/Images/Picture.png";

  static int _currentCode = 0;

  int _id = 0;
  String _nome = "defaultName";
  String _imagePath = "placeHolderPath";
  String _descripion = "defaultDescription";
  String _posizione = "defaultPosition";

  Dispensa(String nome, String imagePath, String descripion, String posizione){
    this._id = _currentCode++;
    this._nome = nome;
    if(imagePath != ""){
      this._imagePath = imagePath;
    }else{
      this._imagePath = _DEFAULT_DISPENSA_IMAGE;
    }
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

  String get posizione => _posizione;

  int get id => _id;

  static int get currentCode => _currentCode;

  int getCode() {
    return this._id;
  }

  /**
   * Setter
   */

  set nome(String value) {
    _nome = value;
  }

  set imagePath(String value) {
    _imagePath = value;
  }

  set descripion(String value) {
    _descripion = value;
  }

  set posizione(String value) {
    _posizione = value;
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

  Image getImage(){
    Image image;
    if(this._imagePath != _DEFAULT_DISPENSA_IMAGE) {
      File file = File(this._imagePath);
      image = Image.file(file);
    }
    else{
      image = Image.asset(_DEFAULT_DISPENSA_IMAGE);
    }

    return image;
  }

}