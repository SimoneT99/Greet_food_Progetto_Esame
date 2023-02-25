import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'package:greet_food/Widgets/Forms/PagineEsito.dart';
import 'package:provider/provider.dart';


/**
 * Form per la creazione di una dispensa
 */

class PaginaCreazioneDispensa extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBackAppbar(),
      body: FormCreazioneDispensa(),
    );
  }
}

final formKey = GlobalKey<FormState>();

class FormCreazioneDispensa extends StatelessWidget{

  late String nomeDispensa;
  late String descrizioneDispensa;
  late String posizioneDispensa;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                if(value == null || value.isEmpty){
                  return "errore";
                }
                return null;
              },
              onSaved: (value) {
                this.nomeDispensa = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Descrizione',
              ),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return "errore";
                }
                return null;
              },
              onSaved: (value) {
                this.descrizioneDispensa = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Posizione',
              ),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return "errore";
                }
                return null;
              },
              onSaved: (value) {
                this.posizioneDispensa = value!;
              },
            ),
            ElevatedButton(
                onPressed: (){
                  if(formKey.currentState!.validate()){
                      formKey.currentState!.save();
                      Navigator.of(context).pop();
                      Dispensa nuovaDispensa = Dispensa(
                          this.nomeDispensa,
                          "Assets/PlaceholderImage.png", //TODO permettere un immmagine custom
                          this.descrizioneDispensa,
                          this.posizioneDispensa);
                      GenericManager<Dispensa> managerDispense = Provider.of<GenericManager<Dispensa>>(context, listen: false);
                      managerDispense.addElement(nuovaDispensa);
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) {
                                return PaginaConferma("Dispensa inserita con successo");
                              }
                          )
                      );
                  }
                },
                child: Text("Avanti")
            ),
          ],
        ),
      ),
    );
  }
}

