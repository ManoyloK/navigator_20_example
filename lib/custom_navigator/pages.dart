import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:navigator_example/custom_navigator/ui/home.dart';
import 'package:navigator_example/custom_navigator/ui/main_screen.dart';
import 'package:navigator_example/custom_navigator/ui/products.dart';
import 'package:navigator_example/custom_navigator/ui/root.dart';

import 'ui/base_dialog.dart';

enum Pages {
  root,
  home,
  products,
  details,
  details2,
  unknown,
  dialog,
}

Page getPage(Pages? page, {bool fullscreenDialog = false}) {
  switch (page) {
    case Pages.root:
      return MaterialPage(
        child: MainScreen(),
        key: ValueKey('/root'),
        name: '/root',
        restorationId: '/root',
      );
    case Pages.home:
      return MaterialPage(
        child: HomeScreen(),
        key: ValueKey('/home'),
        name: '/home',
        restorationId: '/home',
      );
    case Pages.products:
      return MaterialPage(
        child: Products(),
        key: PageStorageKey('/products'),
        name: '/products',
        restorationId: '/products',
      );
    case Pages.details:
      return MaterialPage(
        child: Scaffold(
          body: Center(
            child: Builder(
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      color: Colors.cyan,
                      onPressed: () {
                        TheAppRouterDelegate.pageManager
                            .push(Pages.details2, rootNavigator: true);
                      },
                      child: Text('Open details from root'),
                    ),
                    MaterialButton(
                      color: Colors.cyan,
                      onPressed: () {
                        TheAppRouterDelegate.pageManager.pop();
                      },
                      child: Text('back'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        key: ValueKey('/details'),
        name: '/details',
        restorationId: '/details',
      );
    case Pages.details2:
      return MaterialPage(
        child: Scaffold(
          body: Center(child: Builder(
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Details'),
                  MaterialButton(
                    color: Colors.cyan,
                    onPressed: () {
                      TheAppRouterDelegate.pageManager.pop();
                    },
                    child: Text('back'),
                  ),
                ],
              );
            },
          )),
        ),
        key: ValueKey('/details2'),
        name: '/details2',
        restorationId: '/details2',
      );
    case Pages.dialog:
      return ModalBottomSheetDialog(
        builder: (context) => BaseDialog(),
        key: ValueKey('/dialog'),
        name: '/dialog',
      );
    default:
      return MaterialPage(
        child: Container(
          color: Colors.amber,
        ),
        key: ValueKey('/unknown'),
        name: '/unknown',
        restorationId: '/unknown',
      );
  }
}

class ModalBottomSheetDialog<T> extends Page<T> {
  const ModalBottomSheetDialog({
    required this.builder,
    String? name,
    Key? key,
  }) : super(key: key as LocalKey?, name: name);
  final WidgetBuilder builder;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute(
      builder: builder,
      settings: this,
      expanded: false,
    );
  }

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Page) {
      return key == other.key;
    } else {
      return super == other;
    }
  }
}
