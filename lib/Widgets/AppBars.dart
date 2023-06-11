import 'package:flutter/material.dart';
import 'package:path/path.dart';

/**
 * Appbar solo con il titolo dell'applicazione
 */

const String APP_NAME = "GreetFood";
const double HEIGHT = 50;

/**
 * Appbar preimpostate
 */
AppBar emptyAppbar = AppBar(
  automaticallyImplyLeading: false,
  toolbarHeight: HEIGHT,
  title: Text(APP_NAME),
);

AppBar drawerAppbar = AppBar(
  toolbarHeight: HEIGHT,
  title: Text(APP_NAME),
);

AppBar backAppbar = AppBar(
  toolbarHeight: HEIGHT,
  title: Text(APP_NAME),
  leading: BackButton(),
);

AppBar backAppbarAvvertimento(BuildContext context, {String text = 'Attenzione tornando indietro qello che stavi facendo non verrà salvato'}) {
  return AppBar(
    toolbarHeight: HEIGHT,
    title: Text(APP_NAME),
    leading: BackButton(
      onPressed: () {
        _askConfirmationDialog(context, text);
      },
    ),
  );
}

Future<void> _askConfirmationDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Annulla'),
            onPressed: () {
              debugPrint("Cancellazione annullata");
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Continua"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


AppBar endFormAppbar (void Function()? action) {
  return AppBar(
    toolbarHeight: HEIGHT,
    title: Text(APP_NAME),
    leading: BackButton(),
    actions: [
      Container(
        padding: EdgeInsets.all(10),
        child: OutlinedButton(
          onPressed: action,
          child: const Text('Fine'),
        ),
      ),
    ],
  );
}

AppBar endFormAppbarAvvertimento(void Function()? action, BuildContext context, {String text = 'Attenzione tornando indietro qello che stavi facendo non verrà salvato'}) {
  return AppBar(
    toolbarHeight: HEIGHT,
    title: Text(APP_NAME),
    leading: BackButton(
      onPressed: () {
        _askConfirmationDialog(context, text);
      },
    ),
    actions: [
      Container(
        padding: EdgeInsets.all(10),
        child: OutlinedButton(
          onPressed: action,
          child: const Text('Fine'),
        ),
      ),
    ],
  );
}

AppBar backAppbarEdit(void Function()? action) {
  return AppBar(
    toolbarHeight: HEIGHT,
    title: Text(APP_NAME),
    leading: BackButton(),
    actions: [
      Container(
        padding: EdgeInsets.all(10),
        child: OutlinedButton(
          onPressed: action,
          child: const Icon(Icons.edit_document),
        ),
      ),
    ],
  );
}

AppBar backAppbarAdd(void Function()? action){
  return AppBar(
    toolbarHeight: HEIGHT,
    title: Text(APP_NAME),
    leading: BackButton(),
    actions: [
      Container(
        padding: EdgeInsets.all(10),
        child: OutlinedButton(
          onPressed: action,
          child: const Icon(Icons.add),
        ),
      ),
    ],
  );
}