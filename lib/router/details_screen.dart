import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../main_router.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key key, this.id}) : super(key: key);
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details $id'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$id',
              style: Theme.of(context).textTheme.headline3,
            ),
            Gap(20),
            MaterialButton(
              onPressed: () {
                RoutePageManager.of(context).openDetails();
              },
              child: Text('Open Details'),
            ),
            Gap(20),
            MaterialButton(
              onPressed: () {
                RoutePageManager.of(context).resetToHome();
              },
              child: Text('Reset to home'),
            ),
            Gap(20),
            MaterialButton(
              onPressed: () {
                RoutePageManager.of(context).addDetailsBelow();
              },
              child: Text('Add new Details below'),
            ),
          ],
        ),
      ),
    );
  }
}
