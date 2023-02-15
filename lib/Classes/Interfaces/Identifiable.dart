/**
 * Interfaccia che permette agli oggetti di essere identificati univocamente attraverso un codice
 * (usiamo una abstract class dato che non ha le interfacce dart)
 */

abstract class Identifiable{
 bool checkCode(int code);
}