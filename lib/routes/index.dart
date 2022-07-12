import 'package:get/route_manager.dart';

import 'package:ytdl/pages/index.dart';

abstract class Routes {
  static const home = '/';
}

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => IndexPage(),
    ),
  ];
}
