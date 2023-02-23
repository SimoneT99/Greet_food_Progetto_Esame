import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/VisualizzazioneDispense.dart';
import 'package:greet_food/Widgets/SectionNavigator.dart';
import 'package:provider/provider.dart';
import 'Classes/Legacy/ManagerArticoli.dart';
import 'Classes/Legacy/ManagerDispense.dart';
import 'Classes/Legacy/ManagerProdotto.dart';
import 'Widgets/Factories/AppbarFactory.dart';
import 'Widgets/HomeSection.dart';
import 'Widgets/Enumerations.dart';
import 'Widgets/PaginaScadenze.dart';
import 'package:provider/provider.dart';
import 'Widgets/Utility.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

String APP_NAME = "GreetFood";

void main() {
  runApp(const GreetFood());
}

class GreetFoodState extends State<GreetFood>{

  /**
   * Manager per gestire i dati
   */

  ManagerArticoli _managerArticoli = ManagerArticoli();
  ManagerDispense _managerDispense = ManagerDispense();
  ManagerProdotti _managerProdotti = ManagerProdotti();

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
              theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
               primarySwatch: Colors.blue,
               ),
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
        appBar: AppBarFactory.getEmptyAppbar(),
        body: PaginaScadenze(),
      ),
      Scaffold(
        appBar: AppBarFactory.getEmptyAppbar(),
        body: Homepage(),
      ),
      Scaffold(
        appBar: AppBarFactory.getEmptyAppbar(),
        body: Consumer<ManagerDispense>(builder: (context, manager, child){
          return VisualizzazioneDispense(manager: manager);
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