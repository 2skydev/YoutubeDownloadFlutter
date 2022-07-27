import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ytdl/config/theme.dart';
import 'package:ytdl/controllers/ytdl.controller.dart';

const iconIndex = {
  'pending': 0,
  'downloading': 1,
  'done': 2,
  'error': 3,
};

const circleColors = {
  'downloading': Colors.blue,
  'done': Colors.green,
  'error': Colors.deepOrange,
};

class VideoItem extends StatelessWidget {
  int index;
  YTDLItem item;
  Function(int index)? onDelete;

  VideoItem({required this.item, required this.index, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              (index + 1).toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF7D8EB5),
              ),
            ),
            SizedBox(width: 10.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.w),
              child: SizedBox(
                width: 50.w,
                height: 50.h,
                child: Image.network(
                  item.video.thumbnails.mediumResUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Sizes.designWidth * 0.4,
                  child: Text(
                    item.video.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF344579),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: Sizes.designWidth * 0.4,
                  child: Text(
                    item.video.author,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF8394B9),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        Row(
          children: [
            Text(
              '${item.video.duration!.inMinutes}:${item.video.duration!.inSeconds.remainder(60).toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF8394B9),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10.w),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Obx(
                () => item.downloadStatus.value == 'init'
                    ? GestureDetector(
                        onTap: () {
                          if (onDelete != null) {
                            onDelete!(index);
                          }
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.w),
                            border: Border.all(
                              color: const Color.fromRGBO(0, 0, 0, 0.07),
                              width: 1.w,
                            ),
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: const Color(0xFF8394B9),
                            size: 16.sp,
                          ),
                        ),
                      )
                    : Container(
                        width: 40.w,
                        height: 40.h,
                        padding: EdgeInsets.all(5.w),
                        child: Stack(
                          children: [
                            CircularProgressIndicator(
                              value: item.downloadProgress.value,
                              strokeWidth: 2.w,
                              color: circleColors[item.downloadStatus.value],
                              backgroundColor:
                                  const Color.fromRGBO(0, 0, 0, 0.07),
                            ),
                            Positioned.fill(
                              left: 0,
                              top: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: IndexedStack(
                                  index: iconIndex[item.downloadStatus.value],
                                  children: [
                                    Icon(
                                      Icons.more_horiz_outlined,
                                      size: 16.sp,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                    Icon(
                                      Icons.download_rounded,
                                      size: 16.sp,
                                      color: Colors.blue,
                                    ),
                                    Icon(
                                      Icons.done_rounded,
                                      size: 16.sp,
                                      color: Colors.green,
                                    ),
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      size: 16.sp,
                                      color: Colors.deepOrange,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
