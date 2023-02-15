import 'package:flutter/material.dart';
import '../Factories/AppbarFactory.dart';
import 'Layout.dart';

/**
 * Widgets della prima schermata della sezione home dell'applicazione
 */

class PaginaHome extends AppLayout{

  @override
  State<StatefulWidget> createState() {
    return PaginaHomeState();
  }
}

class PaginaHomeState extends AppLayoutState<PaginaHome>{

  @override
  void indexChanged(){
    //non facciamo nulla se si
  }

  @override
  AppBar appBar(){
    return AppBarFactory.getEmptyAppbar();
  }

  Widget body(){
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
}

//Bottoni di pagina

/**
 * widget card della springboard nella home
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
                      builder: (context) {return Scaffold();}
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
