import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/pages.dart';
import 'package:provider/provider.dart';

import 'nav_host.dart';

class NestedNavHost extends NavHost {
  NestedNavHost({
    Pages rootPage,
    GlobalKey<NavigatorState> navigatorKey,
  }) : super(
          rootPage: rootPage,
        );

  static NestedNavHost of(BuildContext context) {
    return Provider.of<NestedNavHost>(context, listen: false);
  }

  Pages _nestedHost;

  final Map<Pages, NestedNavHost> _nestedNavigationHosts = {};

  @override
  List<NestedNavHost> get nestedNavigationHosts =>
      _nestedNavigationHosts.values.toList();

  @override
  NestedNavHost get nestedNavHost => _nestedNavigationHosts[_nestedHost];

  @override
  void registerNestedNavHost(Pages rootPage) {
    _nestedHost ??= rootPage;
    _nestedNavigationHosts[rootPage] = NestedNavHost(rootPage: rootPage);
  }

  @override
  void pop() {
    if (_nestedHost != null) {
      if (nestedNavHost.pages.length > 1) {
        nestedNavHost.pop();
      } else {
        _nestedNavigationHosts.remove(_nestedHost);
        _nestedHost = _nestedNavigationHosts.keys.last;
      }
    } else {
      currentPages.removeLast();
    }
    notifyListeners();
  }

  @override
  void push(Pages page, {
    bool rootNavigator = false,
    bool fullscreenDialog = false,
  }) {
    if (page == rootPage) return;

    var navigationHost = _nestedNavigationHosts[page];

    ///
    /// We use [page] as key for [_nestedNavigationHosts],
    /// so navigationHost == null means that [page] is not root page
    if (navigationHost == null && _nestedHost != null) {
      _nestedNavigationHosts[_nestedHost].push(page);
    } else {
      var newPage = getPage(page);
      if (newPage.name != currentPages.last.name) {
        currentPages.add(newPage);
      }
    }
    notifyListeners();
  }
}
