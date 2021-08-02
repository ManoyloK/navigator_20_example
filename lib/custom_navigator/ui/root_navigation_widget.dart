import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/pages.dart';
import 'package:provider/provider.dart';

import '../navigation/nav_host.dart';
import '../navigation/nested_nav_host.dart';
import '../navigation/root_nav_host.dart';

///
/// Registers nested routes for current [navHost]
///
class RootNavigationWidget extends StatefulWidget {
  const RootNavigationWidget({
    Key? key,
    this.roots = const [],
    required this.navHost,
  }) : super(key: key);
  final List<PageName> roots;
  final RootNavHost navHost;

  @override
  _RootNavigationWidgetState createState() => _RootNavigationWidgetState();
}

class _RootNavigationWidgetState extends State<RootNavigationWidget> {
  ///
  /// Needed to point to the right [navHost] when new page pushes as global
  /// navigation and root [navHost] updates
  ///
  Page? page;

  @override
  void initState() {
    super.initState();
    widget.roots.forEach(widget.navHost.registerNestedNavHost);
    page = widget.navHost.pages.last;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RootNavHost>(
      builder: (context, pageManager, child) {
        ///
        ///  Use [Stack] with [Offstage] instead of [IndexedStack] because
        ///  [IndexedStack] keep tracking children semantics, so they are
        ///  tappable even if they are not visible. [Offstage] creates only
        ///  [Element] for widget
        ///
        return Stack(
          children: [
            ...pageManager.pageNestedNavigationHosts[page!]!.nestedNavigationHosts.map((navHost) {
              return _OffstageNavigator(
                navHost: navHost,
                nestedNavHost: pageManager.pageNestedNavigationHosts[page!]!.nestedNavHost!,
              );
            })
          ],
        );
      },
    );
  }
}

class _OffstageNavigator extends StatelessWidget {
  const _OffstageNavigator({
    Key? key,
    required this.navHost,
    required this.nestedNavHost,
  }) : super(key: key);

  final NavHost navHost;
  final NavHost nestedNavHost;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      key: ValueKey(navHost.rootPage),
      offstage: nestedNavHost != navHost,
      child: ChangeNotifierProvider<NestedNavHost>.value(
        value: navHost as NestedNavHost,
        child: Navigator(
          key: navHost.navigatorKey,
          pages: navHost.pages,
          onPopPage: _onPopPage,
          restorationScopeId: navHost.rootPage.toString(),
        ),
      ),
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    print('Nested onPopPage was called!');
    navHost.pop(result: result);
    return route.didPop(result);
  }
}
