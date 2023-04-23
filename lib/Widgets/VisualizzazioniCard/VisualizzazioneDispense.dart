import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:greet_food/Classes/GestioneDati/ElaboratoreArticoli.dart';
import 'package:greet_food/Classes/Items/Articolo.dart';
import 'package:greet_food/Widgets/Forms/CreazioneDispensa.dart';
import 'package:greet_food/Widgets/PaginaDispensa.dart';
import 'package:provider/provider.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';

import '../../Classes/GestioneDati/GenericManager.dart';
import '../../Classes/Items/Prodotto.dart';



/**
 * Widgets per la visualizzazione delle dispense nella sezione dispense
 * //TODO refactoring per gestire meglio le responsabilità
 */

enum _CardDispensaType{
  elencoDispense,
  paginaProdotto
}

class VisualizzazioneDispense extends StatelessWidget{

  final GenericManager<Dispensa> manager_dispense;

  late bool _allowDeletion = false;
  late bool _allowAccess = false;
  late bool _allowCreation = false;

  late _CardDispensaType _cardType;

  late Prodotto _prodotto;


  VisualizzazioneDispense({required this.manager_dispense, allowDeletion = true, allowAccess = true, allowCreation = true}){
    this._allowAccess = allowAccess;
    this._allowDeletion = allowDeletion;
    this._allowCreation = allowCreation;
    this._cardType = _CardDispensaType.elencoDispense;
  }

  VisualizzazioneDispense.paginaProdotto({required this.manager_dispense,
    bool allowDeletion = false,
    bool allowAccess = false,
    bool allowCreation = false,
    required Prodotto prodotto})
  {
    this._allowAccess = allowAccess;
    this._allowDeletion = allowDeletion;
    this._allowCreation = allowCreation;

    this._prodotto = prodotto;
    this._cardType = _CardDispensaType.paginaProdotto;
  }

  @override
  Widget build(BuildContext context) {

    List<Dispensa> _dispense = _listaDispense(context);

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _dispense.length+1, //l'ultimo elemento è il pulsante per l'aggiunta
          itemBuilder: (BuildContext context, int index) {
            if (index<_dispense.length) {
              //dobbiamo escludere quelle che non contengono articoli di questo prodotto
              return DispensaCard(manager: this.manager_dispense,
                  dispensa: _dispense[index],
                  accessEnabled: this._allowAccess,
                  deletionEnabled: this._allowDeletion,);
            }else{
              return _allowCreation ? Center(
                  child : SizedBox(
                    //TODO gestire questi parametri
                      width: 150, // <-- Your width
                      height: 75, // <-- Your height
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint("debug: richiesta aggiunta dispensa");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return FormCreazioneDispensa();
                              }));
                        },
                        child: Text("Aggiungi"),
                      )
                  )
              ) : null;
            }
          },
        ),
      );
    }

  List<Dispensa> _listaDispense(BuildContext context) {
    GenericManager<Articolo> genericManager = Provider.of<GenericManager<Articolo>>(context, listen: false);
    ElaboratoreArticoli elaboratoreArticoli;
    List<Dispensa> _dispense;

    //filtraggio per rimuovere quelle non valide
    if(_cardType == _CardDispensaType.paginaProdotto){

      List<Dispensa> _potenzialiDispense = manager_dispense.getAllElements();
      _dispense = [];

      for(int i = 0; i < _potenzialiDispense.length; i++){
        List<Articolo>  articoli = genericManager.getAllElements();
        elaboratoreArticoli = ElaboratoreArticoli(articoli);
        elaboratoreArticoli.filtraPerProdotto(this._prodotto, changeState: true);
        elaboratoreArticoli.filtraPerDispensa(_potenzialiDispense[i], changeState: true);
        elaboratoreArticoli.filtraPerConsumati(consumato: false, changeState: true);

        if(elaboratoreArticoli.getCurrentList().length > 0){
          _dispense.add(_potenzialiDispense[i]);
        }
      }
    }else{
      _dispense = manager_dispense.getAllElements();
    }
    return _dispense;
  }
}

class DispensaCard extends StatelessWidget{

  late Dispensa _dispensa;
  late GenericManager<Dispensa> manager;

  late bool _deletionEnabled;
  late bool _accessEnabled;

  late int? _articoliContenuti; //utile per evitare un ricalcolo

  DispensaCard({required this.manager,
    required Dispensa dispensa,
    bool deletionEnabled = true,
    bool accessEnabled = true}) {

    this._dispensa = dispensa;
    this._deletionEnabled = deletionEnabled;
    this._accessEnabled = accessEnabled;
  }

  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 2.5,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        //borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: _accessEnabled ? () {
            debugPrint('Short press: ${_dispensa.toString()}');
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return PaginaDispensa(_dispensa);
                }));
          } : () {},
          onLongPress: _deletionEnabled ? () {
            debugPrint('Long press: ${_dispensa.toString()}');
            this._showCancellationDialog(context);
          } : () {},
          child: Container(
            child: Row(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(File(_dispensa.imagePath)),
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
                                _dispensa.nome,
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.headline6?.copyWith(
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
                              Consumer<GenericManager<Articolo>>(builder: (context, manager, child){ //aggiorniamo il contenuto

                                final GenericManager<Articolo> managerArticoli = Provider.of<GenericManager<Articolo>>(context, listen: false);
                                final ElaboratoreArticoli  eleboratoreArticoli = new ElaboratoreArticoli(managerArticoli.getAllElements());
                                eleboratoreArticoli.filtraPerDispensa(_dispensa, changeState: true);
                                this._articoliContenuti = eleboratoreArticoli.filtraPerConsumati(consumato: false).length;

                                return Text(_articoliContenuti.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                );
                              }),
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
   * Gestione cancellazione
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
                  Text('Vuoi cancellare questa dispensa?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Annulla'),
                onPressed: () {
                  debugPrint("Cancellazione annullata");
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Cancella"),
                onPressed: () {
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
    if(this._articoliContenuti == 0){
      manager.removeElement(_dispensa);
    }else{
      _showCancellationDisabledDialog(context);
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
                Text('Non puoi cancellare una dispensa che contiene degli articoli non ancora consumati'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
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

