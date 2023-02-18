import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';

/**
 * widget per la gestione delle dispense
 */

class PaginaScadenze extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: TextButton(
          child: Text(
            'Aggiungi',
            style: TextStyle(fontSize: 32.0, color: Colors.black),
          ),
          onPressed: () => _push(context),
        )
    );
  }

  void _push(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {return Scaffold(
        appBar: AppBarFactory.getBackAppbar(),
      );
      }
      ));
  }
}