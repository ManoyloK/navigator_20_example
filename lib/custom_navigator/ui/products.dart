import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/pages.dart';
import 'package:navigator_example/custom_navigator/ui/root.dart';

class Products extends StatefulWidget {
  const Products({Key key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TabBarView(
          controller: _tabController,
          children: [
            Container(
              color: Colors.cyan,
            ),
            Container(
              color: Colors.orange,
              child: Center(
                child: MaterialButton(
                  child: Text('button'),
                  onPressed: () {
                    TheAppRouterDelegate.pageManager
                        .push(Pages.details, rootNavigator: true);
                  },
                ),
              ),
            ),
            Container(
              color: Colors.purple,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      child: Text('button'),
                      onPressed: () {
                        TheAppRouterDelegate.pageManager.push(Pages.details);
                      },
                    ),
                    MaterialButton(
                      child: Text('dialog'),
                      onPressed: () {
                        TheAppRouterDelegate.pageManager.push(
                          Pages.dialog,
                          rootNavigator: true,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        TabBar(
          onTap: (index) {
            _tabController.animateTo(index);
          },
          labelPadding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0),
          indicator: const BoxDecoration(),
          controller: _tabController,
          tabs: [
            Container(
              color: Colors.teal,
              height: kToolbarHeight,
              alignment: Alignment.center,
              child: Text(
                'A',
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              color: Colors.teal,
              height: kToolbarHeight,
              alignment: Alignment.center,
              child: Text(
                'B',
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              color: Colors.teal,
              height: kToolbarHeight,
              alignment: Alignment.center,
              child: Text(
                'C',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )
      ],
    );
  }
}
