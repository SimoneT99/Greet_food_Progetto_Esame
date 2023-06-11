import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Widgets/PaginaProdotto.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Classes/Items/Articolo.dart';
import '../../Classes/Items/Dispensa.dart';
import '../../Classes/Items/Prodotto.dart';
import '../Empty.dart';

/**
 * Widget per visualizzare gli articoli secondo le specifiche
 */

class VisualizzazioneArticoli extends StatefulWidget{

  late List<Articolo> _articoli;
  late GenericManager<Articolo> _managerArticoli;
  late String _removeText;

  VisualizzazioneArticoli(List<Articolo> articoli, final GenericManager<Articolo> managerArticoli, {String removeText = "Consuma"}){
    this._articoli = articoli;
    this._managerArticoli = managerArticoli;
    this._removeText = removeText;
  }

  @override
  State<StatefulWidget> createState() {
    return VisualizzazioneArticoliState();
  }
}

class VisualizzazioneArticoliState extends State<VisualizzazioneArticoli>{

  int _open_index = 2;

  @override
  void initState(){
    super.initState();
  }

  /**
   * Utilizziamo _open_index per trattare diversamente gli articoli espansi da
   * quelli ancora da espandere.
   * Gli articoli non espansi usano un Gesture detector per catturare il tap
   * e cambiare l'indice settando ricaricando la visualizzazione.
   */
  @override
  Widget build(BuildContext context) {
    if(widget._articoli.isEmpty){
      return EmptyBody("Nessun articolo disponibile");
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: widget._articoli.length,
          itemBuilder: (BuildContext context, int index) {
              if(index == _open_index){
                _open_index = -1; //usato l'indice lo cancelliamo
                return  WidgetArticolo(widget._articoli[index], true, widget._managerArticoli, widget._removeText);
              }
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _onChangedIndex(index);
              },
            child:  WidgetArticolo(widget._articoli[index], false, widget._managerArticoli, widget._removeText),
          );
        },
      ),
    );
  }

  _onChangedIndex(int index){
    setState(() {
      this._open_index = index;
    });
  }
}

class WidgetArticolo extends StatelessWidget{

  late Articolo _articolo;
  late bool _isExpanded;
  late Dispensa _dispensa;
  late Prodotto _prodotto;
  late GenericManager<Articolo> _managerArticoli;
  late String _removeText;

  WidgetArticolo(Articolo articolo, bool isExpanded, GenericManager<Articolo> managerArticoli, String removeText) {
    this._articolo = articolo;
    this._isExpanded = isExpanded;
    this._managerArticoli = managerArticoli;
    this._removeText = removeText;
  }

  @override
  Widget build(BuildContext context) {

    this._prodotto = Provider.of<GenericManager<Prodotto>>(context, listen: false).getElementById(_articolo.idProdotto);
    this._dispensa = Provider.of<GenericManager<Dispensa>>(context, listen: false).getElementById(_articolo.idDispensa);

    if(_isExpanded){
      return expanded(context);
    }
    else{
      return notExpanded(context);
    }
  }

  Widget notExpanded(BuildContext context){
    return AspectRatio(
      aspectRatio: 2.5,
      child: Container(
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: _mainContent(context),
        ),
      ),
    );
  }

  Widget expanded(BuildContext context){
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 2.84,
                child: _mainContent(context),
              ),
              Expanded(
                  child: Center(
                    child: Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              debugPrint("debug: richiesto passaggio a pagina del prodotto");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return PaginaProdotto(_prodotto);
                                  }));
                            },
                            child: const Text("Prodotto")
                        ),
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              debugPrint("debug: richiesto consumo articolo");
                              this._articolo.consume();
                              this._managerArticoli.replaceElement(this._articolo);

                              SnackBar snackBar = SnackBar(
                                content: const Text("Articolo consumato"),
                                backgroundColor: Theme.of(context).primaryColor,
                                duration: const Duration(seconds: 1),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                            child: Text(this._removeText),
                        ),
                        const Spacer(),
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
  Widget _mainContent(BuildContext context){
    return Row(
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
                  const Spacer(),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _prodotto.nome,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Theme.of(context).primaryColorDark,
                            ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        _prodotto.marca,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 2,),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        (DateFormat("dd-MM-yyyy")).format(_articolo.dataScadenza),
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        _dispensa.nome,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
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