import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/app.dart';
import 'package:navigator_example/custom_navigator/navigation/page_configuration.dart';
import 'package:navigator_example/custom_navigator/navigation/pages.dart';

class About extends StatefulWidget {
  const About({
    this.tabIndex,
    Key? key,
  }) : super(key: key);
  final int? tabIndex;

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Object? result;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: widget.tabIndex ?? 0,
    );
  }

  @override
  void didUpdateWidget(covariant About oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabIndex != null) {
      result = null;
      _tabController!.animateTo(widget.tabIndex!);
    }
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
              child: Center(child: Text('Tab A')),
            ),
            Container(
              color: Colors.orange,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Tab B'),
                    if (result != null) Text('Result:$result'),
                    MaterialButton(
                      color: Colors.cyan,
                      onPressed: () async {
                        result = await App.pageManager
                            .navigateForResult(
                          PageConfiguration(uiPage: Pages.details),
                          rootNavigator: true,
                        );
                        setState(() {});
                      },
                      child: Text('Open details from root'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.purple,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Tab C'),
                    if (result != null) Text('Result:$result'),
                    MaterialButton(
                      color: Colors.cyan,
                      onPressed: () async {
                         result = await App.pageManager
                            .navigateForResult(
                          PageConfiguration(uiPage: Pages.details),
                        );
                        setState(() {});
                      },
                      child: Text('Open details'),
                    ),
                    MaterialButton(
                      color: Colors.cyan,
                      onPressed: () {
                        App.pageManager.navigateToPage(
                          Pages.dialog,
                          rootNavigator: true,
                        );
                      },
                      child: Text('Open dialog'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        TabBar(
          onTap: (index) {
            result = null;
            _tabController!.animateTo(index);
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
