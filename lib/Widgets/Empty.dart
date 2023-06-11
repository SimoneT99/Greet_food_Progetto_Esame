import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * Widget che fanno da body nelle schermate che ancora non contengono nulla
 */

class NoScadutiAttualmente extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          Container(
            height: 200,
              child: Image.asset("Assets/Images/Thumb_up.png")
          ),
          Text("Congratulazioni, nessun articolo scaduto al momento",
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  fontSize: 20
              ),
            textAlign: TextAlign.center
          ),
        ],
      ),
    );
  }
}

class NoScadenzeInArrivo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          Container(
            height: 200,
              child: Image.asset("Assets/Images/Calm.png")
          ),
          Text("Tranquillo, nessun articolo in scadenza al momento",
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  fontSize: 20,
              ),
              textAlign: TextAlign.center
          ),
        ],
      ),
    );
  }
}

/**
 * No prodotti o articoli
 */
class EmptyBody extends StatelessWidget{

  late String _text;

  EmptyBody(this._text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset("Assets/Images/Empty.png"),
          Text(_text,
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  fontSize: 20
              )
          ),
        ],
      ),
    );
  }
}
