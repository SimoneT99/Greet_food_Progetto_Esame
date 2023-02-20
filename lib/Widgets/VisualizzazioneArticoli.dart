import 'package:flutter/material.dart';
import 'package:greet_food/Classes/Managers/ManagerDispense.dart';
import 'package:greet_food/Classes/Managers/ManagerProdotto.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Classes/Items/Articolo.dart';
import '../Classes/Items/Dispensa.dart';
import '../Classes/Items/Prodotto.dart';


/**
 * Widget per visualizzare gli articoli secondo le specifiche
 */

class ViewArticoli extends StatefulWidget{

  final List<Articolo> articoli;

  ViewArticoli(this.articoli);

  @override
  State<StatefulWidget> createState() {
    return ViewArticoliState(articoli);
  }
}

class ViewArticoliState extends State<ViewArticoli>{

  int _open_index = 2;
  List<Articolo> articoli;

  ViewArticoliState(this.articoli);

  /**
   * Utilizziamo _open_index per trattare diversamente gli articoli espansi da
   * quelli ancora da espandere.
   * Gli articoli non espansi usano un Gesture detector per catturare il tap
   * e cambiare l'indice settando ricaricando la visualizzazione.
   */
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: articoli.length,
    itemBuilder: (BuildContext context, int index) {
        if(index == _open_index){
          return  WidgetArticolo(articoli[index], true);
        }
        return GestureDetector(
          onTap: () {_onChangedIndex(index);},
          child:  WidgetArticolo(articoli[index], false),
        );
    },
    );
  }

  _onChangedIndex(int index){
    setState(() {
      this._open_index = index;
    });
  }
}

class WidgetArticolo extends StatelessWidget{

  late Articolo articolo;
  late bool isExpanded;
  late Dispensa dispensa;
  late Prodotto prodotto;


  WidgetArticolo(Articolo articolo, bool isExpanded) {
    this.articolo = articolo;
    this.isExpanded = isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    
    this.prodotto = Provider.of<ManagerProdotti>(context, listen: false).getProdotto(articolo.idProdotto);
    this.dispensa = Provider.of<ManagerDispense>(context, listen: false).getDispensa(articolo.idDispensa);

    if(isExpanded){
      return expanded();
    }
    else{
      return notExpanded();
    }
  }

  Widget notExpanded(){
    return AspectRatio(
      aspectRatio: 2.5,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: _mainContent(),
        ),
      ),
    );
  }

  Widget expanded(){
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 2.84,
                child: _mainContent(),
              ),
              Expanded(
                  child: Center(
                    child: Row(
                      children: [
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              debugPrint("debug: richiesto passaggio a pagina del prodotto");
                            },
                            child: Text("Prodotto")
                        ),
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              debugPrint("debug: richiesto consumo articolo");
                            },
                            child: Text("Consuma")
                        ),
                        Spacer(),
                      ],
                    )
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }


  /**
   * Contenuto principale della card presente sia che questa sia estesa
   * sia che questa non lo sia
   */
  Widget _mainContent(){
    return Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(prodotto.imagePath),
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
                      Text(
                        prodotto.nome,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        prodotto.marca,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Spacer(flex: 2,),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        (new DateFormat("dd-MM-yyyy")).format(articolo.dataScadenza),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        prodotto.marca,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ]
    );
  }
}