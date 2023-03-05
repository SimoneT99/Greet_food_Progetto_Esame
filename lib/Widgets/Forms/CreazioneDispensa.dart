import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'package:greet_food/Widgets/Forms/PagineEsito.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'CameraWidget.dart';


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

/**
 * Statefull widget perchè cambia l'immagine
 */
class FormCreazioneDispensa extends StatefulWidget{
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

  /**
   * Image provider
   */
  ImageProvider<Object> imageProvider = AssetImage("Assets/PlaceholderImage.png");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          this.pathImmagine != null ? this.pathImmagine! : "Assets/PlaceholderImage.png", //TODO permettere un immmagine custom
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
    this.pathImmagine = imagePath;

    setState(() {
      this.imageProvider = FileImage(File(imagePath));
    });

  }
}



