import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/ElaboratoreArticoli.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/GestioneDati/Settings.dart';
import 'package:greet_food/Classes/Items/Prodotto.dart';
import 'package:greet_food/Widgets/Forms/CreazioneProdotto.dart';
import 'package:greet_food/Widgets/VisualizzazioniCard/VisualizzazioneDispense.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: backAppbarEdit(() {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) {
                    return FormCreazioneProdotto.edit(
                      prodotto: this._prodotto,
                      followUpArticolo: false,
                    );
                  }
              )
          );
        }),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              height: 25,
              child: TabBar(
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                tabs: const [
                  Tab(
                    text: "Informazioni",
                  ),
                  Tab(
                    text: "Prezzi",
                  ),
                  Tab(
                    text: "Posizione",
                  )
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: [
                      _infoProdotto(context),
                      _prezzi(context),
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
  Widget _infoProdotto(BuildContext context){

    int posseduti;
    String dispensa_preferita;
    double ultimo_prezzo;
    int inScadenza;

    /**
     * Prendiamo le informazioni da mostrare nella pagina
     */

    GenericManager<Articolo> managerArticoli = Provider.of<GenericManager<Articolo>>(context, listen: false);
    ElaboratoreArticoli elaboratoreArticoli = ElaboratoreArticoli(managerArticoli.getAllElements());

    elaboratoreArticoli.filtraPerConsumati(consumato: false, changeState: true);
    elaboratoreArticoli.filtraPerProdotto(_prodotto, changeState: true);
    posseduti = elaboratoreArticoli.getCurrentList().length;

    elaboratoreArticoli.filtraPerArticoliInScadenza(Provider.of<Settings>(context, listen: false).giorniInScadenza);
    inScadenza = elaboratoreArticoli.getCurrentList().length;

    elaboratoreArticoli.setListaArticoli(managerArticoli.getAllElements());
    elaboratoreArticoli.filtraPerProdotto(_prodotto, changeState: true);
    ultimo_prezzo = elaboratoreArticoli.getCurrentList().isEmpty ? -1 : _getLatestPrice(elaboratoreArticoli.getCurrentList());

    GenericManager<Dispensa> managerDispensa = Provider.of<GenericManager<Dispensa>>(context, listen: false);

    int favDispensaId = _getFavouriteDispensaId(elaboratoreArticoli.getCurrentList());

    dispensa_preferita = favDispensaId == -1 ? 'N.A.' : dispensa_preferita = managerDispensa.getElementById(favDispensaId).nome;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    //Immagine
                    Expanded(
                      flex : 1,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: _prodotto.getImage().image,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //Testo immagine
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(_prodotto.nome,
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context).textTheme.headline6?.copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                    ),

                                  ),
                                ),

                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  _prodotto.marca,
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
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
                            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 20,
                            ),),
                          const Spacer()
                        ],
                      ),
                      const Spacer(),
                      Center(
                        child: Text(
                          _prodotto.descripion,
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const Spacer(flex: 2,),
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
                        style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      Text("$posseduti",
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 20,
                        ),)
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
                      Text("Dispensa preferita:",
                        style: Theme.of(context).textTheme.subtitle2?.copyWith(
                        color: Theme.of(context).primaryColorDark,
                          fontSize: 20,
                      ),),
                      const Spacer(),
                      Expanded(
                        child: Text("$dispensa_preferita",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 20,
                          ),),
                      )
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
                      Text("Ultimo prezzo:",
                        style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 20,
                        ),),
                      const Spacer(),
                      Text(ultimo_prezzo == -1 ? "N.A." : "€ $ultimo_prezzo",
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 20,
                        ),)
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
                      Text("In Scadenza:",
                          style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 20,
                          )),
                      const Spacer(),
                      Text("$inScadenza",
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 20,
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

  /**
   * Sezione con le informazioni sui prezzi
   */
  Widget _prezzi(BuildContext context){

    GenericManager<Articolo> managerArticoli = Provider.of<GenericManager<Articolo>>(context, listen: false);
    ElaboratoreArticoli elaboratoreArticoli = ElaboratoreArticoli(managerArticoli.getAllElements());
    elaboratoreArticoli.filtraPerProdotto(this._prodotto, changeState: true);
    if(elaboratoreArticoli.getCurrentList().isEmpty){
      return Column(
                children: [
                    Container(
                      height: 200,
                      child: Image.asset("Assets/Images/Warning.png")
                    ),
                    Text("Nessun articolo per compilare il grafico prezzi",
                            style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.copyWith(
                                  fontSize: 20
                                  ),
                        textAlign: TextAlign.center),
                        ]);
    }
    return priceHistoryPage(_prodotto);
  }

  /**
   * Sezione conle dispense che contengono il articoli del prodotto
   */
  Widget _dispenseContenenti(){

    //Non dovrebbe essere della VisualizzazioneDispense la responsabilità di filtrarle correttamente...
    return VisualizzazioneDispense.paginaProdotto(
      manager_dispense: Provider.of<GenericManager<Dispensa>>(context, listen: false),
      prodotto: this._prodotto
    );
  }


  int _getFavouriteDispensaId(List<Articolo> articoli){
    ElaboratoreArticoli elaboratoreArticoli = ElaboratoreArticoli(articoli);
    elaboratoreArticoli.filtraPerProdotto(this._prodotto, changeState: true);
    Set<int> idDispense = Set<int>();
    for(Articolo articolo in articoli){
      idDispense.add(articolo.idDispensa);
    }

    int idDispensa = -1;
    int max = -1;

    elaboratoreArticoli.setListaArticoli(articoli);
    for(int id in idDispense){
      int currentNumber = elaboratoreArticoli.filtraPerIdDispensa(id).length;
      if(currentNumber > max){
        idDispensa = id;
      }
    }
    return idDispensa;
  }

  double _getLatestPrice(List<Articolo> articoli, {bool alKg = false}){
    articoli.sort((Articolo articolo1, Articolo articolo2) {
      if(articolo1.dataInserimento.isBefore(articolo2.dataInserimento)){
        return -1;
      }else if (articolo1.dataInserimento.isAfter(articolo2.dataInserimento)){
        return 1;
      }else{
      return 0;
    }
    });

    return alKg ?
    ((articoli.last.prezzo / articoli.last.weight) * 1000)
        : articoli.last.prezzo;
  }

}

/**
 * Gestione grafico prezzi
 */

class priceHistoryPage extends StatefulWidget{

  late Prodotto _prodotto;

  priceHistoryPage(Prodotto prodotto){
    this._prodotto = prodotto;
  }

  @override
  State<StatefulWidget> createState() {
    return  priceHistoryPageState();
  }

}



class priceHistoryPageState extends State<priceHistoryPage>{

  bool _alKg = false;

  @override
  Widget build(BuildContext context) {

    //Preparazione dati per popolare la pagina
    GenericManager<Articolo> managerArticoli = Provider.of<GenericManager<Articolo>>(context, listen: false);
    List<Articolo> articoliProdotto = ElaboratoreArticoli(managerArticoli.getAllElements()).filtraPerProdotto(widget._prodotto);

    double prezzoMassimo;
    double prezzoMinimo;
    double prezzoMedio;

    if(this._alKg){
      Articolo temp = articoliProdotto.reduce((current, next) => ((current.prezzo/current.weight) * 1000.0 > (next.prezzo/next.weight) * 1000.0 ? current : next));
      prezzoMassimo = (temp.prezzo/temp.weight) * 1000.0;

      temp = articoliProdotto.reduce((current, next) => ((current.prezzo/current.weight) * 1000.0 < (next.prezzo/next.weight) * 1000.0 ? current : next));
      prezzoMinimo = (temp.prezzo/temp.weight) * 1000.0;

      prezzoMedio = articoliProdotto.fold(.0, (current, next) => (current + ((next.prezzo/next.weight) * 1000.0)))/articoliProdotto.length.toDouble();
    }else{
      prezzoMassimo = articoliProdotto.reduce((current, next) => current.prezzo > next.prezzo ? current : next).prezzo;
      prezzoMinimo = articoliProdotto.reduce((current, next) => current.prezzo < next.prezzo ? current : next).prezzo;
      prezzoMedio = articoliProdotto.fold(.0, (current, next) => (current + next.prezzo))/articoliProdotto.length.toDouble();
    }


    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 4/3,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 18,
                    left: 12,
                    top: 24,
                    bottom: 12,
                  ),
                  child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(),
                      title: ChartTitle(text: 'Storico prezzi${_alKg ? " (€/kg)":''}'),
                      series: _getGraphData(articoliProdotto),
                  ),
                )
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text("Massimo${_alKg ? " (€/kg)":''}:",
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          )),
                      const Spacer(),
                      Text("${prezzoMassimo.toStringAsFixed(2)}",
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
                      Text("Minimo${_alKg ? " (€/kg)":''}:",
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          )),
                      const Spacer(),
                      Text("${prezzoMinimo.toStringAsFixed(2)}",
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
                      Text("Medio${_alKg ? " (€/kg)":''}:",
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          )),
                      const Spacer(),
                      Text("${prezzoMedio.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          ))
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _switchPrices,
                child: this._alKg ? const Text("Ignora peso") : const Text("Vai al Kg"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getGraphData(List<Articolo> articoliProdotto) {
    return <ChartSeries<Articolo, DateTime>>[
      LineSeries<Articolo, DateTime>(
        dataSource: articoliProdotto,
        xValueMapper: (Articolo articolo, _) => articolo.dataInserimento,
        yValueMapper: (Articolo articolo, _) {
          if (_alKg) {
            double e_al_kg = (articolo.prezzo/articolo.weight) * 1000.0;
            return e_al_kg;
          }
          return articolo.prezzo;
        },
        ),
      ];
  }

  _switchPrices(){
    setState(() {
      _alKg = !_alKg;
    });
  }
}

