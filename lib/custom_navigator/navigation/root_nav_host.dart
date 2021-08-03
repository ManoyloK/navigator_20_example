import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/page_nested_navigation_state.dart';
import 'package:navigator_example/custom_navigator/navigation/pages.dart';
import 'package:provider/provider.dart';

import 'nav_host.dart';
import 'page_configuration.dart';

class RootNavHost extends NavHost {
  RootNavHost({
    required PageName rootPage,
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
      _pageNestedNavigationHosts[pagesInternal.last]?.nestedNavHost;

  @override
  NavHost? get rootNavHost =>
      _pageNestedNavigationHosts[rootPage]?.nestedNavHost;

  @override
  List<NavHost> get nestedNavigationHosts => List.unmodifiable(
      _pageNestedNavigationHosts[pagesInternal.last]?.nestedNavigationHosts ??
          []);

  @override
  void registerNestedNavHost(PageName rootPage) {
    if (_pageNestedNavigationHosts[pagesInternal.last] == null) {
      _pageNestedNavigationHosts[pagesInternal.last] =
          PageNestedNavigationState();
    }
    _pageNestedNavigationHosts[pagesInternal.last]!
        .registerNestedNavHost(rootPage);
  }

  @override
  void pop({Object? result}) {
    if (nestedNavHost != null && nestedNavHost!.pages.length > 1) {
      nestedNavHost!.pop(result: result);
    } else {
      if (pagesInternal.length > 1) {
        keepNavigationStack = false;
        final page = pagesInternal.removeLast();
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
    bool keepNavigationStack = false,
  }) async {
    if (pageConfig.uiPage == rootPage && pagesInternal.isNotEmpty) {
      return null;
    }

    var navigationState = _pageNestedNavigationHosts[pagesInternal.last];
    if (!rootNavigator && navigationState!.nestedNavHost != null) {
      var navigateForResult = navigationState.navigateForResult<T>(
        pageConfig,
        replace: replace,
        keepNavigationStack: keepNavigationStack,
      );
      notifyListeners();
      return navigateForResult;
    } else {
      var newPage = getPage(pageConfig, fullscreenDialog: fullscreenDialog);
      if (newPage.name != pagesInternal.last.name) {
        this.keepNavigationStack = keepNavigationStack;
        pagesInternal.add(newPage);
        final resultCompleter = Completer<T?>();
        resultCompleters[newPage] = resultCompleter;
        notifyListeners();
        return resultCompleter.future;
      }
    }
  }
}
