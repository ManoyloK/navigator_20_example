import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/page_configuration.dart';
import 'package:navigator_example/custom_navigator/navigation/pages.dart';

/// Parser inspired by https://github.com/acoutts/flutter_nav_2.0_mobx/blob/master/lib/main.dart
///
/// Using typed information instead of string allows for greater flexibility
class TheAppRouteInformationParser
    extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    return parseRoute(uri);
  }

  @override
  RouteInformation? restoreRouteInformation(PageConfiguration path) {
    if (path.uiPage == Pages.root) {
      return RouteInformation(location: '/root');
    }
    if (path.uiPage == Pages.home) {
      return RouteInformation(location: '/home');
    }
    if (path.uiPage == Pages.about) {
      return RouteInformation(location: '/products');
    }
    if (path.uiPage == Pages.unknown) {
      return RouteInformation(location: '/unknown');
    }
    if (path.uiPage == Pages.details) {
      return RouteInformation(location: '/details');
    }
    return null;
  }
}

PageConfiguration parseRoute(Uri uri) {
  // Handle '/'
  if (uri.path == '/root') {
    return PageConfiguration(uiPage: Pages.root);
  } else if (uri.path == '/home') {
    return PageConfiguration(uiPage: Pages.home);
  } else if (uri.path == '/products') {
    return PageConfiguration(uiPage: Pages.about);
  } else if (uri.path == '/unknown') {
    return PageConfiguration(uiPage: Pages.unknown);
  } else if (uri.path == '/details') {
    return PageConfiguration(uiPage: Pages.details);
  }

  // Handle unknown routes
  return PageConfiguration(uiPage: Pages.root);
}
