import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Prodotto.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'package:greet_food/Widgets/Forms/PagineEsito.dart';
import 'package:provider/provider.dart';


/**
 * Form per la creazione di un Prodotto
 */

class PaginaCreazioneProdotto extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBackAppbar(),
      body: FormCreazioneProdotto(),
    );
  }
}

final formKey = GlobalKey<FormState>();

class FormCreazioneProdotto extends StatelessWidget{

  late String nomeProdotto;
  late String marca;
  late String descrizione;
  late bool alKg;

  String? _codice;

  /**
   * Se codice = null o non viene assegnato il prodotto non avrà un codice a barre associato
   */
  FormCreazioneProdotto({String? codice = null}){
    this._codice = codice;
  }

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
                this.nomeProdotto = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Marca',
              ),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return "errore";
                }
                return null;
              },
              onSaved: (value) {
                this.marca = value!;
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
                this.descrizione = value!;
              },
            ),

            ElevatedButton(
                onPressed: (){
                  if(formKey.currentState!.validate()){
                      formKey.currentState!.save();
                      Navigator.of(context).pop();
                      Prodotto nuovoProdotto = Prodotto(
                          this.nomeProdotto,
                          this.marca,
                          "Assets/PlaceholderImage.png", //TODO permettere un immmagine custom
                          this.descrizione,
                          this._codice,
                          false,
                      );
                      GenericManager<Prodotto> managerProdotti = Provider.of<GenericManager<Prodotto>>(context, listen: false);
                      managerProdotti.addElement(nuovoProdotto);
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) {
                                return PaginaConferma("Prodotto inserito con successo");
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

