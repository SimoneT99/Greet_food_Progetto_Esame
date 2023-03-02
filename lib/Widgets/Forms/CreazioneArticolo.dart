import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'package:greet_food/Widgets/Forms/PagineEsito.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Classes/Items/Articolo.dart';
import '../../Classes/Items/Prodotto.dart';

/**
 * Pagine che implementano l'inserimento di un articolo
 */

class CreazioneArticolo extends StatelessWidget{

  late final Prodotto _prodotto;


  CreazioneArticolo(this._prodotto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBackAppbar(),
      body: FormsCreazioneArticolo(_prodotto),
    );
  }
}

//widget con stato dato che dobbiamo gestire il multi inserimento degli articoli
class FormsCreazioneArticolo extends StatefulWidget{

  late final Prodotto _prodotto;

  FormsCreazioneArticolo(Prodotto prodotto) {
    this._prodotto = prodotto;
  }

  @override
  State<StatefulWidget> createState() {
    return new FormCreazioneArticoloStato();
  }
}

final formKey = GlobalKey<FormState>();

class FormCreazioneArticoloStato extends State<FormsCreazioneArticolo>{

  List<Articolo> _articoliInseriti = [];
  late final bool _alKg;

  @override
  void initState() {
    _alKg = widget._prodotto.alKg;
    super.initState();
  }

  /**
   * Parametri inseriti dall'utente, inizialmente a null
   */

  //Ultimi valori inseriti
  int? _idDispensa = null;
  double? _prezzo = 0;
  double? _weight = 1;
  DateTime? _dataScadenza = DateTime.now();

  List<Articolo> articoliInseriti = [];


  //DatePicker
  TextEditingController dataScadenzaController = new TextEditingController();
  DateTime? currentDateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: ListView(
          children: [

            //Prezzo
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Prezzo',
              ),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return "errore";
                }
                return null;
              },
              onSaved: (value) {
                this._prezzo = double.parse(value!);
              },
            ),

            //Data di scadenza
            TextFormField(
              controller: dataScadenzaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Data di scadenza',
              ),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return "errore";
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

            //Dispensa
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Dispensa',
              ),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return "errore";
                }
                return null;
              },
              onSaved: (value) {
                this._idDispensa = 1;
              },
            ),

            Row(
              children: [
                ElevatedButton(
                    onPressed: (){
                      debugPrint("Richiesta ripetizione inserimento");
                      if(formKey.currentState!.validate()){
                        Articolo nuovoArticolo = _generaArticolo();
                        this.articoliInseriti.add(nuovoArticolo);
                      }
                    },
                    child: Text("Ripeti")
                ),
                ElevatedButton(
                    onPressed: (){
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
                                  return PaginaConferma(
                                      "Articolo/i inseriti correttamente"
                                  );
                                }
                            )
                        );
                      }
                    },
                    child: Text("Fine"))
              ],
            ),

          ],
        ),
      ),
    );
  }

  Articolo _generaArticolo(){
    Articolo nuovoArticolo;
    if(_alKg){
      nuovoArticolo = new Articolo(
        idProdotto: widget._prodotto.getCode(),
        idDispensa: this._idDispensa!,
        prezzo: this._prezzo!,
        peso: this._weight!,
        dataScadenza: this._dataScadenza!,
        dataInserimento: DateTime.now(),
      );
    }else{
      nuovoArticolo = new Articolo(
        idProdotto: widget._prodotto.getCode(),
        idDispensa: this._idDispensa!,
        prezzo: this._prezzo!,
        dataScadenza: this._dataScadenza!,
        dataInserimento: DateTime.now(),
      );
    }
    return nuovoArticolo;
  }
}