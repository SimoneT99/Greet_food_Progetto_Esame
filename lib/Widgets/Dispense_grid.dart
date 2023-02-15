import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:greet_food/Classes/Managers/ManagerDispense.dart';
import 'package:greet_food/Widgets/CustomCard.dart';
import 'package:provider/provider.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';

/**
 * Sezione dispense della main page
 */

class Dispense_grid extends StatefulWidget{

  const Dispense_grid({
    Key? key
  }) : super(key: key);

  @override
  State<Dispense_grid> createState() => _DispenseGridState();
}


class _DispenseGridState extends State<Dispense_grid>{

  List<Dispensa>? _dispense;
  List<Widget>? _cardDispense;
  int? _expanded;

  @override
  void initState(){
    if(kDebugMode){
      print("Grid dispense: requested init");
    }
    super.initState();
    ManagerDispense managerDispense = Provider.of<ManagerDispense>(context, listen: false);
    _dispense = managerDispense.getAllDispense();

    _cardDispense = [];
  }

  @override
  Widget build(BuildContext context) {

    if(_dispense != null){
      return GridView.builder(
        itemCount: _dispense!.length+1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2.5,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (index<_dispense!.length) {
            return DispensaCard(_dispense![index]);
          }else{
            return Center(
                child : SizedBox(
                  //TODO gestire questi parametri
                  width: 150, // <-- Your width
                  height: 75, // <-- Your height
                  child: ElevatedButton(
                    onPressed: () {
                      print("debug: richiesta aggiunta dispensa");
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

class DispensaCard extends StatefulWidget{

  final Dispensa _dispensa;

  DispensaCard(this._dispensa);

  State<DispensaCard> createState() => DispensaCardState();
}

class DispensaCardState extends State<DispensaCard>{

  bool expanded = false;

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
            debugPrint('Card tapped.');
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
                          image: AssetImage(widget._dispensa.imagePath),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(widget._dispensa.nome),
                    ),
                  ),
                ]
            ),
          ),
        )
      ),
    );
  }
}

