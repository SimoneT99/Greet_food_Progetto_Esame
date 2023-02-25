import 'package:greet_food/Classes/Interfaces/Identifiable.dart';

/**
 * Classe rappresentante un prodotto nell'applicazione
 */

class Dispensa implements Identifiable{

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

}





//TODO REMOVE
Dispensa getDebugDispensa(){
  return Dispensa("debug", "Assets/PlaceholderImage.png", "una dispensa di debug", "posizioneDebug");
}