import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/AppBars.dart';

/**
 * Pagina conferma
 */

class PaginaConferma extends StatelessWidget{

  final String text;

  PaginaConferma(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: emptyAppbar,
      body: Column(
        children: [
          Text(text),
          ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text(
                "Avanti",
              )
          )
        ],
      ),
    );
  }

}


/**
 * Pagina alert
 */

class PaginaAlert extends StatelessWidget{

  final String text;

  PaginaAlert(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: emptyAppbar,
      body: Column(
        children: [
          Text(text),
          ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text(
                "Avanti",
              )
          )
        ],
      ),
    );
  }
}