import 'package:flutter/material.dart';
import '../Interfaces/Identifiable.dart';

/**
 * Classe generica per gestire i dati senza duplicazione di codice
 */

class GenericManager<T extends Identifiable> extends ChangeNotifier{

  /**
   * Ogni manager contiene una lista degli elementi che deve gestire
   */
  List<T> elements = [];

  /**
   * Metodi del manager
   */

  /**
   * Ottenere un elemento dato l'ID
   * Eccezione se non c'è un elemento con tale ID
   */
  T getElementById(int code){
    for(int i = 0; i<elements.length; i++){
      if (elements[i].checkCode(code)){
        //TODO gestire la copia in modo che non si possa modificare
        return elements[i];
      }
    }
    throw Exception("Nessun elemento con questo codice");
  }

  /**
   * Ottenere tutti gli elementi
   */
  List<T> getAllElements(){
    return List.unmodifiable(elements);
  }

  /**
   * Aggiungere un'elemento alla lista degli elementi gestiti
   * Eccezione se c'è già un elemento con tale ID
   */
  void addElement(T newElement){
    for(int i = 0; i<elements.length; i++){
      if (elements[i].checkCode(newElement.getCode())){
        throw Exception("Elemento con ID già usato");
      }
    }
    elements.add(newElement);
    this.notifyListeners();
  }

  /**
   * Rimuovere un elemento dato l'id
   * Eccezione se l'elemento non è presente
   */
  void removeElemetById(int code){
    int index = -1;
    for(int i = 0; i<elements.length; i++){
      if (elements[i].checkCode(code)){
        index = i;
      }
    }
    if(index == -1){
      throw Exception("Nessun elemento con questo ID");
    }
    elements.removeAt(index);
    this.notifyListeners();
  }

  /**
   * Rimuovere un elemento dato l'id
   * Eccezione se l'elemento non è presente
   */
  void removeElemet(T element){
    int index = -1;
    for(int i = 0; i<elements.length; i++){
      if (elements[i].checkCode(element.getCode())){
        index = i;
      }
    }
    if(index == -1){
      throw Exception("Nessun elemento con questo ID");
    }
    elements.removeAt(index);
    this.notifyListeners();
  }

  /**
   * Rimuovere un elemento dato l'id
   * Eccezione se l'elemento non è presente
   */
  void replaceElement(T newElement){
    for(int i = 0; i<elements.length; i++){
      if (elements[i].checkCode(newElement.getCode())){
        elements[i] =  newElement;
        this.notifyListeners();
        return;
      }
    }
    throw Exception("Nessun elemento con questo ID");
  }
}