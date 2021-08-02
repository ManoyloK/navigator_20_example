import 'package:navigator_example/custom_navigator/navigation/pages.dart';

import 'page_configuration.dart';

class DeepLinkParser {
  static List<PageConfiguration> parse(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      return [PageConfiguration(uiPage: PageName.root)];
    }
    final pages = <PageConfiguration>[];

    if (uri.pathSegments[0] == 'home') {
      pages.add(PageConfiguration(uiPage: PageName.home));
      if (uri.pathSegments.length > 1) {
        pages.add(PageConfiguration(uiPage: PageName.details));
      }
    }
    if (uri.pathSegments[0] == 'about') {
      var activeTab = 0;
      if (uri.pathSegments.length > 1) {
        if (uri.pathSegments[1] == 'a') {
          activeTab = 0;
        } else if (uri.pathSegments[1] == 'b') {
          activeTab = 1;
        } else {
          activeTab = 2;
        }
      }
      pages.add(PageConfiguration(uiPage: PageName.about, settings: activeTab));
      if (uri.pathSegments.length > 2 && uri.pathSegments[2] == 'details') {
        pages.add(PageConfiguration(
          uiPage: PageName.details2,
        ));
      }
    }

    return pages;
  }
}
