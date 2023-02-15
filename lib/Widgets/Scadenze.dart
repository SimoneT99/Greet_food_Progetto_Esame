import 'package:flutter/material.dart';
import 'package:greet_food/Classes/Managers/ManagerArticoli.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'package:greet_food/Widgets/Old/PaginaScadenze.dart';
import 'package:provider/provider.dart';
import 'package:greet_food/Classes/Managers/ManagerArticoli.dart';
/**
 * Widget della gestione scadenze
 */

class SezioneScadenze extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

/*
class SezioneScadenzeState extends State<SezioneScadenze>{

  int _sectionIndex = 0;

  List<Widget> articoliInScadenza = [Text("TODO"),Text("TODO"),Text("TODO"),Text("TODO"),Text("TODO")];
  List<Widget> articoliScaduti    = [Text("TODO"),Text("TODO"),Text("TODO"),Text("TODO"),Text("TODO")];

  final List<Widget> subPages = <Widget>[
    Scaffold(
      appBar: AppBarFactory.getEmptyAppbar(),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: articoliInScadenza,
            )
          )
        )
      ),
    RecipeGrid(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ManagerArticoli>(
          builder: (context, managerArticoli, child){
            this.articoliInScadenza = managerArticoli.getWidgetArticoliInScadenza();
            this.articoliScaduti = managerArticoli.getWidgetArticoliScaduti();

            return TabNavigator(
                mainSections[_sectionIndex],
                _sectionIndex
            ),


              Scaffold(
              appBar: AppBarFactory.getEmptyAppbar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: articoliScaduti
            );
          }
    );
  }
}

*/