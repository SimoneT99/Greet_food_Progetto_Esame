import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';
import 'package:greet_food/Classes/Items/Prodotto.dart';
import 'package:greet_food/Widgets/Themes.dart';
import 'package:greet_food/Widgets/VisualizzazioneArticoli.dart';
import 'package:greet_food/Widgets/VisualizzazioneDispense.dart';
import 'package:greet_food/Widgets/VisualizzazioneProdotto.dart';
import 'package:provider/provider.dart';
import 'Classes/GestioneDati/GenericManager.dart';
import 'Classes/Items/Articolo.dart';
import 'Widgets/Factories/AppbarFactory.dart';
import 'Widgets/HomeSection.dart';
import 'Widgets/PaginaScadenze.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

String APP_NAME = "GreetFood";

void main() {
  runApp(const GreetFood());
}

class GreetFoodState extends State<GreetFood>{

  /**
   * Manager per gestire i dati
   */

  GenericManager<Articolo> _managerArticoli = GenericManager<Articolo>();
  GenericManager<Dispensa> _managerDispense = GenericManager<Dispensa>();
  GenericManager<Prodotto> _managerProdotti = GenericManager<Prodotto>();

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
              title: "Let's Grab a Bite",
              theme: GreetFoodTheme.light(),
              home: SafeArea(child: const GreetFoodHome(title: "GreetFood")),
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
  int _appBarIndex = 1;
  late List<Widget> _pages;

  @override
  void initState(){
    if(kDebugMode){
      print("Grid dispense: requested init");
    }
    super.initState();

    this._pages = [
      Scaffold(
        drawer: _sideDrawer(),
        appBar: AppBarFactory.getEmptyAppbar(),
        body: PaginaScadenze()//PaginaScadenze(),
      ),
      Scaffold(
        drawer: _sideDrawer(),
        appBar: AppBarFactory.getEmptyAppbar(),
        body: Homepage(),
      ),
      Scaffold(
        drawer: _sideDrawer(),
        appBar: AppBarFactory.getEmptyAppbar(),
        body: Consumer<GenericManager<Dispensa>>(builder: (context, manager, child){
          return VisualizzazioneDispense(manager_dispense: manager);
          },
        ),
      ),
    ];
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      navBarStyle: NavBarStyle.style14,
      screens: _pages,
      onItemSelected: _managePrimaryNavigation(),
      items: [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.punch_clock),
          title: 'Scadenze',
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: 'Home',
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: 'Dispense',
        )
      ],
    );
  }

  /**
   * Dobbiamo gestire tutti i casi partiolari delle schermate
   */
  _managePrimaryNavigation() {

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
                      appBar: AppBarFactory.getBackAppbar(),
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
                      appBar: AppBarFactory.getBackAppbar(),
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