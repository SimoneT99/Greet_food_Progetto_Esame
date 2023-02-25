import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:greet_food/Classes/GestioneDati/ElaboratoreArticoli.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Articolo.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'package:provider/provider.dart';

import 'VisualizzazioneArticoli.dart';

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
  }

@override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              height: 25,
              child: TabBar(
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.blue,
                ),
                tabs: [
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
                      Builder(
                          builder: (BuildContext context) {
                            EleboratoreArticoli elaboratoreArticoli = new EleboratoreArticoli(_managerArticoli.getAllElements());
                            elaboratoreArticoli.setListaArticoli(elaboratoreArticoli.filtraPerArticoliScaduti());
                            List<Articolo> articoliScaduti = elaboratoreArticoli.filtraPerConsumati(consumato: false);
                            return ViewArticoli(articoliScaduti);
                          }
                      ),
                      Builder(
                          builder: (BuildContext context) {
                            EleboratoreArticoli elaboratoreArticoli = new EleboratoreArticoli(_managerArticoli.getAllElements());
                            elaboratoreArticoli.setListaArticoli(elaboratoreArticoli.filtraPerArticoliInScadenza(7)); //TODO il tempo deve essere letto dalle impostazioni
                            List<Articolo> articoliInScadenza = elaboratoreArticoli.filtraPerConsumati(consumato: false);
                            return ViewArticoli(articoliInScadenza);
                          }
                      )
                    ]
                )
            )
          ],
        )
    );
  }
}