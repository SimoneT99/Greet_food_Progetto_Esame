import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';

/**
 * Widget relativi alla sezione home dell'applicazione
 */

class AggiungiArticolo extends StatelessWidget {
  const AggiungiArticolo({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Card(
          child: InkWell(
            splashColor: Colors.brown,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) {return Scaffold(
                        appBar: AppBarFactory.getBackAppbar(),
                      );}
                  )
              );
            },

            child: SizedBox(
              width: 250,
              height: 100,
              child: Center(child: Text('Aggiungi articolo')),
            ),
          )
      ),
    );
  }
}

class CercaProdotto extends StatelessWidget {
  const CercaProdotto({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: SizedBox(
          width: 250,
          height: 100,
          child: Center(child: Text('Cerca Prodotto')),
        ),
      ),
    );
  }
}

class Aiuto extends StatelessWidget {
  const Aiuto({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: SizedBox(
          height: 100,
          child: Center(child: Text('Aiuto')),
        ),
      ),
    );
  }
}

class Impostazioni extends StatelessWidget {
  const Impostazioni({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: SizedBox(
          height: 100,
          width: 250,
          child: Center(child: Text('Impostazioni')),
        ),
      ),
    );
  }
}

Widget homeScreenBody(){
  return Column(
    children: <Widget>[
    Spacer(),
    AggiungiArticolo(),
    CercaProdotto(),
    Impostazioni(),
    Spacer()
    ],
  );
}