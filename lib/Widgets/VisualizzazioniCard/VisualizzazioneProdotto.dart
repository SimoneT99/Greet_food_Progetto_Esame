import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
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
    if (_prodotti.length == 0){
        return EmptyBody("Nessun prodotto disponibile");
    }else{
      return ListView.builder(
          itemCount: _prodotti.length, //l'ultimo elemento è il pulsante per l'aggiunta
          itemBuilder: (BuildContext context, int index){
            return CardProdotto(
              prodotto: _prodotti[index],
              cardAction: _visualizationContext == ProductVisualizationContext.insertingProcess ? _CardAction.insertProduct : _CardAction.productPage,
              allowElimintaion: false,
            );
          }
      );
    }
  }

}


enum _CardAction{
  insertProduct,
  productPage,
}

/**
 * Card del singolo prodotto
 */
class CardProdotto extends StatelessWidget{

  late final Prodotto _prodotto;
  late final _CardAction _cardType;
  late final bool _allowElimination;

  CardProdotto({required Prodotto prodotto, _CardAction cardAction = _CardAction.productPage, bool allowElimintaion = false}){
    this._prodotto = prodotto;
    this._cardType = cardAction;
    this._allowElimination = allowElimintaion;
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
              onTap: (){
                if(_cardType == _CardAction.productPage){
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) {
                        return PaginaProdotto(this._prodotto);
                      })
                  );
                }else if( _cardType == _CardAction.insertProduct) {
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) {
                        return CreazioneArticolo(this._prodotto);
                      })
                  );
                }
              },
              onLongPress: !_allowElimination ? (){} : (){
                GenericManager<Prodotto> managerProdotti = Provider.of<GenericManager<Prodotto>>(context, listen: false);
                managerProdotti.removeElemet(_prodotto);
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