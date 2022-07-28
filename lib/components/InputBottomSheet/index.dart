import 'package:ytdl/config/theme.dart';

import '../ButtonBottomSheet/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';

class InputLoadingController {
  RxBool loading = false.obs;
}

void showInputBottomSheet({
  required String title,
  String? description,
  String? defaultValue,
  String? placeholder,
  Function? onCancel,
  Function? onOk,
}) {
  InputLoadingController inputLoadingController = InputLoadingController();
  TextEditingController inputController =
      TextEditingController(text: defaultValue);

  showButtonBottomSheet(
    onCancel: onCancel,
    onOk: () async {
      inputLoadingController.loading.value = true;
      await onOk!(inputController.text);
      inputLoadingController.loading.value = false;
    },
    child: InputBottomSheet(
      title: title,
      description: description,
      defaultValue: defaultValue,
      placeholder: placeholder,
      inputController: inputController,
      inputLoadingController: inputLoadingController,
    ),
  );
}

class InputBottomSheet extends StatelessWidget {
  String title;
  String? description;
  String? defaultValue;
  String? placeholder;
  TextEditingController inputController;
  InputLoadingController inputLoadingController;

  InputBottomSheet({
    required this.title,
    required this.inputController,
    required this.inputLoadingController,
    this.description,
    this.defaultValue,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
          ),
        ),
        if (description != null)
          Text(
            description!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Palette.grayText1,
            ),
          ),
        SizedBox(height: 20.h),
        Obx(
          () => TextField(
            autofocus: true,
            enabled: !inputLoadingController.loading.value,
            controller: inputController,
            decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              hintText: placeholder,
            ),
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        ),
        SizedBox(height: 50.h),
      ],
    );
  }
}
