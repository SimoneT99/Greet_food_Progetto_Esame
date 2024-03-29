import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';
import 'package:greet_food/Classes/Items/Prodotto.dart';
import 'package:greet_food/Classes/Items/Articolo.dart';
import 'package:path_provider/path_provider.dart';
import '../Interfaces/Item.dart';

/**
 * Classe generica per gestire i dati senza duplicazione di codice
 * -> Probabilmente sarebbe meglio passare ad un database
 */

class GenericManager<T extends Item> extends ChangeNotifier{

  /**
   * Ogni manager contiene una lista degli elementi che deve gestire
   */
  List<T> _elements = [];

  /**
   * Path per salvare i dati
   */
  String _path = '';

  int _next_code = 0;

  /**
   * Metodi del manager
   */

  /**
   * Ottenere un elemento dato l'ID
   * Eccezione se non c'è un elemento con tale ID
   */
  T getElementById(int code){
    for(int i = 0; i<_elements.length; i++){
      if (_elements[i].checkCode(code)){
        return _elements[i];
      }
    }
    throw Exception("Nessun elemento con questo codice");
  }

  /**
   * Ottenere tutti gli elementi
   */
  List<T> getAllElements(){
    return List.unmodifiable(_elements);
  }

  /**
   * Aggiungere un'elemento alla lista degli elementi gestiti
   */
  void addElement(T newElement, {bool notifyListeners = true, bool saveToDisk = true}){

    if(newElement.getCode() < _next_code){
      debugPrint("duplicated code, trying to correct error");
      newElement.refreshCode(this._next_code);
    }

    for(int i = 0; i<_elements.length; i++){
      if (_elements[i].checkCode(newElement.getCode())){
        //Soluzione MOLTO brutta ma per ora funziona...
        int max_code = this._maxCode();
        newElement.refreshCode(max_code + 1);
        this._next_code = max_code + 1;
      }
    }
    _elements.add(newElement);
    this._next_code++;
    if(notifyListeners){
      this.notifyListeners();
    }
    if(saveToDisk){
      this.saveToDisk();
    }
  }

  /**
   * Rimuovere un elemento dato l'id
   * Eccezione se l'elemento non è presente
   */
  void removeElementById(int code, {bool notifyListeners = true, bool saveToDisk = true}){
    int index = -1;
    for(int i = 0; i<_elements.length; i++){
      if (_elements[i].checkCode(code)){
        index = i;
      }
    }
    if(index == -1){
      throw Exception("Nessun elemento con questo ID");
    }
    _elements.removeAt(index);
    if(notifyListeners){
      this.notifyListeners();
    }
    if(saveToDisk){
      this.saveToDisk();
    }
  }

  /**
   * Rimuovere un elemento dato l'id
   * Eccezione se l'elemento non è presente
   */
  void removeElement(T element, {bool notifyListeners = true, bool saveToDisk = true}){
    int index = -1;
    for(int i = 0; i<_elements.length; i++){
      if (_elements[i].checkCode(element.getCode())){
        index = i;
      }
    }
    if(index == -1){
      throw Exception("Nessun elemento con questo ID");
    }
    _elements.removeAt(index);
    if(notifyListeners){
      this.notifyListeners();
    }
    if(saveToDisk){
      this.saveToDisk();
    }
  }

  /**
   * Rimuovere un elemento dato l'id
   * Eccezione se l'elemento non è presente
   */
  void replaceElement(T newElement){
    for(int i = 0; i<_elements.length; i++){
      if (_elements[i].checkCode(newElement.getCode())){
        _elements[i] =  newElement;
        this.saveToDisk();
        this.notifyListeners();
        return;
      }
    }
    this.notifyListeners();
    this.saveToDisk();
    throw Exception("Nessun elemento con questo ID");
  }

  /**
   * Salvataggio e caricamento
   */

  Future<void> fromDisk(String passedPath) async {
     try{
       final directory = await getApplicationDocumentsDirectory();
       String completePath = directory.path + '/' + passedPath;
       File file = File(completePath);
       String jsonFile;
       jsonFile = await file.readAsString();
       print("$jsonFile");
       print("${jsonDecode(jsonFile)}");
       final data = jsonDecode(jsonFile);

       /**
        * Soluzione brutta... ...ma dart non permette di istanziare T direttamente
        * ...anche se gli facciamo ereditare il costruttore fromJson sul tipo che mettiamo come vincolo...
        * ... forse possiamo sistemarlo con una factory
        *
        * ..ora come ora se si aggiunge un nuovo item da gestire dobbiamo cambiare anche qui...
        */
       if (_elements is List<Dispensa>){
         print("TYPE = Dispensa");
         this._elements = data["_elements"].map((model) => Dispensa.fromJson(model)).toList().cast<Dispensa>();
       } else if (_elements is List<Articolo>){
         print("TYPE = Articolo");
         this._elements = data["_elements"].map((model) => Articolo.fromJson(model)).toList().cast<Articolo>();
       } else if (_elements is List<Prodotto>){
         print("TYPE = Prodotto");
         this._elements = data["_elements"].map((model) => Prodotto.fromJson(model)).toList().cast<Prodotto>();
       }else{
         throw Exception("Item non gestibile");
       }

       this._next_code = data["_next_code"];
       debugPrint("${this._next_code}");

     }catch(exeption){
       print(exeption);
     }
     this.notifyListeners();
   }

  /**
   * Salvaaggio su disco
   */
  void setSavingPath(String path){
    this._path = path;
  }

  Future<void> saveToDisk({String passedPath = ''}) async{
    if(passedPath != ''){
      this._path = passedPath;
    }
    if(this._path == ''){
      throw Exception("Path not valid or not correctly set");
    }

    final directory = await getApplicationDocumentsDirectory();

    Map<String, dynamic> dictionary = {'_elements' : this._elements,
      '_next_code' : this._next_code,
    };


    String jsonData = jsonEncode(dictionary);



    String completePath = directory.path + '/' + this._path;
    File file = File(completePath);
    await file.writeAsString(jsonData);
    print("$jsonData");
    print("Saved at $completePath");
  }

  int _maxCode() {
    int latestCode = 0;
    for(int i = 0; i<_elements.length; i++){
      if (_elements[i].getCode() > latestCode){
        latestCode = _elements[i].getCode();
      }
    }
    return latestCode;
  }
}