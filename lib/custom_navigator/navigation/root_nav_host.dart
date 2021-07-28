import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/page_nested_navigation_state.dart';
import 'package:navigator_example/custom_navigator/pages.dart';
import 'package:provider/provider.dart';

import 'nav_host.dart';

class RootNavHost extends NavHost {
  RootNavHost({
    Pages? rootPage,
  }) : super(rootPage: rootPage);

  static RootNavHost of(BuildContext context) {
    return Provider.of<RootNavHost>(context, listen: false);
  }

  ///
  /// We need this to be able to store the root navigation tree when something
  /// was pushed to global navigation. Each page pushed as global we associate
  /// [PageNestedNavigationState] which contains information about nested
  /// navigation.
  ///
  final Map<Page, PageNestedNavigationState> _pageNestedNavigationHosts = {};

  Map<Page, PageNestedNavigationState> get pageNestedNavigationHosts =>
      _pageNestedNavigationHosts;

  @override
  NavHost? get nestedNavHost =>
      _pageNestedNavigationHosts[currentPages.last]?.nestedNavHost;

  @override
  List<NavHost> get nestedNavigationHosts => List.unmodifiable(
      _pageNestedNavigationHosts[currentPages.last]?.nestedNavigationHosts ??
          []);

  @override
  void registerNestedNavHost(Pages rootPage) {
    if (_pageNestedNavigationHosts[currentPages.last] == null) {
      _pageNestedNavigationHosts[currentPages.last] =
          PageNestedNavigationState();
    }
    _pageNestedNavigationHosts[currentPages.last]!
        .registerNestedNavHost(rootPage);
  }

  @override
  void pop({Page? page}) {
    if (nestedNavHost != null && nestedNavHost!.pages.length > 1) {
      nestedNavHost!.pop();
    } else {
      if (currentPages.length > 1) currentPages.removeLast();
    }
    notifyListeners();
  }

  @override
  void push(
    Pages page, {
    bool rootNavigator = false,
    bool fullscreenDialog = false,
  }) {
    print('push');
    if (page == rootPage && currentPages.isNotEmpty) {
      return;
    }

    var navigationState = _pageNestedNavigationHosts[currentPages.last];
    if (!rootNavigator && navigationState!.nestedNavHost != null) {
      if (navigationState.isRoot(page)) {
        navigationState.nestedHost = page;
      } else {
        navigationState.nestedNavHost!.push(page);
      }
    } else {
      var newPage = getPage(page, fullscreenDialog: fullscreenDialog);
      if (newPage.name != currentPages.last.name) {
        currentPages.add(newPage);
      }
    }

    notifyListeners();
  }
}
