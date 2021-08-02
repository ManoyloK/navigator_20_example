import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:navigator_example/custom_navigator/app.dart';
import 'package:navigator_example/custom_navigator/navigation/page_configuration.dart';
import 'package:navigator_example/custom_navigator/ui/about.dart';
import 'package:navigator_example/custom_navigator/ui/details.dart';
import 'package:navigator_example/custom_navigator/ui/home.dart';
import 'package:navigator_example/custom_navigator/ui/main_screen.dart';

import '../ui/base_dialog.dart';

enum Pages {
  root,
  home,
  about,
  details,
  details2,
  unknown,
  dialog,
}

Page getPage(PageConfiguration pageConfig, {bool fullscreenDialog = false}) {
  switch (pageConfig.uiPage) {
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
    case Pages.about:
      var tabIndex = pageConfig.settings as int? ?? 0;
      return MaterialPage(
        child: About(
          tabIndex: tabIndex,
        ),
        key: ValueKey('/about'),
        name: '/about',
        restorationId: '/about',
      );
    case Pages.details:
      return MaterialPage(
        child: Details(),
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
                  Text('Details 2'),
                  MaterialButton(
                    color: Colors.cyan,
                    onPressed: () {
                      App.pageManager.pop(result:'details 2' );
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
