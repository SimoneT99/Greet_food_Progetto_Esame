import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/Settings.dart';
import 'package:greet_food/Widgets/AppBars.dart';
import 'package:provider/provider.dart';

/**
 * Widget per le pagine di onboarding per l'utente, verranno mostrate solo al
 * primo avvio
 */
class Onboarding extends StatefulWidget{

  late Function() onDone;

  Onboarding(this.onDone);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

enum _onBoardingEnum{
  home,
  scadenze,
  dispense,
  aiuto
}

class _OnboardingState extends State<Onboarding> {

  int _bottomBarIndex = 1;
  int _pageIndex = 0;

  late List<Widget> _pages;

  @override
  initState(){
    this._pages = [
      OnboardingHome(_goOn),
      OnboardingScadenze(_goOn),
      OnboardingDispense(_goOn),
      OnboardingAiuto(_goOn)
    ];
  }

  _goOn(_onBoardingEnum currentPage){
      switch(currentPage){
        case _onBoardingEnum.home:{
          setState(() {
            this._pageIndex++;
            _bottomBarIndex = 0;
          });
        }
        break;
        case _onBoardingEnum.scadenze:{
          setState(() {
            this._pageIndex++;
            _bottomBarIndex = 2;
          });
        }
        break;
        case _onBoardingEnum.dispense:{
          setState(() {
            this._pageIndex++;
            _bottomBarIndex = 1;
          });
        }
        break;
        case _onBoardingEnum.aiuto:{
          Provider.of<Settings>(context, listen: false).setFirstStartDone();
          widget.onDone;
        }
        break;
      };
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: emptyAppbar,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: IndexedStack(
          index: _pageIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(    /** Usiamo direttamente una bottom bar per mostrare all'utente **/
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
}

/**
 * Pagine effettive dell'onboarding
 */
class OnboardingHome extends StatelessWidget{

  late Function(_onBoardingEnum) goOnfunction;

  OnboardingHome(this.goOnfunction);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container( //TODO immagine
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            Container(
                height: 150,
                child: Image.asset("Assets/Images/OnbAddProd.png")
            ),
            Text("In HOME puoi inserire degli articoli e cercare dei prodotti! ",
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(
                    fontSize: 20
                ),
                textAlign: TextAlign.center
            ),
            ElevatedButton(
                onPressed: (){
                  goOnfunction(_onBoardingEnum.home);
                },
                child: Text(
                  "Avanti",
                )
            )
          ],
        ),
      ),
    );
  }
}


class OnboardingScadenze extends StatelessWidget{

  late Function(_onBoardingEnum) goOnfunction;

  OnboardingScadenze(this.goOnfunction);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            Container(
                height: 150,
                child: Image.asset("Assets/Images/OnbScadenze.png")
            ),
            Text("In SCADENZE puoi tenere traccia di articoli scaduti ed articoli in scadenza! ",
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(
                    fontSize: 20
                ),
                textAlign: TextAlign.center
            ),
            ElevatedButton(
                onPressed: (){
                  goOnfunction(_onBoardingEnum.scadenze);
                },
                child: Text(
                  "Avanti",
                )
            )
          ],
        ),
      ),
    );
  }
}


class OnboardingDispense extends StatelessWidget{

  late Function(_onBoardingEnum) goOnfunction;

  OnboardingDispense(this.goOnfunction);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container( //TODO immagine
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            Container(
                height: 150,
                child: Image.asset("Assets/Images/OnbDispense.png")
            ),
            Text("In DISPENSE puoi inserire delle dispense ed entrarci per visualizzare gli articoli contenuti! ",
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(
                    fontSize: 20
                ),
                textAlign: TextAlign.center
            ),
            ElevatedButton(
                onPressed: (){
                  goOnfunction(_onBoardingEnum.dispense);
                },
                child: Text(
                  "Avanti",
                )
            )
          ],
        ),
      ),
    );
  }
}

class OnboardingAiuto extends StatelessWidget{

  late Function(_onBoardingEnum) goOnfunction;

  OnboardingAiuto(this.goOnfunction);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container( //TODO immagine
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            Container(
                height: 150,
                child: Image.asset("Assets/Images/OnbHelp.png")
            ),
            Text("Se hai domande puoi cercare risposta nella sezione aiuti in HOME! ",
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(
                    fontSize: 20
                ),
                textAlign: TextAlign.center
            ),
            ElevatedButton(
                onPressed: (){
                  goOnfunction(_onBoardingEnum.aiuto);
                },
                child: Text(
                  "Entra nell'app",
                )
            )
          ],
        ),
      ),
    );
  }
}