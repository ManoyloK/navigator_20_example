import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/pages.dart';
import 'package:provider/provider.dart';

import 'page_configuration.dart';

abstract class NavHost extends ChangeNotifier {
  NavHost({
    required this.rootPage,
    GlobalKey<NavigatorState>? navigatorKey,
  })  : currentPages = [
          getPage(PageConfiguration(uiPage: rootPage)),
        ],
        _navigatorKey = navigatorKey ??
            GlobalKey<NavigatorState>(
              debugLabel: rootPage.toString(),
            );

  static NavHost of(BuildContext context) {
    return Provider.of<NavHost>(context, listen: false);
  }

  @protected
  final List<Page> currentPages;
  final PageName rootPage;
  final _navigatorKey;

  Map<Page, Completer<Object?>> resultCompleters = {};

  ///
  /// Stack of pages to be shown in [Navigator]
  ///
  List<Page> get pages => List.unmodifiable(currentPages);

  ///
  /// Contains all available navigation direction for example if we have bottom
  /// navigation bar with 3 tabs it will contain 3 NavHost one per tab
  ///
  List<NavHost> get nestedNavigationHosts;

  ///
  /// Currently selected navigation host, responsible for which one of
  /// [nestedNavigationHosts] currently active active
  ///
  NavHost? get nestedNavHost;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  void registerNestedNavHost(PageName rootPage);

  void pop({Object? result});

  void navigate(
    PageConfiguration page, {
    bool rootNavigator = false,
    bool fullscreenDialog = false,
    bool replace = false,
  }) async {
    await navigateForResult(
      page,
      rootNavigator: rootNavigator,
      fullscreenDialog: fullscreenDialog,
      replace: replace,
    );
  }

  Future<T?> navigateForResult<T>(
    PageConfiguration page, {
    bool rootNavigator = false,
    bool fullscreenDialog = false,
    bool replace = false,
  });

  void navigateToPage(
    PageName page, {
    bool rootNavigator = false,
    bool fullscreenDialog = false,
  }) {
    navigate(
      PageConfiguration(uiPage: page),
      rootNavigator: rootNavigator,
      fullscreenDialog: fullscreenDialog,
    );
  }
}
