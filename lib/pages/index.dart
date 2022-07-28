import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ytdl/components/ConfirmBottomSheet/index.dart';
import 'package:ytdl/components/SelectBottomSheet/index.dart';

import 'package:ytdl/components/Template/index.dart';
import 'package:ytdl/components/VideoItem/index.dart';
import 'package:ytdl/controllers/ytdl.controller.dart';

class IndexPage extends StatelessWidget {
  IndexPage({Key? key}) : super(key: key);

  YTDLController ytdlController = Get.put(YTDLController());

  @override
  Widget build(BuildContext context) {
    return Template(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => ElevatedButton(
                    onPressed: ytdlController.isFetching.value ||
                            ytdlController.isDownloading.value
                        ? null
                        : () {
                            ytdlController.load();
                          },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Obx(
                      () => Text(
                        ytdlController.isFetching.value
                            ? '불러오는중...'
                            : '복사한 URL 정보 추가하기',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  onPressed: () {
                    ytdlController.items.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    '초기화',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
                SizedBox(width: 10.w),
                Obx(
                  () => ElevatedButton(
                    onPressed: ytdlController.items.isEmpty ||
                            ytdlController.isDownloading.value
                        ? null
                        : () {
                            showSelectBottomSheet(
                              title: '다운로드 형식',
                              options: [
                                {
                                  'value': 'video',
                                  'label': '비디오',
                                  'description': 'video + audio',
                                },
                                {
                                  'value': 'audio',
                                  'label': '오디오',
                                  'description': 'audio only',
                                },
                              ],
                              onChange: (option) {
                                ytdlController.download(
                                  audioOnly: option['value'] == 'audio',
                                );
                              },
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      '다운로드',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    children: ytdlController.items.asMap().entries.map((entry) {
                      return Column(
                        children: [
                          VideoItem(
                            item: entry.value,
                            index: entry.key,
                            onDelete: (index) {
                              ytdlController.items.removeAt(index);
                            },
                          ),
                          SizedBox(height: 20.h),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
