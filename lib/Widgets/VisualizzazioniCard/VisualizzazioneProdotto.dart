
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greet_food/Classes/GestioneDati/ElaboratoreArticoli.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Articolo.dart';
import 'package:greet_food/Classes/Items/Prodotto.dart';
import 'package:greet_food/Widgets/PaginaProdotto.dart';
import 'package:provider/provider.dart';

import '../Empty.dart';
import '../Forms/CreazioneArticolo.dart';

enum ProductVisualizationContext{
  insertingProcess,
  standard,
}


/**
 * Widget per la visualizzazione dei prodotti
 * Rappresenta i prodotto passati in input come listwiew di card
 */

class VisualizzazioneProdotti extends StatelessWidget{

  List<Prodotto> _prodotti = [];
  ProductVisualizationContext _visualizationContext = ProductVisualizationContext.standard;

  VisualizzazioneProdotti(List<Prodotto> prodotti, {ProductVisualizationContext type = ProductVisualizationContext.standard}){
    this._prodotti = prodotti;
    this._visualizationContext = type;
  }

  @override
  Widget build(BuildContext context) {
    //Se vuota renderizziamo una schermata apposita
    if (_prodotti.isEmpty){
        return EmptyBody("Nessun prodotto disponibile");
    }else{
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: _prodotti.length, //l'ultimo elemento è il pulsante per l'aggiunta
            itemBuilder: (BuildContext context, int index){
              return CardProdotto(
                prodotto: _prodotti[index],
                cardAction: _visualizationContext == ProductVisualizationContext.insertingProcess ? CardAction.insertProduct : CardAction.productPage,
                allowElimintaion: _visualizationContext == ProductVisualizationContext.insertingProcess ? false : true,
              );
            }
        ),
      );
    }
  }

}


enum CardAction{
  insertProduct,
  productPage,
}

/**
 * Card del singolo prodotto
 */
class CardProdotto extends StatelessWidget{

  late final Prodotto _prodotto;
  late final CardAction _cardType;
  late final bool _allowElimination;

  CardProdotto({required Prodotto prodotto, CardAction cardAction = CardAction.productPage, bool allowElimintaion = false}){
    this._prodotto = prodotto;
    this._cardType = cardAction;
    this._allowElimination = allowElimintaion;
  }

  @override
  Widget build(BuildContext context) {
    GenericManager<Articolo> managerArticoli = Provider.of<GenericManager<Articolo>>(context, listen: false);
    ElaboratoreArticoli elaboratoreArticoli = ElaboratoreArticoli(managerArticoli.getAllElements());
    elaboratoreArticoli.filtraPerProdotto(this._prodotto, changeState: true);
    int articoliPresenti = elaboratoreArticoli.filtraPerConsumati(consumato: false).length;

    return AspectRatio(
      aspectRatio: 2.5,
      child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          //borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: (){
              HapticFeedback.lightImpact();
              if(_cardType == CardAction.productPage){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return Consumer<GenericManager<Prodotto>>(
                          builder: (context, manager, child) =>
                          PaginaProdotto(this._prodotto),
                      );
                    })
                );
              }else if( _cardType == CardAction.insertProduct) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return FormCreazioneArticolo(this._prodotto);
                    })
                );
              }
            },
            onLongPress: !_allowElimination ? (){} : (){

              /**
               * Al momento la cancellazione non è permessa
               *
               * _showCancellationDialog(context);
               */
            },
            child: Container(
              child: Row(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: _prodotto.getImage().image,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      _prodotto.nome,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context).textTheme.headline6?.copyWith(
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                Text(
                                  _prodotto.marca,
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                                const Spacer(flex: 8),
                              ],
                            ),
                            const Spacer(flex: 3,),
                            Row(
                              children: [
                                const Spacer(),
                                Text("Articoli:",
                                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                                const Spacer(flex: 6),
                                Text("$articoliPresenti",
                                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
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
    );
  }

  /**
   * Al momento la cancellazione è disabilitata, se si volesse abilitarla basterebbe chiamare questo metodo
   */
  Future<void> _showCancellationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Vuoi cancellare questo prodotto?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                HapticFeedback.lightImpact();
                debugPrint("Cancellazione annullata");
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Cancella"),
              onPressed: () {
                HapticFeedback.lightImpact();
                debugPrint("Cancellazione confermata");
                Navigator.of(context).pop();
                this._onDeleteRequested(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _onDeleteRequested(BuildContext context) {

    GenericManager<Articolo> managerArticoli = Provider.of<GenericManager<Articolo>>(context, listen: false);
    ElaboratoreArticoli elaboratoreArticoli = ElaboratoreArticoli(managerArticoli.getAllElements());
    elaboratoreArticoli.filtraPerProdotto(this._prodotto, changeState:  true);
    int articoliNonConsumati = elaboratoreArticoli.filtraPerConsumati(consumato: false).length;

    if(articoliNonConsumati != 0){ //Se ci sono articoli non consumati di questo prodotto non lo possiamo cancellare
      _showCancellationDisabledDialog(context);
    }else{
      List<Articolo> articoliConsumati = elaboratoreArticoli.filtraPerConsumati();
      if(articoliConsumati.isNotEmpty) {
        for (int i = 1; i < articoliConsumati.length; i++) {
          try{
            managerArticoli.removeElement(
                articoliConsumati[i], notifyListeners: false,
                saveToDisk: false);
          }catch(exception){

          }

        }
        try{
          managerArticoli.removeElement(articoliConsumati[0]);
        }catch(exception){
        }

      }
      GenericManager<Prodotto> managerProdotti = Provider.of<GenericManager<Prodotto>>(context, listen: false);
      try{
        managerProdotti.removeElement(this._prodotto);
        }catch(exception){
      }
    }
  }

  Future<void> _showCancellationDisabledDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Non puoi cancellare un prodotto che ha degli articoli non ancora consumati'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                HapticFeedback.lightImpact();
                debugPrint("Cancellazione annullata");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}