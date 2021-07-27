import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/page_nested_navigation_state.dart';
import 'package:navigator_example/custom_navigator/pages.dart';
import 'package:provider/provider.dart';

abstract class NavHost extends ChangeNotifier {
  static NavHost of(BuildContext context) {
    return Provider.of<NavHost>(context, listen: false);
  }

  final Pages rootPage;

  NavHost(this.rootPage);

  List<Page> get pages;

  List<NavHost> get nestedNavigationHosts;

  NavHost get nestedNavHost;

  GlobalKey<NavigatorState> get navigatorKey;

  void registerNestedNavHost(Pages rootPage);

  void didPop({Page page});

  void push(Pages page, {bool rootNavigator = false});
}

class RootNavHost extends NavHost {
  RootNavHost({
    Pages rootPage,
    GlobalKey<NavigatorState> navigatorKey,
  })  : _pages = [
          getPage(rootPage),
        ],
        _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(),
        currentPath = rootPage,
        super(rootPage);

  static RootNavHost of(BuildContext context) {
    return Provider.of<RootNavHost>(context, listen: false);
  }

  List<Page> get pages => List.unmodifiable(_pages);

  List<NavHost> get nestedNavigationHosts => List.unmodifiable(
      _pageNestedNavigationHosts[_pages.last]?.nestedNavigationHosts ?? []);

  final List<Page> _pages;

  final _navigatorKey;

  final Map<Page, PageNestedNavigationState> _pageNestedNavigationHosts = {};

  Map<Page, PageNestedNavigationState> get pageNestedNavigationHosts =>
      _pageNestedNavigationHosts;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  NavHost get nestedNavHost =>
      _pageNestedNavigationHosts[_pages.last]?.nestedNavHost;

  Pages currentPath;

  void registerNestedNavHost(Pages rootPage) {
    if (_pageNestedNavigationHosts[_pages.last] == null) {
      _pageNestedNavigationHosts[_pages.last] = PageNestedNavigationState();
    }
    _pageNestedNavigationHosts[_pages.last].registerNestedNavHost(rootPage);
  }

  @override
  void didPop({Page page}) {
    if (nestedNavHost != null) {
      if (nestedNavHost.nestedNavigationHosts.isNotEmpty) {
        nestedNavHost.nestedNavHost.didPop();
      } else if (nestedNavHost.pages.length > 1) {
        nestedNavHost.didPop();
      } else {
        _pageNestedNavigationHosts[_pages.last]
            .nestedNavigationHosts
            .remove(_pages.last);
      }
    } else {
      if (_pages.length > 1) _pages.removeLast();
    }
    notifyListeners();
  }

  @override
  void push(
    Pages page, {
    bool rootNavigator = false,
  }) {
    if (page == rootPage) {
      notifyListeners();
      return;
    }

    var navigationState = _pageNestedNavigationHosts[_pages.last];
    if (!rootNavigator && navigationState.nestedNavHost != null) {
      if (navigationState.isRoot(page)) {
        navigationState.nestedHost = page;
      } else {
        navigationState.nestedNavHost.push(page);
      }
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
