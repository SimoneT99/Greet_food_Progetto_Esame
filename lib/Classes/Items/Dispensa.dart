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

  Dispensa(String nome, String imagePath, String descripion){
    this._id = _currentCode++;
    this._nome = nome;
    this._imagePath = imagePath;
    this._descripion = _descripion;
  }

  @override
  bool checkCode(int code) {
    // TODO: implement checkCode
    throw UnimplementedError();
  }

/**
 * Getter
 */
  String get descripion => _descripion;

  String get imagePath => _imagePath;

  String get nome => _nome;

  int get id => _id;

  static int get currentCode => _currentCode;

}





//TODO REMOVE
Dispensa getDebugDispensa(){
  return Dispensa("debug", "Assets/PlaceholderImage.png", "una dispensa di debug");
}