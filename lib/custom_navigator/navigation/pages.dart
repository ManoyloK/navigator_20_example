import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:navigator_example/custom_navigator/navigation/page_configuration.dart';
import 'package:navigator_example/custom_navigator/ui/about.dart';
import 'package:navigator_example/custom_navigator/ui/details.dart';
import 'package:navigator_example/custom_navigator/ui/details_2.dart';
import 'package:navigator_example/custom_navigator/ui/home.dart';
import 'package:navigator_example/custom_navigator/ui/main_screen.dart';

import '../ui/base_dialog.dart';

enum PageName {
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
    case PageName.root:
      return MaterialPage(
        child: MainScreen(),
        name: '/root',
      );
    case PageName.home:
      return MaterialPage(
        child: HomeScreen(),
        name: 'home',
      );
    case PageName.about:
      var tabIndex = pageConfig.settings as int? ?? 0;
      return MaterialPage(
        child: About(
          tabIndex: tabIndex,
        ),
        name: 'about/${_getTabPage(tabIndex)}',
      );
    case PageName.details:
      return MaterialPage(
        child: Details(),
        name: 'details',
      );
    case PageName.details2:
      return MaterialPage(
        child: Details2(),
        name: 'details2',
      );
    case PageName.dialog:
      return ModalBottomSheetDialog(
        builder: (context) => BaseDialog(),
        name: 'dialog',
      );
    default:
      return MaterialPage(
        child: Container(
          color: Colors.amber,
        ),
        name: 'unknown',
      );
  }
}

String _getTabPage(index) {
  switch(index){
    case 1: return 'b';
    case 2: return 'c';
    default: return 'a';
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
