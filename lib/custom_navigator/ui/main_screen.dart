import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/root_nav_host.dart';
import 'package:navigator_example/custom_navigator/pages.dart';
import 'package:navigator_example/custom_navigator/root_navigation_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  void _setPage(int index) {
    setState(() {
      _index = index;
      if (_index == 0) {
        RootNavHost.of(context).push(Pages.home);
      } else {
        RootNavHost.of(context).push(Pages.products);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              label: 'Navigator 2.0',
              icon: Icon(CupertinoIcons.square_stack_3d_up),
            ),
            BottomNavigationBarItem(
              label: 'Navigator',
              icon: Icon(CupertinoIcons.perspective),
            ),
            BottomNavigationBarItem(
              label: 'About',
              icon: Icon(CupertinoIcons.star_slash),
            ),
          ],
          onTap: _setPage,
          currentIndex: _index,
        ),
        body: RootNavigationWidget(
          navHost: RootNavHost.of(context),
          roots: [Pages.home, Pages.products],
        ),
      ),
    );
  }
}
