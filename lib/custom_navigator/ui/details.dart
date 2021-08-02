import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/app.dart';
import 'package:navigator_example/custom_navigator/navigation/page_configuration.dart';

import '../navigation/pages.dart';

class Details extends StatefulWidget {
  const Details({
    Key? key,
  }) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Object? result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (result != null) Text('Result:$result'),
                MaterialButton(
                  color: Colors.cyan,
                  onPressed: () async {
                    result = await App.pageManager
                        .navigateForResult(
                      PageConfiguration(uiPage: Pages.details2),
                      rootNavigator: true,
                    );

                    setState(() {});
                  },
                  child: Text('Open details from root'),
                ),
                MaterialButton(
                  color: Colors.cyan,
                  onPressed: () {
                    App.pageManager
                        .pop(result: 'from details page');
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
