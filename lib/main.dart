import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/Dispense_grid.dart';
import 'package:greet_food/Widgets/Old/PaginaHome.dart';
import 'package:greet_food/Widgets/TabNavigator.dart';
import 'Classes/Managers/ManagerArticoli.dart';
import 'Classes/Managers/ManagerDispense.dart';
import 'Classes/Managers/ManagerProdotto.dart';
import 'Widgets/Factories/AppbarFactory.dart';
import 'Widgets/HomeSection.dart';
import 'Widgets/Enumerations.dart';
import 'Widgets/Old/PaginaScadenze.dart';
import 'package:provider/provider.dart';

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
              home: const GreetFoodHome(title: "GreetFood"),
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

  final List<Widget> _pages = [
    PaginaScadenze(),
    homeScreenBody(),
    Dispense_grid(),
  ];

  final List<MainSections> mainSections = [MainSections.scadenze, MainSections.home, MainSections.dispense];

  final navigatorKey = GlobalKey<NavigatorState>();

  void _selectTab(int index){
    setState(() {
      if(kDebugMode){
        print("selezionata la $_appBarIndex pagina");
      }
      this._appBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBarFactory.getEmptyAppbar(),
      body: IndexedStack(
        index: _appBarIndex,
        children: _pages,
        ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _appBarIndex,
        onTap: _selectTab,
        items : [
          BottomNavigationBarItem(
              icon: Icon(Icons.punch_clock),
              label: 'Scadenze',
              backgroundColor: (_appBarIndex == 0 ? Colors.blueGrey : Colors.white)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: (_appBarIndex == 1 ? Colors.blueGrey : Colors.white)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Dispense',
              backgroundColor: (_appBarIndex == 2 ? Colors.blueGrey : Colors.white)
          ),
        ],
      ),
    );
  }

  Widget _buildBody(){
    return _pages[_appBarIndex];
  }
}