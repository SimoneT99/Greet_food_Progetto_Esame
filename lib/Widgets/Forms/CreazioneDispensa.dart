import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';
import 'package:greet_food/Widgets/AppBars.dart';
import 'package:greet_food/Widgets/Forms/PaginaEsito.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'CameraWidget.dart';
import 'Utility.dart';

final formKey = GlobalKey<FormState>();

/**
 * Statefull widget perchè cambia l'immagine
 */
//TODO delete
class FormCreazioneDispensa extends StatefulWidget{

  //per trattare il caso di modifiche
  Dispensa? _dispensa;

  FormCreazioneDispensa(){}

  FormCreazioneDispensa.edit({required Dispensa dispensa}){
    this._dispensa = dispensa;
  }

  @override
  State<StatefulWidget> createState() {
    return FormCreazioneDispensaState();
  }
}

class FormCreazioneDispensaState extends State<FormCreazioneDispensa>{

  /**
   * Valori inseriti dall'utente
   */
  late String nomeDispensa;
  late String descrizioneDispensa;
  late String posizioneDispensa;
  String? pathImmagine;

  /*
    Ci serve solo per settare correttamente l'immagine in caso di edit
   */
  @override
  void initState(){
    if(widget._dispensa != null){
      this.imageProvider = FileImage(File(widget._dispensa!.imagePath));
      this.pathImmagine = widget._dispensa!.imagePath;
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
        appBar: endFormAppbarAvvertimento(saveData, context, text: "Attenzione la dispensa che stai creando non verrà salvata"),
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
                      this.nomeDispensa = value!;
                    },
                    initialValue: widget._dispensa != null ? widget._dispensa!.nome : null,
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
                      this.descrizioneDispensa = value!;
                    },
                    initialValue: widget._dispensa != null ? widget._dispensa!.descripion : null,
                  ),
                ),

                //Posizione
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.secondary,
                      filled: true,
                      border: OutlineInputBorder(
                      ),
                      labelText: 'Posizione',
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Devi inserire una posizione";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      this.posizioneDispensa = value!;
                    },
                    initialValue: widget._dispensa != null ? widget._dispensa!.posizione : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () => askConfirmationDialog(context, "Attenzione la dispensa che stai creando non verrà salvata"),
    );
  }

  void saveData(){
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      Navigator.of(context).pop();

      Dispensa nuovaDispensa;
      String message;
      GenericManager<Dispensa> managerDispense = Provider.of<GenericManager<Dispensa>>(context, listen: false);

      if(widget._dispensa == null){
        nuovaDispensa = Dispensa(
            this.nomeDispensa,
            this.pathImmagine != null ? this.pathImmagine! : "",
            this.descrizioneDispensa,
            this.posizioneDispensa);

        managerDispense.addElement(nuovaDispensa);

        message = "Dispensa inserita con successo";

      }else{
        nuovaDispensa = widget._dispensa!;
        nuovaDispensa.nome = this.nomeDispensa;
        nuovaDispensa.imagePath = this.pathImmagine!; //Non può essere nulla se arriviamo qua
        nuovaDispensa.descripion = this.descrizioneDispensa;
        nuovaDispensa.posizione = this.posizioneDispensa;

        managerDispense.replaceElement(nuovaDispensa);

        message = "Dispensa modificata con successo";
      }

      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) {
                return PaginaEsito(message, Esito.positive);
              }
          )
      );
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



