import 'package:flutter/cupertino.dart';

/**
 * Widget che fanno da body nelle schermate che ancora non contengono nulla
 */

class NoScadenzeInArrivo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container( //TODO immagine
      padding: const EdgeInsets.all(10),
      child: Text("Tranquillo, nessun articolo in scadenza"),
    );
  }
}

class NoScadutiAttualmente extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container( //TODO immagine
      padding: const EdgeInsets.all(10),
      child: Text("Ottimo! Non hai fatto scadere nessun articolo"),
    );
  }
}

class NoProdotti extends StatelessWidget{

  late String _text;

  NoProdotti(this._text);

  @override
  Widget build(BuildContext context) {
    return Container( //TODO immagine
      padding: const EdgeInsets.all(10),
      child: Text(this._text),
    );
  }
}