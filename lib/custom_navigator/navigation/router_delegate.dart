import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/deep_link_pacer.dart';
import 'package:navigator_example/custom_navigator/navigation/nav_host.dart';
import 'package:navigator_example/custom_navigator/navigation/page_configuration.dart';
import 'package:navigator_example/custom_navigator/navigation/root_nav_host.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

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
      _parseDeepLink(uri);
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
              pages: pageManager.pages,
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

  void _parseDeepLink(Uri? uri) {
    if (uri != null) {
      final pages = DeepLinkParser.parse(uri);
      pages.forEach((element) => pageManager.push(
            element,
            replace: true,
          ));
    }
  }
}
