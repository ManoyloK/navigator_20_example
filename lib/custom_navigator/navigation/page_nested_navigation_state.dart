import 'package:navigator_example/custom_navigator/navigation/page_configuration.dart';
import 'package:navigator_example/custom_navigator/navigation/pages.dart';

import 'nested_nav_host.dart';

class PageNestedNavigationState {
  PageName? nestedHost;
  final Map<PageName, NestedNavHost> _nestedNavigationHosts = {};

  NestedNavHost? get nestedNavHost => _nestedNavigationHosts[nestedHost];

  List<NestedNavHost> get nestedNavigationHosts =>
      _nestedNavigationHosts.values.toList();

  void registerNestedNavHost(PageName rootPage) {
    nestedHost ??= rootPage;
    _nestedNavigationHosts[rootPage] = NestedNavHost(rootPage: rootPage);
  }

  bool isRoot(PageName page) => _nestedNavigationHosts.keys.contains(page);

  Future<T?> navigateForResult<T>(
    PageConfiguration pageConfig, {
    bool replace = false,
    bool keepNavigationStack = false,
  }) {
    if (isRoot(pageConfig.uiPage)) {
      nestedHost = pageConfig.uiPage;
    }
    return nestedNavHost!.navigateForResult(
      pageConfig,
      replace: replace,
      keepNavigationStack: keepNavigationStack,
    );
  }
}
