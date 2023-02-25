import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Prodotto.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../Classes/GestioneDati/ElaboratoreProdotti.dart';
import 'Forms/CreazioneProdotto.dart';

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

  bool scannerActive = false;
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
                onDetect: (BarcodeCapture capture){
                  _barcodeFound(context, capture);
                },
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

  void _barcodeFound(BuildContext context, BarcodeCapture code){
    setState(() {
      scannerActive = false;
      barcode = code.barcodes[0].rawValue!;
      debugPrint("Code found: ${code.barcodes[0].rawValue}");
    });

    GenericManager<Prodotto> managerProdotti =  Provider.of<GenericManager<Prodotto>>(context, listen: false);
    ElaboratoreProdotti elaboratoreProdotti = ElaboratoreProdotti(managerProdotti.getAllElements());

    //Se troviamo il prodotto con tale codice a barre possiamo passare all'inserimento
    try{
      Prodotto prodotto = elaboratoreProdotti.getProdottoByBarcode(barcode);
      //TODO
    }catch(exception){
      //TODO
      debugPrint("Nessun prodotto con questo codice a barre");
    }
  }
}

class NoCodeButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ElevatedButton(
          onPressed: (){
            _button_pressed(context);
          },
          child: Text("No codice"),
        ),
      ),
    );
  }

  void _button_pressed(BuildContext context){
    debugPrint("Flusso senza codice richiesto");
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) {
          return PaginaElencoProdotti();
        }
    ));
  }
}

/**
 * Pagina per selezionare un prodotto
 */
class PaginaElencoProdotti extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    GenericManager<Prodotto> managerProdotti = Provider.of<GenericManager<Prodotto>>(context, listen: false);
    List<Prodotto> prodottiDisponibili = managerProdotti.getAllElements();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
        ),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (context){
                        return PaginaCreazioneProdotto();
                      }
                  )
                );
              },
              child: Icon(Icons.add, color: Colors.deepOrange,),
          )
        ],
      ),
      body: ListView.builder(
          itemCount: prodottiDisponibili.length, //l'ultimo elemento è il pulsante per l'aggiunta
          itemBuilder: (BuildContext context, int index){
            return CardProdotto(
              prodotto: prodottiDisponibili[index],
            );
          }
      ),
    );
  }
}


class CardProdotto extends StatelessWidget{

  late final Prodotto _prodotto;


  CardProdotto({required Prodotto prodotto}){
    this._prodotto = prodotto;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.5,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            //borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: (){},
              child: Container(
                child: Row(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(_prodotto.imagePath),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding:  const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Spacer(),
                              Row(
                                children: [
                                  const Spacer(),
                                  Text(
                                    _prodotto.nome,
                                    textAlign: TextAlign.left,
                                  ),
                                  const Spacer(flex: 8),
                                ],
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  Text(
                                    _prodotto.marca,
                                    textAlign: TextAlign.left,
                                  ),
                                  const Spacer(flex: 8),
                                ],
                              ),
                              const Spacer(flex: 3,),
                              Row(
                                children: [
                                  const Spacer(),
                                  const Text("Articoli:"),
                                  const Spacer(flex: 6),
                                  Text("//TODO"),
                                  const Spacer(),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            )
        ),
      ),
    );
  }
}