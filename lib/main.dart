import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:ytdl/config/theme.dart';
import 'package:ytdl/routes/index.dart';

void main() async {
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 화면을 터치시 현재 포커스를 off
        // 주의: 작동이 안되면 Container 위젯에 colors: Colors.transparent 추가 (터치 영역으로 선언이 안되어서 그럼)
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: ScreenUtilInit(
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
      ),
    );
  }
}
