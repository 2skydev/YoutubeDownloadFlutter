import '../ModalContainer/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ytdl/config/theme.dart';

void showButtonBottomSheet({
  required Widget child,
  String cancelText = '취소',
  String okText = '확인',
  Function? onCancel,
  Function? onOk,
}) {
  Get.bottomSheet(
    ButtonBottomSheet(
      cancelText: cancelText,
      okText: okText,
      onCancel: onCancel,
      onOk: onOk,
      child: child,
    ),
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    enterBottomSheetDuration: const Duration(milliseconds: 150),
    exitBottomSheetDuration: const Duration(milliseconds: 150),
  );
}

class ButtonBottomSheet extends StatelessWidget {
  Widget child;
  String cancelText;
  String okText;
  Function? onCancel;
  Function? onOk;

  final isLoading = false.obs;
  final loadingButtonType = ''.obs;

  ButtonBottomSheet({
    required this.child,
    this.cancelText = '취소',
    this.okText = '확인',
    this.onCancel,
    this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      disableBar: true,
      child: Container(
        width: Sizes.designWidth,
        padding: EdgeInsets.only(
          left: Sizes.rapSize,
          right: Sizes.rapSize,
          bottom: MediaQuery.of(context).padding.bottom + 10.h,
        ),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: Sizes.designWidth, child: child),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          vertical: 18.h,
                        ),
                        shadowColor: Colors.transparent,
                        primary: const Color.fromRGBO(0, 0, 0, .05),
                        onPrimary: Colors.transparent,
                        onSurface: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          // side: BorderSide(
                          //   color: isLoading.value
                          //       ? Colors.transparent
                          //       : Colors.black.withOpacity(0.1),
                          //   width: 1,
                          // ),
                        ),
                      ),
                      onPressed: isLoading.value
                          ? null
                          : () async {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }

                              if (onCancel != null) {
                                loadingButtonType.value = 'cancel';
                                isLoading.value = true;
                                await onCancel!();
                                isLoading.value = false;
                              } else {
                                Get.back();
                              }
                            },
                      child: AnimatedSwitcher(
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                        duration: const Duration(milliseconds: 300),
                        child: Obx(
                          () => Text(
                            cancelText,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black
                                  .withOpacity(isLoading.value ? 0.3 : 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        minimumSize: Size(
                          double.infinity,
                          50.h,
                        ),
                        padding: null,
                        shadowColor: Colors.transparent,
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          side: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      onPressed: isLoading.value
                          ? null
                          : () async {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }

                              if (onOk != null) {
                                loadingButtonType.value = 'ok';
                                isLoading.value = true;
                                await onOk!();
                                isLoading.value = false;
                              } else {
                                Get.back();
                              }
                            },
                      child: AnimatedSwitcher(
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                        duration: const Duration(milliseconds: 300),
                        child:
                            (loadingButtonType.value == 'ok' && isLoading.value)
                                ? const SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 14.0,
                                  )
                                : Text(
                                    okText,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
