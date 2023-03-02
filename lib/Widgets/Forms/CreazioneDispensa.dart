import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/GenericManager.dart';
import 'package:greet_food/Classes/Items/Dispensa.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'package:greet_food/Widgets/Forms/PagineEsito.dart';
import 'package:path_provider/path_provider.dart';
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

  /**
   * Valori inseriti dall'utente
   */
  late String nomeDispensa;
  late String descrizioneDispensa;
  late String posizioneDispensa;
  String? pathImmagine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            ElevatedButton(
                onPressed: () {
                  _takePicture(context);
                },
                child: Text("Avanti")
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


  }
}

/**
 * Schermata per fare le foto
 */

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBackAppbar(),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            debugPrint("richiesta foto");
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}