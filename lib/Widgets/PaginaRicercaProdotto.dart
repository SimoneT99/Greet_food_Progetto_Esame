import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/ElaboratoreProdotti.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'package:greet_food/Widgets/VisualizzazioneProdotto.dart';
import 'package:provider/provider.dart';

import '../Classes/GestioneDati/GenericManager.dart';
import '../Classes/Items/Prodotto.dart';


final formKey = GlobalKey<FormState>();

class PaginaRicercaProdotto extends StatelessWidget{

  String _marca = "";
  String _nome = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBackAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                ),
                validator: (value) {
                  return null;
                },
                onSaved: (value){
                  this._nome = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Marca',
                ),
                validator: (value) {
                  return null;
                },
                onSaved: (value){
                  this._marca = value!;
                },
              ),
              ElevatedButton(
                  onPressed: (){
                    if(formKey.currentState!.validate()){
                      formKey.currentState!.save();
                      GenericManager<Prodotto> managerProdotti = Provider.of<GenericManager<Prodotto>>(context, listen: false);
                      List<Prodotto> listaProdotti = managerProdotti.getAllElements();
                      ElaboratoreProdotti elaboratoreProdotti = new ElaboratoreProdotti(listaProdotti);
                      if(_nome != ""){
                        listaProdotti = elaboratoreProdotti.filtraPerNome(_nome);
                      }
                      if(_marca != ""){
                        listaProdotti = elaboratoreProdotti.filtraPerNome(_marca);
                      }
                      Navigator.of(context).push(
                          new MaterialPageRoute(builder: (context) {
                            return Scaffold(
                              appBar: AppBarFactory.getBackAppbar(),
                              body: VisualizzazioneProdotti(listaProdotti, type: ProductVisualizationContext.standard,),
                            );
                          })
                      );
                    }
                  },
                  child: Text("Cerca")
              ),
            ],
          ),
        ),
      ),
    );
  }
}