import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Prodotto.dart';
import 'package:greet_food/Widgets/AppBars.dart';
import 'package:greet_food/Widgets/Forms/CreazioneArticolo.dart';
import 'package:greet_food/Widgets/Forms/PaginaEsito.dart';
import 'package:greet_food/Widgets/PaginaAggiuntaArticolo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'CameraWidget.dart';
import 'Utility.dart';

/**
 * Stateful widget per gestire l'immagine
 */
class FormCreazioneProdotto extends StatefulWidget{

  String? _barcode;
  late bool _followUpArticolo;
  Prodotto? _prodotto;

  FormCreazioneProdotto({String? codice = null, bool followUpArticolo = false, Prodotto? prodotto = null}){
    this._barcode = codice;
    this._followUpArticolo = followUpArticolo;
    this._prodotto = null;
  }

  FormCreazioneProdotto.edit({bool followUpArticolo = false, required Prodotto prodotto}){
    this._barcode = null;
    this._followUpArticolo = followUpArticolo;
    this._prodotto = prodotto;
  }

  @override
  State<StatefulWidget> createState() {
    return FormCreazioneProdottoState();
  }

}


final formKey = GlobalKey<FormState>();

class FormCreazioneProdottoState extends State<FormCreazioneProdotto>{

  /**
   * Un prodotto ha un nome, una marca ed una posizione
   */
  late String nomeProdotto;
  late String marca;
  late String descrizione;
  String? pathImmagine;

  /*
    Ci serve solo per settare correttamente l'immagine in caso di edit
   */
  @override
  void initState(){
    if(widget._prodotto != null){
      this.imageProvider = FileImage(File(widget._prodotto!.imagePath));
      this.pathImmagine = widget._prodotto!.imagePath;
    }
  }


  /**
   * Image provider
   */
  ImageProvider<Object> imageProvider = AssetImage("Assets/Images/Camera3.png");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: endFormAppbarAvvertimento(saveData, context, text: "Attenzione il prodotto che stai creando non verrà salvato"),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: 125,
                    child: InkWell(
                      onTap: () {
                        _takePicture(context);
                      },
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          margin:  EdgeInsets.all(0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: imageProvider,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //Nome
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.secondary,
                      filled: true,
                      border: OutlineInputBorder(

                      ),

                      labelText: 'Nome',
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Devi inserire un nome";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      this.nomeProdotto = value!;
                    },
                    initialValue: widget._prodotto != null ? widget._prodotto!.nome : null,
                  ),
                ),

                //Marca
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.secondary,
                      filled: true,
                      border: OutlineInputBorder(
                      ),
                      labelText: 'Marca',
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Devi inserire una marca";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      this.marca = value!;
                    },
                    initialValue: widget._prodotto != null ? widget._prodotto!.marca : null,
                  ),
                ),

                //Descrizione
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.secondary,
                      filled: true,
                      border: OutlineInputBorder(
                      ),
                      labelText: 'Descrizione',
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Devi inserire una descrizione";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      this.descrizione = value!;
                    },
                    initialValue: widget._prodotto != null ? widget._prodotto!.descripion : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () => askConfirmationDialog(context, "Attenzione il prodotto che stai creando non verrà salvato"),
    );
  }

  void saveData(){
    HapticFeedback.lightImpact();
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Navigator.of(context).pop();

      Prodotto nuovoProdotto;
      GenericManager<Prodotto> managerProdotti = Provider.of<GenericManager<Prodotto>>(context, listen: false);

      String message;

      if(widget._prodotto == null){
        nuovoProdotto = Prodotto(
          nome: this.nomeProdotto,
          marca: this.marca,
          imagePath: this.pathImmagine != null
              ? this.pathImmagine!
              : DEFAULT_IMAGE,
          barcode: widget._barcode,
          descripion: this.descrizione,
          alKg: true,
        );

        managerProdotti.addElement(nuovoProdotto);

        message = "Prodotto Inserito con successo";

      }else{

        nuovoProdotto = widget._prodotto!;

        nuovoProdotto.nome = this.nomeProdotto;
        nuovoProdotto.marca = this.marca;
        nuovoProdotto.descripion = this.descrizione;
        nuovoProdotto.imagePath = this.pathImmagine != null ? this.pathImmagine! : "";

        managerProdotti.replaceElement(nuovoProdotto);

        message = "Prodotto modificato con successo";

      }

      /**
       * Qui in base a se vogliamo passare immediatamente all'inserimento
       * di un articolo o no cambia il comportamento
       */

      if(widget._followUpArticolo){
        Navigator.pop(context);
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) {
                  return FormCreazioneArticolo(nuovoProdotto);
                }
            )
        );
      }else{
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) {
                  return PaginaEsito(message,Esito.positive);
                }
            )
        );
      }
    }
  }

  Future<void> _takePicture(BuildContext context) async{

    List<CameraDescription> cameras = await availableCameras();
    if (cameras.length == 0){
      return;
    }

    CameraDescription firstCamera = cameras.first;

    String imagePath = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) {
              return TakePictureScreen(camera: firstCamera,);
            }
        )
    );

    File image = File(imagePath);
    Directory directory = await getApplicationDocumentsDirectory();
    File newFile = await image.copy('${directory.path}/${imagePath.split('/').last}');
    this.pathImmagine = newFile.path;

    setState(() {
      this.imageProvider = FileImage(File(imagePath));
    });

  }
}

