import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/page_configuration.dart';
import 'package:navigator_example/custom_navigator/navigation/pages.dart';
import 'package:provider/provider.dart';

import 'nav_host.dart';

class NestedNavHost extends NavHost {
  NestedNavHost({
    required Pages rootPage,
  }) : super(
          rootPage: rootPage,
        );

  static NestedNavHost of(BuildContext context) {
    return Provider.of<NestedNavHost>(context, listen: false);
  }

  Pages? _nestedHost;

  final Map<Pages, NestedNavHost> _nestedNavigationHosts = {};

  @override
  List<NestedNavHost> get nestedNavigationHosts =>
      _nestedNavigationHosts.values.toList();

  @override
  NestedNavHost? get nestedNavHost => _nestedNavigationHosts[_nestedHost!];

  @override
  void registerNestedNavHost(Pages rootPage) {
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
      final page = currentPages.removeLast();
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
  }) async {
    if (pageConfig.uiPage != rootPage) {
      var navigationHost = _nestedNavigationHosts[pageConfig.uiPage];

      ///
      /// We use [page] as key for [_nestedNavigationHosts],
      /// so navigationHost == null means that [page] is not root page
      if (navigationHost == null && _nestedHost != null) {
        var navigateForResult = _nestedNavigationHosts[_nestedHost!]!
            .navigateForResult<T>(pageConfig);
        notifyListeners();
        return navigateForResult;
      } else {
        return _addNewPage(pageConfig: pageConfig, replace: replace);
      }
    } else {
      return _addNewPage(pageConfig: pageConfig, replace: replace);
    }
  }

  Future<T?> _addNewPage<T>({
    required PageConfiguration pageConfig,
    bool replace = false,
  }) {
    var newPage = getPage(pageConfig);

    if (replace) {
      final pageIndex =
          currentPages.indexWhere((element) => element.name == newPage.name);
      if (pageIndex >= 0) {
        currentPages.removeRange(pageIndex, currentPages.length);
      }
      currentPages.add(newPage);
    } else if (currentPages.every((element) => element.name != newPage.name)) {
      currentPages.add(newPage);
    }
    final resultCompleter = Completer<T?>();
    resultCompleters[newPage] = resultCompleter;
    notifyListeners();
    return resultCompleter.future;
  }
}
