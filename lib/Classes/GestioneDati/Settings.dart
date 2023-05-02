import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/**
 * Gestione delle impostazioni
 */
class Settings extends ChangeNotifier{

  String _path = "";

  int _giorniInScadenza = 5;
  bool _notificheAttive = false;

  bool _firstStart = true;

  int get giorniInScadenza => _giorniInScadenza;
  bool get notificheAttive => _notificheAttive;
  bool get firstStart => _firstStart;

  void setGiorniInScadenza(int days, {bool notify = true}){
    if(days < 1){
      throw Exception("Deve essere almeno 1 giorno");
    }
    this._giorniInScadenza = days;
    if(notify){
      this.saveToDisk();
      notifyListeners();
    }
  }

  void setNotificheAttive(bool notificheAttive, {bool notify = true}){
    this._notificheAttive = notificheAttive;
    if(notify){
      this.saveToDisk();
      notifyListeners();
    }
  }

  /**
   * Se chimato rimuove il primo avvio
   */
  void setFirstStartDone({bool notify = true}){
    this._firstStart = false;
    if(notify){
      this.saveToDisk();
      notifyListeners();
    }
  }

  /** Gestione persistenza **/

  Future<void> fromDisk(String passedPath) async {
    try{

      final directory = await getApplicationDocumentsDirectory();
      String completePath = directory.path + '/' + passedPath;
      File file = File(completePath);
      String jsonFile;
      jsonFile = await file.readAsString();
      print("$jsonFile");
      print("${jsonDecode(jsonFile)}");


      final data = jsonDecode(jsonFile);
      this._giorniInScadenza = data["_giorniInScadenza"];
      this._notificheAttive = data["_notificheAttive"];
      this._firstStart = data["_firstStart"];

    }catch(exeption){
      print(exeption);
    }
    this.notifyListeners();
  }

  /**
   * Salvaaggio su disco
   */
  void setSavingPath(String path){
    this._path = path;
  }

  Future<void> saveToDisk({String passedPath = ''}) async{
    if(passedPath != ''){
      this._path = passedPath;
    }
    if(this._path == ''){
      throw Exception("Path not valid or not correctly set");
    }

    final directory = await getApplicationDocumentsDirectory();

    Map<String, dynamic> dictionary = {'_giorniInScadenza' : this._giorniInScadenza,
      '_notificheAttive' : this._notificheAttive,
      '_firstStart' : this._firstStart,};
    String jsonData = jsonEncode(dictionary);

    String completePath = directory.path + '/' + this._path;
    File file = File(completePath);
    await file.writeAsString(jsonData);
    print("$jsonData");
    print("Saved at $completePath");
  }
}