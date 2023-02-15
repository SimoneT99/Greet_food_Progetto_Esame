import 'package:flutter/material.dart';

import '../Factories/AppbarFactory.dart';
import 'Layout.dart';
/**
 * widget per la gestione delle dispense
 */

class PaginaDispense extends AppLayout{

  @override
  State<StatefulWidget> createState() {
    return PaginaDispenseState();
  }
}

class PaginaDispenseState extends AppLayoutState<PaginaDispense>{

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
    );
  }
}