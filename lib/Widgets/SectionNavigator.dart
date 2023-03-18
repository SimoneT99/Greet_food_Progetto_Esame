import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/AppBars.dart';
import 'Enumerations.dart';

/**
 * Classi che servono a gestire la bottom bar persistente
 */

/*
class SectionNavigator extends StatelessWidget{

  final GlobalKey<NavigatorState> navigatorKey;

  SectionNavigator(this.navigatorKey);

  void _push(BuildContext context, {int materialIndex: 500}) {
    var routeBuilders = _routeBuilders(context, materialIndex: materialIndex);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                routeBuilders[TabNavigatorRoutes.detail]!(context)));
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: SectionNavigator.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name]!(context));
        });
  }
}
*/