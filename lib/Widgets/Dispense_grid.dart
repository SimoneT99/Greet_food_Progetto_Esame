import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:greet_food/Classes/Managers/ManagerDispense.dart';
import 'package:greet_food/Widgets/CreazioneDispensa.dart';
import 'package:provider/provider.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';

/**
 * Sezione dispense della main page
 */

class Dispense_grid extends StatelessWidget{

  final ManagerDispense manager;

  const Dispense_grid({required this.manager, super.key});

  @override
  Widget build(BuildContext context) {
    final _dispense = manager.getAllDispense();
    if(_dispense != null){
      return GridView.builder(
        itemCount: _dispense!.length+1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 2.5,
        ),
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

/**
 * I feed delle dispense
 */

class DispensaCard extends StatelessWidget{

  final Dispensa dispensa;
  final ManagerDispense manager;

  const DispensaCard({required this.manager,required this.dispensa, super.key});


  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          //borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () {
              debugPrint('Short press: ${dispensa.toString()}');
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
                        child: Text(dispensa.nome),
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
      manager.removeDispensa(dispensa);
    }

}
