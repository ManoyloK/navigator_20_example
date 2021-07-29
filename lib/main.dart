import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/app.dart';
import 'package:navigator_example/custom_navigator/navigation/pages.dart';
import 'package:navigator_example/custom_navigator/navigation/root_nav_host.dart';
import 'package:navigator_example/custom_navigator/navigation/router_delegate.dart';

void main() {
  TheAppRouterDelegate.pageManager = RootNavHost(
    rootPage: Pages.root,
  );
  runApp(TheApp());
}
