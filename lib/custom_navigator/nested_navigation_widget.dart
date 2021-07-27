import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/pages.dart';
import 'package:provider/provider.dart';

import 'nested_nav_host.dart';
import 'root_nav_host.dart';

class NestedNavigationWidget extends StatefulWidget {
  const NestedNavigationWidget({
    Key key,
    this.roots = const [],
    this.navHost,
    this.name,
  }) : super(key: key);
  final List<Pages> roots;
  final NavHost navHost;
  final String name;

  @override
  _NestedNavigationWidgetState createState() => _NestedNavigationWidgetState();
}

class _NestedNavigationWidgetState extends State<NestedNavigationWidget> {
  List<NavHost> nestedNavigationHosts;
  NestedNavHost nestedNavHost;

  @override
  void initState() {
    super.initState();
    widget.roots.forEach(widget.navHost.registerNestedNavHost);
    nestedNavigationHosts = widget.navHost.nestedNavigationHosts;
    nestedNavHost = widget.navHost.nestedNavHost;
    widget.navHost.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...nestedNavigationHosts.map((navHost) {
          return _OffstageNavigator(
            navHost: navHost,
            nestedNavHost: nestedNavHost,
          );
        })
      ],
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
