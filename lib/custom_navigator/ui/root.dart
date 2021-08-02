import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/root_nav_host.dart';
import 'package:provider/provider.dart';

class Root extends StatefulWidget {
  Root(this.pageManager);
  final RootNavHost pageManager;

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    if (widget.pageManager.pages.length > 1) {
      widget.pageManager.pop();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RootNavHost>.value(
      value: widget.pageManager,
      child: Consumer<RootNavHost>(
        builder: (context, pageManager, child) {
          return Navigator(
            key: pageManager.navigatorKey,
            reportsRouteUpdateToEngine: true,
            onPopPage: _onPopPage,
            pages: pageManager.pages,
            restorationScopeId: 'root',
          );
        },
      ),
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) return false;

    /// Notify the PageManager that page was popped
    widget.pageManager.pop();

    return true;
  }
}
