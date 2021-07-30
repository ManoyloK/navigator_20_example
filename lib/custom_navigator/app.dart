import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/page_configuration.dart';
import 'package:navigator_example/custom_navigator/navigation/pages.dart';
import 'package:navigator_example/custom_navigator/navigation/route_information_parser.dart';
import 'package:navigator_example/custom_navigator/navigation/router_delegate.dart';

class TheApp extends StatefulWidget {
  TheApp() {
    ///
    /// Needed to restore app state after it goes foreground
    ///
    TheAppRouterDelegate.pageManager.navigate(PageConfiguration(uiPage: Pages.root));
  }

  @override
  _TheAppState createState() => _TheAppState();
}

class _TheAppState extends State<TheApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Router Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerDelegate: TheAppRouterDelegate(),
      routeInformationParser: TheAppRouteInformationParser(),
      restorationScopeId: 'app',
    );
  }
}
