import 'package:flutter/material.dart';

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
            OutlineButton(
              child: Text('Open Details'),
              onPressed: () {
                //RoutePageManager.of(context).openDetails();
              },
            ),
          ],
        ),
      ),
    );
  }
}
