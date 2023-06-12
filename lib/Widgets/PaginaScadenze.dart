import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/ElaboratoreArticoli.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/GestioneDati/Settings.dart';
import 'package:greet_food/Classes/Items/Articolo.dart';
import 'package:provider/provider.dart';

import 'Empty.dart';
import 'VisualizzazioniCard/VisualizzazioneArticoli.dart';

/**
 * Widget per la gestione delle scadenze
 */

class PaginaScadenze extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PaginaScadenzaStato();
  }

}

class PaginaScadenzaStato extends State<PaginaScadenze> with SingleTickerProviderStateMixin{

  late TabController _tabController;
  late GenericManager<Articolo> _managerArticoli;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    _managerArticoli = Provider.of<GenericManager<Articolo>>(context, listen: false);

    super.initState();
  }

  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              height: 35,
              child: TabBar(
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                tabs: const [
                  Tab(
                    text: "Scaduti",
                  ),
                  Tab(
                    text: "In Scadenza",
                  )
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: [
                      Consumer<GenericManager<Articolo>>(builder: (context, manager, child){
                        ElaboratoreArticoli elaboratoreArticoli = ElaboratoreArticoli(_managerArticoli.getAllElements());
                        elaboratoreArticoli.filtraPerArticoliScaduti(changeState: true);
                        List<Articolo> articoliScaduti = elaboratoreArticoli.filtraPerConsumati(consumato: false, changeState: true);
                        if(articoliScaduti.isEmpty){
                          return NoScadutiAttualmente();
                        }

                        articoliScaduti = elaboratoreArticoli.orderByDate();
                        return VisualizzazioneArticoli(articoliScaduti, manager, removeText: "Butta via",);
                      }),
                      Consumer2<GenericManager<Articolo>, Settings>(builder: (context, manager, settings, child){
                        ElaboratoreArticoli elaboratoreArticoli = ElaboratoreArticoli(_managerArticoli.getAllElements());
                        elaboratoreArticoli.filtraPerArticoliInScadenza(settings.giorniInScadenza, changeState: true);
                        List<Articolo> articoliInScadenza = elaboratoreArticoli.filtraPerConsumati(consumato: false, changeState: true);
                        if(articoliInScadenza.isEmpty){
                          return NoScadenzeInArrivo();
                        }
                        articoliInScadenza = elaboratoreArticoli.orderByDate();
                        return VisualizzazioneArticoli(articoliInScadenza, manager);
                      })
                    ]
                )
            )
          ],
        )
    );
  }
}