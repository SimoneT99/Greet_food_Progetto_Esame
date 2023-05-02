import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/ElaboratoreProdotti.dart';
import 'package:greet_food/Widgets/AppBars.dart';
import 'package:greet_food/Widgets/VisualizzazioniCard/VisualizzazioneProdotto.dart';
import 'package:provider/provider.dart';

import '../Classes/GestioneDati/GenericManager.dart';
import '../Classes/Items/Prodotto.dart';
import 'PaginaScansione.dart';


final formKey = GlobalKey<FormState>();

class PaginaRicercaProdotto extends StatelessWidget{

  String _marca = "";
  String _nome = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    border: OutlineInputBorder(
                    ),
                    labelText: 'Nome',
                  ),
                  validator: (value) {
                    return null;
                  },
                  onSaved: (value){
                    this._nome = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    border: OutlineInputBorder(
                    ),
                    labelText: 'Marca',
                  ),
                  validator: (value) {
                    return null;
                  },
                  onSaved: (value){
                    this._marca = value!;
                  },
                ),
              ),


              /**
               * Azioni
               */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /**
                   * Pulsante usa codice
                   */
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                                new MaterialPageRoute(builder: (context) {
                                  return RicercaConScansione();
                                }));
                          },
                          child: Text("Scan")
                      ),
                    ),
                  ),

                  /**
                   * Pulsante Cerca
                   */
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
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
                                      appBar: backAppbar,
                                      body: VisualizzazioneProdotti(listaProdotti, type: ProductVisualizationContext.standard,),
                                    );
                                  })
                              );
                            }
                          },
                          child: Text("Cerca")
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

