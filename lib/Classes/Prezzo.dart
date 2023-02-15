/**
 * Classe per rappresentare il prezzo
 */

class Prezzo{

  double _euros = 0;

  /**
   * Costruttore dell oggetto prezzo
   * @param value : il valore
   * @param currency : la valuta a cui il valore si riferisce (default euro)
   */
  Prezzo(double value, {Currency currency = Currency.euro}){
    switch (currency) {
      case Currency.euro :
        _euros = value;
        break;
      case Currency.dollar :
        _euros = value * 0.93;
    }
  }

  /**
   * Ritorna il prezzo
   * @param currency : la valuta desiderata (default euro)
   */
  double getPrice({Currency currency = Currency.euro}){
    switch (currency) {
      case Currency.euro :
        return _euros;
        break;
      case Currency.dollar :
        return _euros * 1.07;
        break;
    }
  }

  static defaultPrice(){
    return new Prezzo(0);
  }
  
}

/**
 eventualmente utile per supportare pìù i una valuta alla volta
 */
enum Currency{
  euro,
  dollar
}