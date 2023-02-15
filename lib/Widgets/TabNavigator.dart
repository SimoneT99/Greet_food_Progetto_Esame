import 'package:flutter/material.dart';
import 'package:greet_food/Widgets/Factories/AppbarFactory.dart';
import 'Enumerations.dart';

/**
 * Classi che servono a gestire la bottom bar persistente
 */

class TabNavigatorRoutes{
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget{

  final MainSections section;
  final GlobalKey<NavigatorState> navigatorKey;

  TabNavigator(this.section, this.navigatorKey);

  void _push(BuildContext context, {int materialIndex: 500}) {
    var routeBuilders = _routeBuilders(context, materialIndex: materialIndex);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                routeBuilders[TabNavigatorRoutes.detail]!(context)));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
      {int materialIndex: 500}) {
    return {
      TabNavigatorRoutes.root: (context) => Scaffold(
        appBar: AppBarFactory.getEmptyAppbar(),
        body: TextButton(
            onPressed: () => _push(context),
            child: Text(
                'Aggiungi',
                style: TextStyle(fontSize: 32.0, color: Colors.black),
              ),
            )
        ),
      TabNavigatorRoutes.detail: (context) => Scaffold(
          appBar: AppBarFactory.getBackAppbar(),
          body: TextButton(
            onPressed: () => _push(context),
            child: Text(
              'Aggiungi',
              style: TextStyle(fontSize: 32.0, color: Colors.black),
            ),
          )
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name]!(context));
        });
  }
}