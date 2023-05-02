import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/Forms/PaginaEsito.dart';
import 'package:greet_food/Widgets/PaginaProdotto.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../Classes/GestioneDati/ElaboratoreProdotti.dart';
import '../Classes/GestioneDati/GenericManager.dart';
import '../Classes/Items/Prodotto.dart';
import 'AppBars.dart';

/**
 * Gestione della ricerca tramite scansion
 * Sarebbe in futuro una buona idea generalizzare la scannerizzazione per evitare
 * di duplicare il codice
 */
class RicercaConScansione extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return PaginaAggiuntaArticoloState();
  }

}

class PaginaAggiuntaArticoloState extends State<RicercaConScansione>{

  /**
   * Il flag scanner active ci serve per gestire l'inizializzazione
   * o no dello scanner per evitare conflitti.
   * Nel design questo doveva essere attivo appena si arriva alla schermata,
   * si è deciso di cambiare solo per motivi tecnici.
   */
  bool _scannerActive = false;
  String _barcode = "nessun barcode trovato";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar,
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: AspectRatio(
                  aspectRatio: 1,
                  child:Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin:  EdgeInsets.all(0),
                    child: _scannerActive ? MobileScanner(
                      controller: MobileScannerController(
                        returnImage: false,
                        detectionSpeed: DetectionSpeed.noDuplicates,
                      ),
                      onDetect: (BarcodeCapture capture){
                        _barcodeFound(context, capture);
                      },
                    ) : InkWell(
                      onTap: () {
                        activateScanner();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("Assets/Images/ScanBarcode.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  /**
   * Qui gestiamo il comportamento in caso di codice individuato correttamente:
   * a) se non presente tra quelli salvati si passa alla creazione del prodotto, seguita dall'inserimento dell'articolo
   * b) se presente si passa direttamente all'inserimento dell'articolo
   */
  void _barcodeFound(BuildContext context, BarcodeCapture code){

    this._barcode = code.barcodes[0].rawValue!;
    //Necessario per permettere l'accesso alla camera in caso di creazione
    deActivateScanner();
    debugPrint(_barcode);

    GenericManager<Prodotto> managerProdotti =  Provider.of<GenericManager<Prodotto>>(context, listen: false);
    ElaboratoreProdotti elaboratoreProdotti = ElaboratoreProdotti(managerProdotti.getAllElements());

    //Se troviamo il prodotto con tale codice a barre possiamo passare all'inserimento
    try{
      Prodotto prodotto = elaboratoreProdotti.getProdottoByBarcode(_barcode);

      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) {
            return PaginaProdotto(prodotto);
          }
      ));

    }catch(exception){
      //TODO
      debugPrint("Nessun prodotto con questo codice a barre");
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) {
            return PaginaEsito("Nessun prodotto con quel codice trovato", Esito.warning);
          }
      ));
    }
  }


  /**
   * Gestione scanner
   */
  void activateScanner(){
    setState(() {
      this._scannerActive = true;
    });
  }

  void deActivateScanner(){
    setState(() {
      this._scannerActive = false;
    });
  }

}