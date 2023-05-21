import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/AppBars.dart';

/**
 * Pagina conferma
 */

enum Esito{
  positive,
  negative,
  warning
}

class PaginaEsito extends StatelessWidget {

  late String _text;
  late Esito _esito;

  late Image _image;
  late String _buttonText;
  Function()? _function;


  PaginaEsito(String text, Esito esito, {String testoPulsante = "Avanti", Function()? function = null}){
    this._text = text;
    this._esito = esito;
    switch(esito){
      case Esito.positive:{
        _image = Image.asset("Assets/Images/Affermativo.png");
      }
      break;
      case Esito.negative:{
        _image = Image.asset("Assets/Images/Negative.png");
      }
      break;
      case Esito.warning:{
        _image = Image.asset("Assets/Images/Warning.png");
      }
      break;
    }
    this._buttonText = testoPulsante;
    this._function = function;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: emptyAppbar,
      body: Container( //TODO immagine
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            Container(
                height: 200,
                child: this._image
            ),
            Text(this._text,
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(
                    fontSize: 20
                ),
                textAlign: TextAlign.center
            ),
            ElevatedButton(
                onPressed: _function == null ? () {
                  Navigator.of(context).pop();
                } : _function!,
                child: Text(
                  this._buttonText,
                )
            )
          ],
        ),
      ),
    );
  }
}
