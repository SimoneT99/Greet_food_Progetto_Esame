import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';
import 'package:greet_food/Classes/Items/Prodotto.dart';
import 'package:greet_food/Widgets/Themes/Themes.dart';
import 'package:greet_food/Widgets/VisualizzazioniCard/VisualizzazioneArticoli.dart';
import 'package:greet_food/Widgets/VisualizzazioniCard/VisualizzazioneProdotto.dart';
import 'package:provider/provider.dart';
import 'Classes/GestioneDati/GenericManager.dart';
import 'Classes/Items/Articolo.dart';
import 'Widgets/AppBars.dart';
import 'Widgets/HomeSection.dart';
import 'Widgets/PaginaScadenze.dart';
import 'Widgets/VisualizzazioniCard/VisualizzazioneDispense.dart';

String APP_NAME = "GreetFood";

void main() {
  runApp(const GreetFood());
}

String PATH_ARTICOLO = "gestoreArticoli.txt";
String PATH_DISPENSA = "gestoreDispensa.txt";
String PATH_PRODOTTO = "gestoreProdotto.txt";


class GreetFoodState extends State<GreetFood>{

  /**
   * Manager per gestire i dati
   */

  late GenericManager<Articolo> _managerArticoli;
  late GenericManager<Dispensa> _managerDispense;
  late GenericManager<Prodotto> _managerProdotti;

  @override
  void initState() {

    /**
     * Inizializziamo i manager caricando da disco
     */
    //Articoli
    _managerArticoli = GenericManager<Articolo>();
    try{
      _managerArticoli.fromDisk(PATH_ARTICOLO);
    }catch(pathNotFoundException){
      print("file non presente");
    }
    _managerArticoli.setSavingPath(PATH_ARTICOLO);

    //Dispense
    _managerDispense = GenericManager<Dispensa>();
    try{
      _managerDispense.fromDisk(PATH_DISPENSA);
    }catch(pathNotFoundException){
      print("file non presente");
    }
    _managerDispense.setSavingPath(PATH_DISPENSA);

  //Prodotti
    _managerProdotti = GenericManager<Prodotto>();
    try{
    _managerProdotti.fromDisk(PATH_PRODOTTO);
    }catch(pathNotFoundException){
      print("file non presente");
    }
    _managerProdotti.setSavingPath(PATH_PRODOTTO);
    
super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _managerArticoli,
        ),
        ChangeNotifierProvider(
          create: (context) => _managerDispense,
        ),
        ChangeNotifierProvider(
          create: (context) => _managerProdotti,
        ),
      ],
      child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Let's avoid spoils",
              theme: GreetFoodTheme.light(),
              home: const SafeArea(child: GreetFoodHome(title: "GreetFood")),
          ),
    );
  }
}

class GreetFood extends StatefulWidget {
  const GreetFood({super.key});

  @override
  State<StatefulWidget> createState() {
    return GreetFoodState();
  }
}

/////////////////////////////

class GreetFoodHome extends StatefulWidget {
  const GreetFoodHome({super.key, required this.title});

  final String title;

  @override
  State<GreetFoodHome> createState() => _GreetFoodHomeState();
}

class _GreetFoodHomeState extends State<GreetFoodHome> {

  //old
  int _bottomBarIndex = 1;
  late List<Widget> _pages;

  @override
  void initState(){
    if(kDebugMode){
      print("Grid dispense: requested init");
    }
    super.initState();

    this._pages = [
      PaginaScadenze(),
      Homepage(),
      Consumer<GenericManager<Dispensa>>(builder: (context, manager, child){
        return VisualizzazioneDispense(manager_dispense: manager);
      }),
    ];
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: emptyAppbar,
      drawer: _sideDrawer(),
      body: IndexedStack(
        index: _bottomBarIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: _managePrimaryNavigation,
        currentIndex: _bottomBarIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Scadenze',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen),
            label: 'Dispense',
          )
        ],
      ),
    );
  }

  /**
   * Dobbiamo gestire tutti i casi partiolari delle schermate
   */
  _managePrimaryNavigation(int index) {
      setState(() {
        _bottomBarIndex = index;
      });
  }
}


/**
 * Side drawer per le funzioni avanzate
 */
class _sideDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Tutti gli articoli'),
            onTap: (){
              print('richiesti tutti gli articoli');
              Navigator.pop(context);  //Chiudiamo il drawer

              List<Articolo> articoli = Provider.of<GenericManager<Articolo>>(context, listen: false).getAllElements();

              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: backAppbar,
                      body: VisualizzazioneArticoli(articoli),
                    );
                  }
              ));

              },
          ),
          ListTile(
            title: const Text('Tutti i prodotti'),
            onTap: (){
              print('richiesti tutti i prodotti');
              Navigator.pop(context);  //Chiudiamo il drawer

              List<Prodotto> prodotti = Provider.of<GenericManager<Prodotto>>(context, listen: false).getAllElements();

              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: backAppbar,
                      body: VisualizzazioneProdotti(prodotti),
                    );
                  }
              ));
              },
          ),
        ],
      ),
    );
  }
}