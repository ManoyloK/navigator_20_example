import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/page_configuration.dart';
import 'package:navigator_example/custom_navigator/pages.dart';
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
  void pop() {
    if (_nestedHost != null) {
      if (nestedNavHost!.pages.length > 1) {
        nestedNavHost!.pop();
      } else {
        _nestedNavigationHosts.remove(_nestedHost);
        _nestedHost = _nestedNavigationHosts.keys.last;
      }
    } else {
      currentPages.removeLast();
    }
    notifyListeners();
  }

  void pushPage(
    Pages page, {
    bool rootNavigator = false,
    bool fullscreenDialog = false,
  }) {
    push(
      PageConfiguration(uiPage: page),
      rootNavigator: rootNavigator,
      fullscreenDialog: fullscreenDialog,
    );
  }

  @override
  void push(
    PageConfiguration pageConfig, {
    bool rootNavigator = false,
    bool fullscreenDialog = false,
  }) {
    if (pageConfig.uiPage != rootPage) {
      var navigationHost = _nestedNavigationHosts[pageConfig.uiPage];

      ///
      /// We use [page] as key for [_nestedNavigationHosts],
      /// so navigationHost == null means that [page] is not root page
      if (navigationHost == null && _nestedHost != null) {
        _nestedNavigationHosts[_nestedHost!]!.push(pageConfig);
      } else {
        _addNewPage(pageConfig);
      }
    } else {
      _addNewPage(pageConfig);
    }
    notifyListeners();
  }

  void _addNewPage(PageConfiguration pageConfig) {
    var newPage = getPage(pageConfig);
    final pageIndex =
        currentPages.indexWhere((element) => element.name == newPage.name);
    if (pageIndex >= 0) {
      currentPages.removeRange(pageIndex, currentPages.length);
    }

    currentPages.add(newPage);
  }
}
