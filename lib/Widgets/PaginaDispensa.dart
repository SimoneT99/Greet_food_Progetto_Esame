import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/ElaboratoreArticoli.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Articolo.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';

import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'package:greet_food/Widgets/VisualizzazioneArticoli.dart';
import 'package:provider/provider.dart';

import '../Classes/Items/Prodotto.dart';


/**
 * Widget della pagina di una dispensa
 */
class PaginaDispensa extends StatefulWidget {

  final Dispensa _dispensa;

  PaginaDispensa(this._dispensa);

  @override
  State<StatefulWidget> createState() {
    return PaginaDispensaStato(_dispensa);
  }
}

class PaginaDispensaStato extends State<PaginaDispensa> with SingleTickerProviderStateMixin{

  final _dispensa;

  PaginaDispensaStato(this._dispensa);

  //Gli articoli contenuti nella dispensa
  late List<Articolo> _articoli_contenuti;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    GenericManager<Articolo> managerArticoli = Provider.of<GenericManager<Articolo>>(context, listen: false);
    this._articoli_contenuti = (new ElaboratoreArticoli(managerArticoli.getAllElements())).filtraPerDispensa(_dispensa);

    super.initState();
  }

  @override
  void dispose(){
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBarFactory.getEmptyAppbar(),
          body: Column(
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
                      text: "Articoli",
                    ),
                    Tab(
                      text: "Informazioni",
                    )
                  ],
                ),
              ),
              Expanded(
                  child: TabBarView(
                    controller: _tabController,
                      children: [
                        VisualizzazioneArticoli(_articoli_contenuti),
                        InformazioniDispensa(_dispensa),
                    ]
                  )
              )
            ],
          )
        );
  }
}

/**
 * Pagina descrizione di una dispensa
 */
class InformazioniDispensa extends StatelessWidget{

  final Dispensa _dispensa;

  InformazioniDispensa(this._dispensa);

  @override
  Widget build(BuildContext context) {

    int articoliScadutiFinoOggi;
    String prodottoPreferito;
    int contenutoCorrente;


    /**
     * Setup valori per compilare la pagina
     */
    GenericManager<Articolo> managerArticoli = Provider.of<GenericManager<Articolo>>(context, listen: false);
    GenericManager<Prodotto> managerProdotti = Provider.of<GenericManager<Prodotto>>(context, listen: false);

    ElaboratoreArticoli eleboratoreArticoli = new ElaboratoreArticoli(managerArticoli.getAllElements());
    List<Articolo> articoliDispensaTotale = eleboratoreArticoli.filtraPerDispensa(this._dispensa);

    //articoli lasciati scadere
    eleboratoreArticoli.setListaArticoli(articoliDispensaTotale);
    articoliScadutiFinoOggi = eleboratoreArticoli.filtraPerLasciatiScadere().length;

    //prodotto preferito
    //TODO
    prodottoPreferito = "";

    //contenutoCorrente
    contenutoCorrente = eleboratoreArticoli.filtraPerConsumati(
        consumato: false
    ).length;

    /**
     * Costruizione del widget
     */

    return Container(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: FileImage(File(_dispensa.imagePath)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(_dispensa.nome),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Text("Contenuti: "),
                              Spacer(),
                              Text(contenutoCorrente.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 25, bottom: 10, right: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Descrizione:"),
                      Spacer()
                    ],
                  ),
                  Spacer(),
                  Center(
                    child: Text(
                      _dispensa.descripion,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  Spacer(flex: 2,),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text("Articoli scaduti\nfino ad oggi:",
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.left,
                  ),
                  Spacer(),
                  Text(articoliScadutiFinoOggi.toString())
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text("Prodotto preferito:"),
                  Spacer(),
                  Text(prodottoPreferito.toString())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}