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



/**
 * Widgets per la visualizzazione delle dispense nella sezione dispense
 */

class VisualizzazioneDispense extends StatelessWidget{

  final GenericManager<Dispensa> manager_dispense;

  const VisualizzazioneDispense({required this.manager_dispense, super.key});

  @override
  Widget build(BuildContext context) {
    final _dispense = manager_dispense.getAllElements();
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _dispense.length+1, //l'ultimo elemento è il pulsante per l'aggiunta
          itemBuilder: (BuildContext context, int index) {
            if (index<_dispense.length) {
              return DispensaCard(manager: this.manager_dispense, dispensa: _dispense[index]);
            }else{
              return Center(
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
              );
            }
          },
        ),
      );
    }
}

class DispensaCard extends StatelessWidget{

  final Dispensa _dispensa;
  final GenericManager<Dispensa> manager;

  const DispensaCard({required this.manager,required Dispensa dispensa, super.key}) : _dispensa = dispensa;

  Widget build(BuildContext context) {
    final GenericManager<Articolo> managerArticoli = Provider.of<GenericManager<Articolo>>(context, listen: false);
    final ElaboratoreArticoli  eleboratoreArticoli = new ElaboratoreArticoli(managerArticoli.getAllElements());
    final int articoliContenuti = eleboratoreArticoli.filtraPerDispensa(_dispensa).length;

    return AspectRatio(
      aspectRatio: 2.5,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        //borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            debugPrint('Short press: ${_dispensa.toString()}');
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return PaginaDispensa(_dispensa);
                }));
          },
          onLongPress: () {
            debugPrint('Long press: ${_dispensa.toString()}');
            this._showCancellationDialog(context);
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
                              Text(articoliContenuti.toString(),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  this._onDeleteRequested(context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

  void _onDeleteRequested(BuildContext context) {
    manager.removeElemet(_dispensa);
  }
}

