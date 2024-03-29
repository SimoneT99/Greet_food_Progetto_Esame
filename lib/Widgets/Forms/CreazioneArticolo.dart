
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return FormCreazioneArticoloStato();
  }
}

final formKey = GlobalKey<FormState>();

class FormCreazioneArticoloStato extends State<FormCreazioneArticolo>{

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

  List<Articolo> articoliInseriti = [];


  //DatePicker
  TextEditingController dataScadenzaController = TextEditingController();
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
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: AspectRatio(
                    aspectRatio: 2.8,
                    child: Row(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: widget._prodotto.getImage().image,
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.euro),
                        fillColor: Theme.of(context).colorScheme.secondary,
                        filled: true,
                        border: const OutlineInputBorder(

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
                        suffixIcon: const Icon(Icons.schedule),
                        fillColor: Theme.of(context).colorScheme.secondary,
                        filled: true,
                        border: const OutlineInputBorder(

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
                      FocusScope.of(context).requestFocus(FocusNode());

                      // Show Date Picker Here
                      DateTime? datePicked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2016),
                          lastDate: DateTime(3000)
                      );
                      dataScadenzaController.text = (DateFormat("dd/MM/yyyy")).format(datePicked!);
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
                      suffixIcon: const Icon(Icons.scale),
                      fillColor: Theme.of(context).colorScheme.secondary,
                      filled: true,
                      border: const OutlineInputBorder(

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
                            suffixIcon: const Icon(Icons.kitchen),
                            fillColor: Theme.of(context).colorScheme.secondary,
                            filled: true,
                            border: const OutlineInputBorder(

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
                            //do nothing
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
                          HapticFeedback.heavyImpact();
                          debugPrint("Richiesta ripetizione inserimento");
                          if(formKey.currentState!.validate()){
                            formKey.currentState!.save();
                            Articolo nuovoArticolo = _generaArticolo();
                            this.articoliInseriti.add(nuovoArticolo);
                          }
                          setState(() {
                          });
                        },
                        child: const Text("Prossimo")
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

    nuovoArticolo = Articolo(
      idProdotto: widget._prodotto.getCode(),
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
    HapticFeedback.lightImpact();
    if(formKey.currentState!.validate()){
      debugPrint("Richiesta fine inserimento");
      formKey.currentState!.save();
      //inserimento nuovi articoli
      Articolo nuovoArticolo = _generaArticolo();
      GenericManager<Articolo> gestoreArticoli = Provider.of<GenericManager<Articolo>>(context, listen: false);

      for(Articolo articolo in articoliInseriti){
        gestoreArticoli.addElement(articolo, notifyListeners: false, saveToDisk: false); //evitiamo sia la scrittura che il rebuild
                                                                      //dei widget ad ogni articolo
      }

      gestoreArticoli.addElement(nuovoArticolo);
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(
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