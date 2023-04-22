import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/AppBars.dart';

/**
 * Pagina conferma
 */

class PaginaConferma extends StatelessWidget {

  final String text;

  PaginaConferma(this.text);

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
                child: Image.asset("Assets/Images/Affermativo.png")
            ),
            Text(this.text,
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Avanti",
                )
            )
          ],
        ),
      ),
    );
  }
}
