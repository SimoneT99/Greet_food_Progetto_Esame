import 'package:flutter/cupertino.dart';

import '../../Classes/Items/Articolo.dart';
import '../../Classes/Items/Prodotto.dart';

/**
 * Pagine che implementano l'inserimento di un articolo
 */

//widget con stato dato che dobbiamo gestire il multi inserimento degli articoli
class CreazioneArticolo extends StatefulWidget{

  late final Prodotto _prodotto;

  CreazioneArticolo(Prodotto prodotto) {
    this._prodotto = prodotto;
  }

  @override
  State<StatefulWidget> createState() {
    return new CreazioneArticoloStato();
  }
}

final formKey = GlobalKey<FormState>();

class CreazioneArticoloStato extends State<CreazioneArticolo>{

  List<Articolo> _articoliInseriti = [];
  late final bool _alKg;


  /**
   * Parametri inseriti dall'utente, inizialmente a null
   */

  int? _idDispensa = null;
  double? _prezzo = 0;
  double? _weight = 1;
  DateTime? _dataScadenza = DateTime.now();


  bool? consumed = false;
  DateTime? consumedDate = DateTime.now();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}