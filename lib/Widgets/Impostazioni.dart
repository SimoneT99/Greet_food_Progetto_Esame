import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/AppBars.dart';

/**
 * Pagina delle impostazioni
 */

class PaginaImpostazioni extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar,
      body: SizedBox.expand(
        child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        children: [

                          Text(
                            "Impostazioni",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "giorni \"in scadenza\"",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "notifiche",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ]
                    )
                )
            )
        ),
      )
    );
  }

}