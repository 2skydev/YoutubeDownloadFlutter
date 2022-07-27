import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:ytdl/config/theme.dart';
import 'package:ytdl/routes/index.dart';
import 'package:ytdl/utils/LocalNotification.dart';

void main() async {
  await GetStorage.init();
  await LocalNotification.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(Sizes.defaultDesignWidth, Sizes.defaultDesignHeight),
      builder: (context, mediaQuery) {
        return GetMaterialApp(
          title: 'YTDL',
          debugShowCheckedModeBanner: false,
          theme: createAppTheme(context),
          initialRoute: '/',
          getPages: AppPages.routes,
        );
      },
    );
  }
}
