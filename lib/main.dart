import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greet_food/Classes/GestioneDati/ElaboratoreArticoli.dart';
import 'package:greet_food/Classes/GestioneDati/Settings.dart';
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
import 'Widgets/OnBoarding/OnboardingPage.dart';
import 'Widgets/PaginaScadenze.dart';
import 'Widgets/VisualizzazioniCard/VisualizzazioneDispense.dart';

String APP_NAME = "GreetFood";

void main() {
  runApp(const GreetFood());
}

String PATH_ARTICOLO = "gestoreArticoli.txt";
String PATH_DISPENSA = "gestoreDispensa.txt";
String PATH_PRODOTTO = "gestoreProdotto.txt";
String PATH_SETTINGS = "settings.txt";


class GreetFoodState extends State<GreetFood>{

  /**
   * Manager per gestire i dati
   */

  late GenericManager<Articolo> _managerArticoli;
  late GenericManager<Dispensa> _managerDispense;
  late GenericManager<Prodotto> _managerProdotti;
  late Settings _settings;

  @override
  void initState() {

    /**
     * Inizializziamo i manager caricando da disco
     */
    //Articoli
    _managerArticoli = GenericManager<Articolo>();
    _managerArticoli.fromDisk(PATH_ARTICOLO);
    _managerArticoli.setSavingPath(PATH_ARTICOLO);

    //Dispense
    _managerDispense = GenericManager<Dispensa>();
    _managerDispense.fromDisk(PATH_DISPENSA);
    _managerDispense.setSavingPath(PATH_DISPENSA);

    //Prodotti
    _managerProdotti = GenericManager<Prodotto>();
    _managerProdotti.fromDisk(PATH_PRODOTTO);
    _managerProdotti.setSavingPath(PATH_PRODOTTO);

    //Settings
    _settings = Settings();
    _settings.fromDisk(PATH_SETTINGS);
    _settings.setSavingPath(PATH_SETTINGS);

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
        ChangeNotifierProvider(
          create: (context) => _settings,
        ),
      ],
      child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Let's avoid spoils",
              theme: GreetFoodTheme.light(),
              home: GreetFoodHome(title: "GreetFood"),
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
  bool firstBuild = true; //hack

  @override
  void initState(){
    if(kDebugMode){
      print("Grid dispense: requested init");
    }

    this._pages = [
      PaginaScadenze(),
      Homepage(),
      Consumer<GenericManager<Dispensa>>(builder: (context, manager, child){
        return VisualizzazioneDispense(manager_dispense: manager);
      }),
    ];

    super.initState();
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {

    /**
     * Usiamo un consumer per Settings
     */

    return Consumer<Settings>(builder: (context, manager, child){

      bool doOnboarding = manager.firstStart;

      if(doOnboarding && !firstBuild){
        firstBuild = false;
        return Onboarding(_done);
      }
      firstBuild = false;
      return Scaffold(
        appBar: drawerAppbar,
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
    });
  }

  /**
   * Dobbiamo gestire tutti i casi partiolari delle schermate
   */
  _managePrimaryNavigation(int index) {
    HapticFeedback.mediumImpact();
      setState(() {
        _bottomBarIndex = index;
      });
  }

  //per l'onboarding, sarebbe più sensato usare il consumer invece che passare una funzione
  _done(){
    setState(() {
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

              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                        appBar: backAppbar,
                        body: Consumer<GenericManager<Articolo>>(builder: (context, manager, child)
                              {
                                List<Articolo> articoli = Provider.of<
                                    GenericManager<Articolo>>(context, listen: false)
                                    .getAllElements();
                                articoli =
                                    new ElaboratoreArticoli(articoli).filtraPerConsumati(
                                        consumato: false);
                                return VisualizzazioneArticoli(articoli, manager);
                              },
                    ),
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