import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/pages.dart';
import 'package:navigator_example/custom_navigator/root_nav_host.dart';
import 'package:provider/provider.dart';

class NestedNavHost extends NavHost {
  NestedNavHost({
    Pages rootPage,
    GlobalKey<NavigatorState> navigatorKey,
  })  : _pages = [
          getPage(rootPage),
        ],
        _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(),
        currentPath = rootPage,
        super(rootPage);

  static NestedNavHost of(BuildContext context) {
    return Provider.of<NestedNavHost>(context, listen: false);
  }

  List<Page> get pages => List.unmodifiable(_pages);

  List<NestedNavHost> get nestedNavigationHosts =>
      _nestedNavigationHosts.values.toList();

  final List<Page> _pages;

  Pages _nestedHost;

  final _navigatorKey;

  final Map<Pages, NestedNavHost> _nestedNavigationHosts = {};

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  NestedNavHost get nestedNavHost => _nestedNavigationHosts[_nestedHost];

  Pages currentPath;

  void registerNestedNavHost(Pages rootPage) {
    _nestedHost ??= rootPage;
    _nestedNavigationHosts[rootPage] = NestedNavHost(rootPage: rootPage);
  }

  void didPop({
    Page page,
  }) {
    if (_nestedHost != null) {
      if (nestedNavHost.nestedNavigationHosts.isNotEmpty) {
        nestedNavHost.nestedNavHost.didPop(page: page);
      } else if (nestedNavHost.pages.length > 1) {
        nestedNavHost.didPop(page: page);
      } else {
        _nestedNavigationHosts.remove(_nestedHost);
        _nestedHost = _nestedNavigationHosts.keys.last;
      }
    } else {
      if (page != null) {
        _pages.remove(page);
      } else {
        _pages.removeLast();
      }
    }
    notifyListeners();
  }

  void push(
    Pages page, {
    bool rootNavigator = false,
  }) {
    if (page == rootPage) return;

    var navigationHost = _nestedNavigationHosts[page];
    if (navigationHost == null && _nestedHost != null) {
      _nestedNavigationHosts[_nestedHost].push(page);
    } else {
      currentPath = page;
      var newPage = getPage(page);
      if (newPage.name != _pages.last.name) {
        _pages.add(newPage);
      }
    }
    notifyListeners();
  }
}
