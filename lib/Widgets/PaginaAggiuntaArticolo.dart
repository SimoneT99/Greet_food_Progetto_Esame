import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/**
 * Widget per il flusso di azioni di aggiunta articolo
 * Possiamo gestire l'attivazione della camera attraverso lo stato
 */

class PaginaAggiuntaArticolo extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return PaginaAggiuntaArticoloState();
  }
}

class PaginaAggiuntaArticoloState extends State<PaginaAggiuntaArticolo>{

  bool scannerActive = true;
  String barcode = "nessun barcode trovato";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBackAppbar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AspectRatio(
              aspectRatio: 1,
              child: scannerActive ? MobileScanner(
                onDetect: _barcodeFound,
            ) : null,
          )
          ),
            TextButton(
              child : Text(barcode, textAlign: TextAlign.center,),
              onPressed : () {setState(() {
                scannerActive = true;
              });} ,
            ),
            NoCodeButton(),
          ],
        )),
    );
  }

  _barcodeFound(BarcodeCapture code){
    setState(() {
      scannerActive = false;
      barcode = code.barcodes[0].rawValue!;
      debugPrint("Code found: ${code.barcodes[0].rawValue}");
    });
  }
}

class NoCodeButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ElevatedButton(
          onPressed: _button_pressed,
          child: Text("No codice"),
        ),
      ),
    );
  }

  void _button_pressed(){
    debugPrint("Flusso senza codice richiesto");
  }
}

/**
 *
 */