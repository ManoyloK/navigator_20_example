import 'package:navigator_example/custom_navigator/pages.dart';

import 'nested_nav_host.dart';

class PageNestedNavigationState {
  Pages? nestedHost;
  final Map<Pages, NestedNavHost> _nestedNavigationHosts = {};

  NestedNavHost? get nestedNavHost => _nestedNavigationHosts[nestedHost];

  List<NestedNavHost> get nestedNavigationHosts =>
      _nestedNavigationHosts.values.toList();

  void registerNestedNavHost(Pages rootPage) {
    nestedHost ??= rootPage;
    _nestedNavigationHosts[rootPage] = NestedNavHost(rootPage: rootPage);
  }

  bool isRoot(Pages page) => _nestedNavigationHosts.keys.contains(page);
}
