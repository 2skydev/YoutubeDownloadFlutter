import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ytdl/config/theme.dart';

void snackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    margin: EdgeInsets.only(top: 20.h),
    maxWidth: Sizes.designWidth.w * 0.95,
    duration: const Duration(seconds: 5),
    backgroundColor: Colors.white.withOpacity(0.8),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0, 2),
        blurRadius: 10,
      ),
    ],
  );
}
