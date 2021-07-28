import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/deep_link_pacer.dart';
import 'package:navigator_example/custom_navigator/navigation/nav_host.dart';
import 'package:navigator_example/custom_navigator/navigation/page_configuration.dart';
import 'package:navigator_example/custom_navigator/navigation/root_nav_host.dart';
import 'package:navigator_example/custom_navigator/pages.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  TheAppRouterDelegate.pageManager = RootNavHost(
    rootPage: Pages.root,
  );
  runApp(TheApp());
}

class TheApp extends StatefulWidget {
  TheApp() {
    ///
    /// Needed to restore app state after it goes foreground
    ///
    TheAppRouterDelegate.pageManager
        .push(PageConfiguration(uiPage: Pages.root));
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
      restorationScopeId: 'router',
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
class TheAppRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  TheAppRouterDelegate() {
    // This part is important because we pass the notification
    // from RoutePageManager to RouterDelegate. This way our navigation
    // changes (e.g. pushes) will be reflected in the address bar
    pageManager.addListener(notifyListeners);
    uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        final pages = DeepLinkParser().parse(uri);
        pages.forEach((element) => pageManager.push(element));
      }
    }, onError: (Object err) {
      print('Got error $err');
    });
  }

  static late RootNavHost pageManager;

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
              reportsRouteUpdateToEngine: true,
              onPopPage: _onPopPage,
              pages: List.of(pageManager.pages),
              restorationScopeId: 'root',
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
  Future<void> setNewRoutePath(PageConfiguration configuration) async {
    pageManager.push(configuration);
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
