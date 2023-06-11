import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Prodotto.dart';
import 'package:greet_food/Widgets/AppBars.dart';
import 'package:greet_food/Widgets/Forms/CreazioneArticolo.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../Classes/GestioneDati/ElaboratoreProdotti.dart';
import 'Empty.dart';
import 'Forms/CreazioneProdotto.dart';
import 'VisualizzazioniCard/VisualizzazioneProdotto.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: AspectRatio(
                aspectRatio: 1,
                  child:Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin:  const EdgeInsets.all(0),
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
                          decoration: const BoxDecoration(
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
            AspectRatio(
              aspectRatio: 2.4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: (){
                    HapticFeedback.lightImpact();
                    _button_pressed(context);
                  },
                  child: const Text("Sfoglia prodotti"),
                ),
              ),
            ),
          ],
        )),
    );
  }

  /**
   * Premuto il bottone no codice
   */
  void _button_pressed(BuildContext context){
    debugPrint("Flusso senza codice richiesto");
    //se non disattiviamo lo scanner non possiamo fare la foto durante la creazione dei prodotti
    setState(() {
      this._scannerActive = false;
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return PaginaElencoProdotti();
        }
    ));
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

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return FormCreazioneArticolo(prodotto);
          }
      ));

    }catch(exception){
      debugPrint("Nessun prodotto con questo codice a barre");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return FormCreazioneProdotto(
              codice: _barcode,
              followUpArticolo: true,
            );
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

class NoCodeButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ElevatedButton(
          onPressed: (){
            HapticFeedback.lightImpact();
            _button_pressed(context);
          },
          child: const Text("No codice"),
        ),
      ),
    );
  }

  void _button_pressed(BuildContext context){
    debugPrint("Flusso senza codice richiesto");
    Navigator.of(context).push(MaterialPageRoute(
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

    return Scaffold(
      appBar: backAppbarAdd((){
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context){
                  return FormCreazioneProdotto();
                }
            )
        );
      },),

      body: Consumer<GenericManager<Prodotto>>(builder: (context, manager, child){
        List<Prodotto> prodottiDisponibili = manager.getAllElements();
        if(prodottiDisponibili.isEmpty){
          return EmptyBody("Nessun prodotto disponibile al momento");
        }
        return VisualizzazioneProdotti(prodottiDisponibili, type: ProductVisualizationContext.insertingProcess,);
      }),
    );
  }
}
