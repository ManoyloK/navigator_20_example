import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/nav_host.dart';
import 'package:navigator_example/custom_navigator/navigation/root_nav_host.dart';
import 'package:navigator_example/custom_navigator/pages.dart';
import 'package:provider/provider.dart';

void main() {
  TheAppRouterDelegate.pageManager = RootNavHost(
    rootPage: Pages.root,
  );
  runApp(TheApp());
}

class TheApp extends StatelessWidget {
  TheApp() {
    TheAppRouterDelegate.pageManager.push(Pages.root);
  }

  @override
  Widget build(BuildContext context) {
    print('TheApp');
    return MaterialApp.router(
      title: 'Flutter Router Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerDelegate: TheAppRouterDelegate(),
      routeInformationParser: TheAppRouteInformationParser(),
    );
  }
}

/// A delegate that is used by the [Router] widget to build and configure a
/// navigating widget.
///
/// This delegate is the core piece of the [Router] widget. It responds to
/// push route and pop route intent from the engine and notifies the [Router]
/// to rebuild. It also act as a builder for the [Router] widget and builds a
/// navigating widget, typically a [Navigator], when the [Router] widget
/// builds.
class TheAppRouterDelegate extends RouterDelegate<Pages>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Pages> {
  TheAppRouterDelegate() {
    // This part is important because we pass the notification
    // from RoutePageManager to RouterDelegate. This way our navigation
    // changes (e.g. pushes) will be reflected in the address bar
    pageManager.addListener(notifyListeners);
  }

  static NavHost pageManager;

  /// In the build method we need to return Navigator using [navigatorKey]
  @override
  Widget build(BuildContext context) {
    print('TheAppRouterDelegate');
    return ChangeNotifierProvider<NavHost>.value(
      value: pageManager,
      child: ChangeNotifierProvider<RootNavHost>.value(
        value: pageManager,
        child: Consumer<NavHost>(
          builder: (context, pageManager, child) {
            return Navigator(
              key: navigatorKey,
              onPopPage: _onPopPage,
              pages: List.of(pageManager.pages),
            );
          },
        ),
      ),
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) return false;

    /// Notify the PageManager that page was popped
    pageManager.pop();

    return true;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => pageManager.navigatorKey;

  @override
  Future<void> setNewRoutePath(Pages configuration) async {
    await pageManager.push(configuration);
  }
}

Pages parseRoute(Uri uri) {
  // Handle '/'
  if (uri.path == '/root') {
    return Pages.root;
  } else if (uri.path == '/home') {
    return Pages.home;
  } else if (uri.path == '/products') {
    return Pages.products;
  } else if (uri.path == '/unknown') {
    return Pages.unknown;
  } else if (uri.path == '/details') {
    return Pages.details;
  }

  // Handle unknown routes
  return Pages.root;
}

/// Parser inspired by https://github.com/acoutts/flutter_nav_2.0_mobx/blob/master/lib/main.dart
///
/// Using typed information instead of string allows for greater flexibility
class TheAppRouteInformationParser extends RouteInformationParser<Pages> {
  @override
  Future<Pages> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    return parseRoute(uri);
  }

  @override
  RouteInformation restoreRouteInformation(Pages path) {
    if (path == Pages.root) {
      return RouteInformation(location: '/root');
    }
    if (path == Pages.home) {
      return RouteInformation(location: '/home');
    }
    if (path == Pages.products) {
      return RouteInformation(location: '/products');
    }
    if (path == Pages.unknown) {
      return RouteInformation(location: '/unknown');
    }
    if (path == Pages.details) {
      return RouteInformation(location: '/details');
    }
    return null;
  }
}
