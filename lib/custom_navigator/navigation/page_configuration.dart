import 'package:navigator_example/custom_navigator/navigation/pages.dart';

class PageConfiguration {
  PageConfiguration({
    required this.uiPage,
    this.settings,
  });

  final Object? settings;

  final PageName uiPage;
}
