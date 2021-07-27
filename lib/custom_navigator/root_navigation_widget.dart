import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/pages.dart';
import 'package:provider/provider.dart';

import 'nested_nav_host.dart';
import 'root_nav_host.dart';

class RootNavigationWidget extends StatefulWidget {
  const RootNavigationWidget({
    Key key,
    this.roots = const [],
    this.navHost,
    this.name,
  }) : super(key: key);
  final List<Pages> roots;
  final RootNavHost navHost;
  final String name;

  @override
  _RootNavigationWidgetState createState() => _RootNavigationWidgetState();
}

class _RootNavigationWidgetState extends State<RootNavigationWidget> {
  Page page;

  @override
  void initState() {
    super.initState();
    widget.roots.forEach(widget.navHost.registerNestedNavHost);
    page = widget.navHost.pages.last;

    widget.navHost.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RootNavHost>(
      builder: (context, pageManager, child) {
        return Stack(
          children: [
            ...pageManager.pageNestedNavigationHosts[page].nestedNavigationHosts
                .map((navHost) {
              return _OffstageNavigator(
                navHost: navHost,
                nestedNavHost:
                    pageManager.pageNestedNavigationHosts[page].nestedNavHost,
              );
            })
          ],
        );
      },
    );
  }
}

class _OffstageNavigator extends StatefulWidget {
  const _OffstageNavigator({
    Key key,
    @required this.navHost,
    @required this.nestedNavHost,
  }) : super(key: key);

  final NavHost navHost;
  final NavHost nestedNavHost;

  @override
  __OffstageNavigatorState createState() => __OffstageNavigatorState();
}

class __OffstageNavigatorState extends State<_OffstageNavigator> {
  @override
  void initState() {
    super.initState();
    widget.navHost.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      key: ValueKey(widget.navHost.rootPage),
      offstage: !(widget.nestedNavHost == widget.navHost),
      child: ChangeNotifierProvider<NestedNavHost>.value(
        value: widget.navHost,
        child: Navigator(
          key: widget.navHost.navigatorKey,
          pages: List.of(widget.navHost.pages),
        ),
      ),
    );
  }
}
