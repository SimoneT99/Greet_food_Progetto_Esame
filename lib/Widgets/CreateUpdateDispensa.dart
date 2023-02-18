import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'Utility.dart';

/**
 * Widget per la pagina di creazione dispense
 */

class PaginaCreazioneDispense extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PaginaCreazioneDispenseState();
  }
}

class PaginaCreazioneDispenseState extends State<PaginaCreazioneDispense>{

  final int _bottomBarIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBackAppbar(), //gestire il warning
      body: FormCreazioneDispense(),
    );
  }
}

class FormCreazioneDispense extends StatefulWidget{

  const FormCreazioneDispense({super.key});

  @override
  State<StatefulWidget> createState() {
    return FormCreazioneDispenseState();
  }
}

class FormCreazioneDispenseState extends State<FormCreazioneDispense>{

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
        child: Column(
          children: [
            Text("BottoneFoto"),
            Text("Nome"),
            Text("Posizione"),
            Text("Descrizione"),
          ],
        ),
    );
  }
}