import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/ElaboratoreArticoli.dart';
import 'package:greet_food/Classes/GestioneDati/ElaboratoreProdotti.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Prodotto.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Classes/Items/Articolo.dart';
import '../Classes/Items/Dispensa.dart';
import 'AppBars.dart';


/**
 * Widget per la pagina prodotto
 */

class PaginaProdotto extends StatefulWidget {

  final Prodotto _prodotto;

  PaginaProdotto(this._prodotto);

  @override
  State<StatefulWidget> createState() {
    return PaginaProdottoStato(_prodotto);
  }
}

class PaginaProdottoStato extends State<PaginaProdotto> with SingleTickerProviderStateMixin{

  /**
   * Servono:
   *  -il prodotto
   *  -la lista degli articoli per lo storico prezzi
   *  -la lista delle dispense che contengono gli articoli
   */

  final Prodotto _prodotto;
  late List<Articolo> articoli_del_prodotto;
  late List<Dispensa> dispense_contenitrici;

  late TabController _tabController;

  PaginaProdottoStato(this._prodotto);


  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  void dispose(){
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: emptyAppbar,
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
                    text: "Informazioni",
                  ),
                  Tab(
                    text: "Prezzi",
                  ),
                  Tab(
                    text: "In casa",
                  )
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: [
                      _infoProdotto(),
                      _prezzi(),
                      _dispenseContenenti(),
                    ]
                )
            )
          ],
        )
    );
  }

  /**
   * Sezione con le informazioni sul prodotto
   */
  Widget _infoProdotto(){
    return Container(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(_prodotto.imagePath),
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
                            Text(_prodotto.nome),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text("Contenuti: "),
                            Spacer(),
                            Text("xx"),
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
                      _prodotto.descripion,
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
                  Text("In possesso:",
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.left,
                  ),
                  Spacer(),
                  Text("xx")
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
                  Text("Dispensa preferita:"),
                  Spacer(),
                  Text("xx")
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
                  Text("Ultimo prezzo:"),
                  Spacer(),
                  Text("xx")
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
                  Text("In Scadenza:"),
                  Spacer(),
                  Text("In scadenza")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /**
   * Sezione con le informazioni sui prezzi
   */
  Widget _prezzi(){
    return priceHistoryPage(_prodotto);
  }

  /**
   * Sezione conle dispense che contengono il articoli del prodotto
   */
  Widget _dispenseContenenti(){
    return Text("//TODO");
  }
}

class priceHistoryPage extends StatelessWidget{

  Prodotto _prodotto;

  priceHistoryPage(this._prodotto);

  @override
  Widget build(BuildContext context) {

    //Preparazione dati per popolare la pagina
    GenericManager<Articolo> managerArticoli = Provider.of<GenericManager<Articolo>>(context, listen: false);
    List<Articolo> articoliProdotto = new ElaboratoreArticoli(managerArticoli.getAllElements()).filtraPerProdotto(_prodotto);
    double prezzoMassimo = articoliProdotto.reduce((current, next) => current.prezzo > next.prezzo ? current : next).prezzo;
    double prezzoMinimo = articoliProdotto.reduce((current, next) => current.prezzo < next.prezzo ? current : next).prezzo;
    double prezzoMedio = articoliProdotto.fold(.0, (current, next) => (current + next.prezzo))/articoliProdotto.length.toDouble();

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16/9,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                title: ChartTitle(text: 'Storico prezzi'),
                series: getGraphData(articoliProdotto),
            ),
          )
        ),
        Expanded(
            child: Text(
              "Massimo   ${prezzoMassimo.toStringAsFixed(2)}"
            ),
        ),
        Expanded(
            child: Text(
                "Minimo   ${prezzoMinimo.toStringAsFixed(2)}"
            )
        ),
        Expanded(
            child: Text(
                "Medio   ${prezzoMedio.toStringAsFixed(2)}"
            )
        ),
      ],
    );
  }

  getGraphData(List<Articolo> articoliProdotto) {
    return <ChartSeries<Articolo, DateTime>>[
      LineSeries<Articolo, DateTime>(
        dataSource: articoliProdotto,
        xValueMapper: (Articolo articolo, _) => articolo.dataInserimento,
        yValueMapper: (Articolo articolo, _) => articolo.prezzo,
        ),
      ];

  }

}

