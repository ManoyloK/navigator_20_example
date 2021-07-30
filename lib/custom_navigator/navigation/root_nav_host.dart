import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/page_nested_navigation_state.dart';
import 'package:navigator_example/custom_navigator/navigation/pages.dart';
import 'package:provider/provider.dart';

import 'nav_host.dart';
import 'page_configuration.dart';

class RootNavHost extends NavHost {
  RootNavHost({
    required Pages rootPage,
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
  void pop({Object? result}) {
    if (nestedNavHost != null && nestedNavHost!.pages.length > 1) {
      nestedNavHost!.pop(result: result);
    } else {
      if (currentPages.length > 1) {
        final page = currentPages.removeLast();
        resultCompleters.remove(page)?.complete(result);
      }
    }
    notifyListeners();
  }

 

  @override
  Future<T?> navigateForResult<T>(
    PageConfiguration pageConfig, {
    bool rootNavigator = false,
    bool fullscreenDialog = false,
    bool replace = false,
  }) async {
    if (pageConfig.uiPage == rootPage && currentPages.isNotEmpty) {
      return null;
    }

    var navigationState = _pageNestedNavigationHosts[currentPages.last];
    if (!rootNavigator && navigationState!.nestedNavHost != null) {
      var navigateForResult = navigationState.navigateForResult<T>(pageConfig, replace: replace);
      notifyListeners();
      return navigateForResult;
    } else {
      var newPage = getPage(pageConfig, fullscreenDialog: fullscreenDialog);
      if (newPage.name != currentPages.last.name) {
        currentPages.add(newPage);
        final resultCompleter = Completer<T?>();
        resultCompleters[newPage] = resultCompleter;
        notifyListeners();
        return resultCompleter.future;
      }
    }

    
  }
}
