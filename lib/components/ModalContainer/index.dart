import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ytdl/config/theme.dart';

class ModalContainer extends StatelessWidget {
  Widget child;
  Color? color;
  double? height;
  EdgeInsets? padding;
  bool isFullScreen;
  bool disableBar = false;
  bool? closeIcon = false;
  double? radius;

  ModalContainer({
    required this.child,
    this.color,
    this.height,
    this.padding,
    this.isFullScreen = false,
    this.disableBar = false,
    this.radius,
    this.closeIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return ModalContainerWrap(
      isFullScreen: isFullScreen,
      child: Container(
        margin: EdgeInsets.only(top: isFullScreen ? 100.h : 0.h),
        decoration: BoxDecoration(
          color: color ?? Palette.bg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius ?? Sizes.bottomSheetRadius),
            topRight: Radius.circular(radius ?? Sizes.bottomSheetRadius),
          ),
        ),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Container(
                padding: EdgeInsets.only(top: disableBar ? 0 : 13.h),
                color: Colors.transparent,
                child: Container(
                  height: height ?? (isFullScreen ? Sizes.designHeight : null),
                  padding: padding,
                  child: child,
                ),
              ),
            ),
            if (!disableBar)
              Positioned.fill(
                top: 8,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 70.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30.sp)),
                  ),
                ),
              ),
            if (closeIcon != null && closeIcon == true)
              Positioned(
                right: 10,
                top: 10,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(LineIcons.times),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ModalContainerWrap extends StatelessWidget {
  Widget child;
  bool isFullScreen;

  ModalContainerWrap({
    required this.child,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isFullScreen) {
      return SizedBox(child: child);
    } else {
      return SingleChildScrollView(child: child);
    }
  }
}
