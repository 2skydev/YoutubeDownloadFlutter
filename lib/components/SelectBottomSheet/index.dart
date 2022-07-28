import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ytdl/config/theme.dart';

void showSelectBottomSheet(
    {required String title,
    required List<dynamic> options,
    Function(dynamic option)? onChange}) {
  Get.bottomSheet(
    SelectBottomSheet(
      title: title,
      options: options,
      onChange: onChange,
    ),
    isScrollControlled: true,
  );
}

class SelectBottomSheet extends StatelessWidget {
  String title;
  List<dynamic> options;
  Function(dynamic option)? onChange;

  SelectBottomSheet({
    required this.title,
    required this.options,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: Sizes.designWidth,
        height: Sizes.designHeight * 0.6,
        padding: EdgeInsets.only(
          top: 30.h,
          left: Sizes.rapSize,
          right: Sizes.rapSize,
        ),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.close,
                    color: Palette.grayText1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.h),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  children: options.map((option) {
                    return GestureDetector(
                      onTap: () {
                        Get.back();
                        onChange!(option);
                      },
                      child: Container(
                        width: Sizes.designWidth - Sizes.rapSize * 2,
                        padding: EdgeInsets.only(
                          top: Sizes.rapSize,
                          bottom: Sizes.rapSize,
                        ),
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              option['label'],
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Palette.grayText1,
                              ),
                            ),
                            Text(
                              option['description'],
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
