import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';
import 'package:greet_food/Widgets/AppBars.dart';
import 'package:greet_food/Widgets/Forms/PaginaEsito.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Classes/Items/Articolo.dart';
import '../../Classes/Items/Prodotto.dart';
import 'Utility.dart';

/**
 * Pagine che implementano l'inserimento di un articolo
 */

class CreazioneArticolo extends StatelessWidget{

  late final Prodotto _prodotto;


  CreazioneArticolo(this._prodotto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar,
      body: FormCreazioneArticolo(_prodotto),
    );
  }
}

//widget con stato dato che dobbiamo gestire il multi inserimento degli articoli
class FormCreazioneArticolo extends StatefulWidget{

  late final Prodotto _prodotto;

  FormCreazioneArticolo(Prodotto prodotto) {
    this._prodotto = prodotto;
  }

  @override
  State<StatefulWidget> createState() {
    return new FormCreazioneArticoloStato();
  }
}

final formKey = GlobalKey<FormState>();

class FormCreazioneArticoloStato extends State<FormCreazioneArticolo>{

  //per la ripetizione degli inserimenti
  List<Articolo> _articoliInseriti = [];

  @override
  void initState() {
    super.initState();
  }

  /**
   * Parametri inseriti dall'utente, inizialmente a null
   */

  //Ultimi valori inseriti
  Dispensa? _dispensa = null;
  double? _prezzo = null;
  double? _peso = null;
  DateTime? _dataScadenza = null;

  List<Articolo> articoliInseriti = []; //sarebbe più sensato uno stack...


  //DatePicker
  TextEditingController dataScadenzaController = new TextEditingController();
  DateTime? currentDateTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: endFormAppbarAvvertimento(saveData, context, text: "Attenzione gli articoli che stai inserendo non verranno salvati"),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                //introduzione prodotto
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: AspectRatio(
                    aspectRatio: 2.8,
                    child: Row(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: FileImage(File(widget._prodotto.imagePath)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Text(
                                  widget._prodotto.nome,
                                  style: Theme.of(context).textTheme.headline6
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                        widget._prodotto.marca,
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context).textTheme.subtitle2
                                    ),
                                  ],
                                ),
                              ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                //Prezzo
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.euro),
                        fillColor: Theme.of(context).colorScheme.secondary,
                        filled: true,
                        border: OutlineInputBorder(

                        ),
                        labelText: 'Prezzo (euro.cent)',
                      ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Devi inserire un prezzo";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      this._prezzo = double.parse(value!);
                    },
                  ),
                ),

                //Data di scadenza
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: dataScadenzaController,
                    keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.schedule),
                        fillColor: Theme.of(context).colorScheme.secondary,
                        filled: true,
                        border: OutlineInputBorder(

                        ),

                        labelText: 'Data di scadenza',
                      ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Devi inserire una data di scadenza";
                      }
                      return null;
                    },
                    onTap: () async {
                      // Below line stops keyboard from appearing
                      FocusScope.of(context).requestFocus(new FocusNode());

                      // Show Date Picker Here
                      DateTime? datePicked = await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime(2016),
                          lastDate: new DateTime(3000)
                      );
                      dataScadenzaController.text = (new DateFormat("dd/MM/yyyy")).format(datePicked!);
                      this._dataScadenza = datePicked;
                    },
                  ),
                ),

                //Peso dell'articolo
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.scale),
                      fillColor: Theme.of(context).colorScheme.secondary,
                      filled: true,
                      border: OutlineInputBorder(

                      ),

                      labelText: 'Peso dell\'articolo (grammi)',
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Devi inserire un peso";
                      }
                      return null;
                    },
                    onSaved: (value) => {
                      this._peso = double.parse(value!)
                    },
                  ),
                ),

                //Dispensa
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Builder(
                      builder: (BuildContext context) {
                        GenericManager<Dispensa> gestoreDispense = Provider.of<GenericManager<Dispensa>>(context, listen: false);
                        List<Dispensa> dispense = gestoreDispense.getAllElements();
                        return DropdownButtonFormField(
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.kitchen),
                            fillColor: Theme.of(context).colorScheme.secondary,
                            filled: true,
                            border: OutlineInputBorder(

                            ),

                            labelText: 'Dispensa',
                          ),
                            items: dispense.map<DropdownMenuItem<Dispensa>>((Dispensa dispensa) {
                              return DropdownMenuItem<Dispensa>(
                                child: Text(dispensa.nome),
                                value: dispensa,
                              );
                        }).toList(),
                        onChanged: (value) {
                          //TODO
                        },
                        onSaved: (value){
                              this._dispensa = value;
                        },
                        );
                      }
                  ),
                ),

                /**
                 * Bottone ripeti: per ripetere gli inserimenti
                 */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Text("Inseriti: ${articoliInseriti.length}",
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: (){
                          debugPrint("Richiesta ripetizione inserimento");
                          if(formKey.currentState!.validate()){
                            formKey.currentState!.save();
                            Articolo nuovoArticolo = _generaArticolo();
                            this.articoliInseriti.add(nuovoArticolo);
                          }
                          setState(() {
                          });
                        },
                        child: Text("Prossimo")
                    ),
                  ]
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () => askConfirmationDialog(context, "Attenzione gli articoli che stai inserendo non verranno salvati"),
    );
  }


  /**
   * Genera un nuovo articolo
   */
  Articolo _generaArticolo(){
    Articolo nuovoArticolo;



    nuovoArticolo = new Articolo(
      idProdotto: widget._prodotto!.getCode(),
      idDispensa: this._dispensa!.id,
      prezzo: this._prezzo!,
      peso: this._peso!,
      dataScadenza: this._dataScadenza!,
      dataInserimento: DateTime.now(),
    );
    return nuovoArticolo;
  }

  /**
   * Salvataggio dei dati inseriti
   */

  void saveData(){
    if(formKey.currentState!.validate()){
      debugPrint("Richiesta fine inserimento");
      formKey.currentState!.save();
      //inserimento nuovi articoli
      Articolo nuovoArticolo = _generaArticolo();
      GenericManager<Articolo> gestoreArticoli = Provider.of<GenericManager<Articolo>>(context, listen: false);
      gestoreArticoli.addElement(nuovoArticolo);
      for(Articolo articolo in articoliInseriti){
        gestoreArticoli.addElement(articolo);
      }

      Navigator.of(context).pop();
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (context) {
                return PaginaEsito(
                    "${articoliInseriti.length + 1} Articolo/i inseriti correttamente",
                  Esito.positive
                );
              }
          )
      );
    }
  }
}