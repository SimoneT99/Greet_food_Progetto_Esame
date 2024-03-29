import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/GestioneDati/Settings.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';
import 'package:greet_food/Widgets/Forms/PaginaEsito.dart';
import 'package:greet_food/Widgets/PaginaAggiuntaArticolo.dart';
import 'package:greet_food/Widgets/PaginaAiuto.dart';
import 'package:provider/provider.dart';

import 'Forms/CreazioneDispensa.dart';
import 'Impostazioni.dart';
import 'PaginaRicercaProdotto.dart';


/**
 * Sezione home dell'applicazione
 */

class Homepage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HomeScreenbuttonContainer(child: AggiungiArticolo()),
            HomeScreenbuttonContainer(child: CercaProdotto()),
            HomeScreenbuttonContainer(
                child: SplittedContainterButtons(
                  left_child: Aiuto(),
                  right_child: Impostazioni(),
                )
            ),
          ],
        ),
      );
    }
}

/**
 * Container per i pulsanti della home screen
 */

class HomeScreenbuttonContainer extends StatelessWidget {

  final Widget child;


  HomeScreenbuttonContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        child: this.child,
      ),
    );
  }
}

/**
 * Pulsanti principali della home page
 */

class AggiungiArticolo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        _button_pressed(context);
      },
      child: const Text("Aggiungi articolo"),
    );
  }

  void _button_pressed(BuildContext context){
    debugPrint("richiesta aggiunta articolo");
    GenericManager<Dispensa> managerDispense = Provider.of<GenericManager<Dispensa>>(context, listen: false);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return managerDispense.getAllElements().isEmpty ? PaginaEsito(
              "Attenzione devi creare almeno una dispensa per poter iniziare ad inserire articoli",
              Esito.warning,
              function: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return FormCreazioneDispensa();
                    }));
              },
            testoPulsante: "Crea dispensa",
          ) : PaginaAggiuntaArticolo() ;
        }
    ));
  }
}

class CercaProdotto extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        _button_pressed(context);
      },
      child: const Text("Cerca prodotto"),
    );
  }

  void _button_pressed(BuildContext context){
    debugPrint("richiesta ricerca prodotto");
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return PaginaRicercaProdotto();
        }
    ));
  }
}

/**
 * Pulsanti secondari della home page
 */

class SplittedContainterButtons extends StatelessWidget{

  final Widget left_child;
  final Widget right_child;

  SplittedContainterButtons({required this.left_child, required this.right_child});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 13.0),
            child: left_child,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: right_child,
          ),
        )
      ],
    );
  }
}

class Aiuto extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return PaginaAiuto();
            }
        ));
      },
      child: const Text("Aiuto"),
    );
  }
}

class Impostazioni extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return Consumer<Settings>(builder: (context, manager, child){
                return PaginaImpostazioni(manager);
              });
            }
        ));
      },
      child: const Icon(Icons.settings, size: 50),
    );
  }
}