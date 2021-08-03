import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/page_configuration.dart';
import 'package:navigator_example/custom_navigator/navigation/pages.dart';
import 'package:provider/provider.dart';

import 'nav_host.dart';

class NestedNavHost extends NavHost {
  NestedNavHost({
    required PageName rootPage,
  }) : super(
          rootPage: rootPage,
        );

  static NestedNavHost of(BuildContext context) {
    return Provider.of<NestedNavHost>(context, listen: false);
  }

  PageName? _nestedHost;

  final Map<PageName, NestedNavHost> _nestedNavigationHosts = {};

  @override
  List<NestedNavHost> get nestedNavigationHosts =>
      _nestedNavigationHosts.values.toList();

  @override
  NestedNavHost? get nestedNavHost => _nestedNavigationHosts[_nestedHost];

  @override
  NestedNavHost? get rootNavHost => _nestedNavigationHosts[rootPage];

  @override
  void registerNestedNavHost(PageName rootPage) {
    _nestedHost ??= rootPage;
    _nestedNavigationHosts[rootPage] = NestedNavHost(rootPage: rootPage);
  }

  @override
  void pop({Object? result}) {
    if (_nestedHost != null) {
      if (nestedNavHost!.pages.length > 1) {
        nestedNavHost!.pop();
      } else {
        _nestedNavigationHosts.remove(_nestedHost);
        _nestedHost = _nestedNavigationHosts.keys.last;
      }
    } else {
      keepNavigationStack = false;
      final page = pagesInternal.removeLast();
      resultCompleters.remove(page)?.complete(result);
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
    if (pageConfig.uiPage != rootPage) {
      var navigationHost = _nestedNavigationHosts[pageConfig.uiPage];

      ///
      /// We use [page] as key for [_nestedNavigationHosts],
      /// so navigationHost == null means that [page] is not root page
      if (navigationHost == null && _nestedHost != null) {
        var navigateForResult =
            _nestedNavigationHosts[_nestedHost!]!.navigateForResult<T>(
          pageConfig,
          keepNavigationStack: keepNavigationStack,
        );
        notifyListeners();
        return navigateForResult;
      } else {
        return _addNewPage(
          pageConfig: pageConfig,
          replace: replace,
          keepNavigationStack: keepNavigationStack,
        );
      }
    } else {
      return _addNewPage(pageConfig: pageConfig, replace: replace);
    }
  }

  Future<T?> _addNewPage<T>({
    required PageConfiguration pageConfig,
    bool replace = false,
    bool keepNavigationStack = false,
  }) {
    this.keepNavigationStack = keepNavigationStack;
    var newPage = getPage(pageConfig);

    if (replace) {
      final pageIndex =
          pagesInternal.indexWhere((element) => element.name == newPage.name);
      if (pageIndex >= 0) {
        pagesInternal.removeRange(pageIndex, pagesInternal.length);
      }
      pagesInternal.add(newPage);
    } else if (pagesInternal.every((element) => element.name != newPage.name)) {
      pagesInternal.add(newPage);
    }
    final resultCompleter = Completer<T?>();
    resultCompleters[newPage] = resultCompleter;
    notifyListeners();
    return resultCompleter.future;
  }
}
