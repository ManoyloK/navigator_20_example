import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/app.dart';

class Details2 extends StatelessWidget {
  const Details2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Details 2'),
                MaterialButton(
                  color: Colors.cyan,
                  onPressed: () {
                    App.pageManager.pop(result: 'details 2');
                  },
                  child: Text('back'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
