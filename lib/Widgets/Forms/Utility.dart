import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/**
 * Funzioni utilizzate da più widget
 */


Future<bool> askConfirmationDialog(BuildContext context, String message) async {
  return (await showDialog<bool>(
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
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text("Continua"),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  )) ?? false;
}

String DEFAULT_IMAGE = "Assets/Images/Picture.png";