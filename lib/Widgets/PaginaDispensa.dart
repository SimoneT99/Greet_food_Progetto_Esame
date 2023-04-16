import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/ElaboratoreArticoli.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Articolo.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';

import 'package:greet_food/Widgets/AppBars.dart';
import 'package:greet_food/Widgets/Forms/CreazioneDispensa.dart';
import 'package:greet_food/Widgets/VisualizzazioniCard/VisualizzazioneArticoli.dart';
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
    this._articoli_contenuti = (ElaboratoreArticoli(this._articoli_contenuti).filtraPerConsumati(consumato: false));

    super.initState();
  }

  //Overriding per eseguire il dispose del controller
  @override
  void dispose(){
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: backAppbarEdit(() {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) {
                      return FormCreazioneDispensa.edit(dispensa: this._dispensa);
                    }
                )
            );
          }),
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
                    color: Theme.of(context).colorScheme.primary,
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
 * Widget descrizione di una dispensa
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

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                                  Text(
                                    _dispensa.nome,
                                    style: Theme.of(context).textTheme.headline6?.copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Text("Contenuti: ",
                                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                        color: Theme.of(context).primaryColorDark,
                                      )
                                  ),
                                  Spacer(),
                                  Text(contenutoCorrente.toString(),
                                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                        color: Theme.of(context).primaryColorDark,
                                      )
                                  ),
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
                          Text("Descrizione:",
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                      Spacer(),
                      Center(
                        child: Text(
                          _dispensa.descripion,
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                            fontStyle: FontStyle.italic,
                          ),
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
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      Spacer(),
                      Text(articoliScadutiFinoOggi.toString(),
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          ))
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
                      Text("Prodotto preferito:",
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      Spacer(),
                      Text(prodottoPreferito.toString(),
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


/***

    Expanded(
    child: Padding(
    padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
    child: Column(
    children: [
    Container(
    child: Row(
    children: [
    Text(
    _dispensa.nome,
    style: Theme.of(context).textTheme.headline5
    ),
    ],
    ),
    ),
    Spacer(),
    Row(
    children: [
    Text("Contenuti: ",
    style: Theme.of(context).textTheme.subtitle1,
    ),
    Spacer(),
    Text(contenutoCorrente.toString(),
    style: Theme.of(context).textTheme.subtitle1,
    ),
    ],
    ),
    ],
    ),
    ),
    )
    ],

 */