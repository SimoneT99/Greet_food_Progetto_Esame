import 'package:flutter/material.dart';
import 'package:greet_food/Classes/GestioneDati/Settings.dart';
import 'package:greet_food/Widgets/AppBars.dart';
import 'package:provider/provider.dart';

final formKey = GlobalKey<FormState>();

/**
 * Pagina delle impostazioni
 */

class PaginaImpostazioni extends StatefulWidget{

  late Settings settings;

  PaginaImpostazioni(this.settings);

  @override
  State<PaginaImpostazioni> createState() => _PaginaImpostazioniState();
}

class _PaginaImpostazioniState extends State<PaginaImpostazioni> {
  late int _currentDays;
  late bool _notificheAttive;

  @override
  void initState() {
    this._currentDays = widget.settings.giorniInScadenza;
    this._notificheAttive = widget.settings.notificheAttive;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar,
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text("Impostazioni",
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                  ),
                  //Nome
                  Text("Giorni anticipo scadenza:",
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).colorScheme.secondary,
                        filled: true,
                        border: OutlineInputBorder(

                        ),
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty || int.parse(value) < 1){
                          return "Devi inserire un numero valido";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        this._currentDays = int.parse(value!)!;
                      },
                      initialValue: this._currentDays.toString(),
                    ),
                  ),
                  Row(
                    children: [
                      Text("Notifiche attive:",
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      Checkbox(
                          value: this._notificheAttive,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (bool? value){
                            setState(() {
                              debugPrint("checkbox cliccata $value");
                              this._notificheAttive = value!;
                            });
                          }),
                    ],
                  ),

                  ElevatedButton(
                      onPressed: (){
                        if(formKey.currentState!.validate()){
                          formKey.currentState!.save();
                          this._saveChanges(context);
                        }
                        },
                      child: Text("Salva"))
                ],

              ),
            ),
          ),
        ),
      ),
    );
  }

  _saveChanges(BuildContext context){

    widget.settings.setGiorniInScadenza(this._currentDays, notify: false);
    widget.settings.setNotificheAttive(this._notificheAttive);

    SnackBar snackBar = SnackBar(
      content: Text("Impostazioni salvate"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}