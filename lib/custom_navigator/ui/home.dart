import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/root_nav_host.dart';
import 'package:navigator_example/custom_navigator/pages.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Router Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home Router Screen'),
            SizedBox(height: 20),
            MaterialButton(
              color: Colors.cyan,
              onPressed: () {
                RootNavHost.of(context).pushPage(Pages.details);
              },
              child: Text('Open Details'),
            ),
          ],
        ),
      ),
    );
  }
}
