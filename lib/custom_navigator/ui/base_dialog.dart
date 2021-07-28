import 'package:flutter/material.dart';
import 'package:navigator_example/custom_navigator/navigation/root_nav_host.dart';

class BaseDialog extends StatefulWidget {
  @override
  _BaseDialogState createState() => _BaseDialogState();
}

class _BaseDialogState extends State<BaseDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
        child: SafeArea(
          child: Center(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Material(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Title'),
                      Text('Description'),
                      MaterialButton(
                        color: Colors.cyan,
                        onPressed: () {
                          RootNavHost.of(context).pop();
                        },
                        child: Text('back'),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
