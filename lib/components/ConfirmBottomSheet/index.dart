import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ytdl/config/theme.dart';

import '../ButtonBottomSheet/index.dart';

void showConfirmBottomSheet({
  required String title,
  String? description,
  Function? onCancel,
  Function? onOk,
  String cancelText = '취소',
  String okText = '확인',
}) {
  showButtonBottomSheet(
    onCancel: onCancel,
    onOk: onOk,
    cancelText: cancelText,
    okText: okText,
    child: ConfirmBottomSheet(
      title: title,
      description: description,
    ),
  );
}

class ConfirmBottomSheet extends StatelessWidget {
  String title;
  String? description;

  ConfirmBottomSheet({
    required this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 40.h,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.sp,
          ),
        ),
        if (description != null)
          Container(
            padding: EdgeInsets.only(
              top: 5.h,
            ),
            child: Text(
              description!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Palette.grayText1,
              ),
            ),
          ),
        SizedBox(height: 40.h),
      ],
    );
  }
}
