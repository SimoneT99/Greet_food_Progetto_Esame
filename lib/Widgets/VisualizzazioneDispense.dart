import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:greet_food/Widgets/CreateUpdateDispensa.dart';
import 'package:greet_food/Widgets/PaginaDispensa.dart';
import 'package:provider/provider.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';

import '../Classes/Items/Prodotto.dart';
import '../Classes/Legacy/ManagerArticoli.dart';
import '../Classes/Legacy/ManagerDispense.dart';

/**
 * Widgets per la visualizzazione delle dispense nella sezione dispense
 */

class VisualizzazioneDispense extends StatelessWidget{

  final ManagerDispense manager;

  const VisualizzazioneDispense({required this.manager, super.key});

  @override
  Widget build(BuildContext context) {
    final _dispense = manager.getAllDispense();
    if(_dispense != null){
      return ListView.builder(
        itemCount: _dispense!.length+1,
        itemBuilder: (BuildContext context, int index) {
          if (index<_dispense!.length) {
            return DispensaCard(manager: this.manager, dispensa: _dispense![index]);
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
                              return PaginaCreazioneDispense();
                            }));
                      },
                      child: Text("Aggiungi"),
                    )
                )
            );
          }
        },
      );
    }
    else {
      return Text("nessuna dispensa al momento");
    }
  }
}

class DispensaCard extends StatelessWidget{

  final Dispensa dispensa;
  final ManagerDispense manager;

  const DispensaCard({required this.manager,required this.dispensa, super.key});

  Widget build(BuildContext context) {

    ManagerArticoli managerArticoli = Provider.of<ManagerArticoli>(context, listen: false);
    final articoliContenuti = managerArticoli.getArticoliDispensa(dispensa).length;

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
              onTap: () {
                debugPrint('Short press: ${dispensa.toString()}');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return PaginaDispensa(dispensa);
                    }));
              },
              onLongPress: () {
                debugPrint('Long press: ${dispensa.toString()}');
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
                              image: AssetImage(dispensa.imagePath),
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
                                    dispensa.nome,
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
                                  Text(articoliContenuti.toString()),
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
    manager.removeDispensa(dispensa);
  }
}

