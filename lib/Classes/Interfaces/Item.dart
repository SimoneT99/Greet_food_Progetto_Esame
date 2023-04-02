/**
 * Interfaccia che permette agli oggetti di essere identificati univocamente attraverso un codice
 * (usiamo una abstract class dato che non ha le interfacce dart)
 */

abstract class Item{
  /**
   * Gli item sono identificabili da un intero
   */
  bool checkCode(int code);
  int getCode();

  //mmm...
  void refreshCode(int code);

  /**
    Gli item possono essere costruiti da unJson
   */
  fromJson(Map<String, dynamic> json);
}