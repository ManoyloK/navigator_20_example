import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/pages.dart';
import 'package:navigator_example/custom_navigator/ui/root.dart';

import 'navigation/root_nav_host.dart';

class App extends StatelessWidget {
  static RootNavHost pageManager = RootNavHost(
    rootPage: Pages.root,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Router Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      restorationScopeId: 'app',
      home: Root(pageManager),
    );
  }
}
