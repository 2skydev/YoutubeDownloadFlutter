import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:throttling/throttling.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytdl/utils/LocalNotification.dart';

import '../config/theme.dart';

class YTDLItem {
  Video video;
  RxDouble downloadProgress = 0.0.obs;
  RxString downloadStatus = 'init'.obs;

  YTDLItem({required this.video});
}

class YTDLController extends GetxController {
  YoutubeExplode yt = YoutubeExplode();

  RxBool isFetching = false.obs;
  RxBool isDownloading = false.obs;
  RxList<YTDLItem> items = RxList<YTDLItem>();

  dynamic load() async {
    isFetching.value = true;
    var clipboardData = await Clipboard.getData('text/plain');
    var url = clipboardData!.text ?? '';

    Get.snackbar(
      '디버깅',
      url,
      margin: EdgeInsets.only(top: 20.h),
      maxWidth: Sizes.designWidth.w * 0.95,
    );

    if (url.isEmpty) {
      Get.snackbar(
        '불러오기 오류',
        '복사한 URL이 없습니다.',
        margin: EdgeInsets.only(top: 20.h),
        maxWidth: Sizes.designWidth.w * 0.95,
      );
      return;
    }

    try {
      bool isPlaylist = url.contains('/playlist?list=');
      if (isPlaylist) {
        var playlist = await yt.playlists.get(url);

        await for (var video in yt.playlists.getVideos(playlist.id)) {
          items.add(YTDLItem(video: video));
        }
      } else {
        var video = await yt.videos.get(url);
        items.add(YTDLItem(video: video));
      }
    } catch (e) {
      Get.snackbar(
        '불러오기 오류',
        '복사한 URL이 올바르지 않습니다.',
        margin: EdgeInsets.only(top: 20.h),
        maxWidth: Sizes.designWidth.w * 0.95,
      );

      Get.snackbar(
        '디버깅',
        e.toString(),
        margin: EdgeInsets.only(top: 20.h),
        maxWidth: Sizes.designWidth.w * 0.95,
      );
    }

    isFetching.value = false;
  }

  dynamic download({bool audioOnly = true}) async {
    await Permission.manageExternalStorage.request();
    isDownloading.value = true;

    final thr = Throttling(duration: const Duration(milliseconds: 100));

    var maxProgress = items.length * 100;
    var progress = 0;

    for (var item in items) {
      item.downloadStatus.value = 'pending';
    }

    for (var item in items) {
      var index = items.indexOf(item);

      item.downloadStatus.value = 'downloading';

      var manifest = await yt.videos.streamsClient.getManifest(item.video.id);
      AudioStreamInfo streamInfo;

      if (audioOnly) {
        streamInfo = manifest.audioOnly.withHighestBitrate();
      } else {
        streamInfo = manifest.muxed.withHighestBitrate();
      }
      print('${index + 1} / ${items.length}');
      print(item.video.title);
      print(streamInfo.codec);
      print(streamInfo.qualityLabel);
      print(streamInfo.container);

      if (streamInfo != null) {
        var stream = yt.videos.streamsClient.get(streamInfo);

        var file = File(
          '/storage/emulated/0/Music/${item.video.title}.${streamInfo.container}',
        );

        var fileStream = file.openWrite();

        var received = 0;
        var nowProgress = progress;

        await stream.map((data) {
          received += data.length;

          item.downloadProgress.value =
              received / (streamInfo.size.totalKiloBytes * 1024);

          var itemProgress = (item.downloadProgress.value * 100).floor();

          progress = nowProgress + itemProgress;

          thr.throttle(() {
            print('progress: $itemProgress');

            LocalNotification.send(
              id: 0,
              title: 'YTDL 다운로드 진행중 (${index + 1}/${items.length})',
              body: '${item.video.title} 다운로드 중 $itemProgress%',
              showProgress: true,
              progress: progress,
              maxProgress: maxProgress,
              onlyAlertOnce: true,
            );
          });

          return data;
        }).pipe(fileStream);

        // Close the file.
        await fileStream.flush();
        await fileStream.close();

        item.downloadStatus.value = 'done';
      } else {
        item.downloadStatus.value = 'failed';
      }

      print('done ${item.video.title}');

      print('-----------------------------');
    }

    await LocalNotification.cancel(0);
    await LocalNotification.send(id: 1, title: 'YTDL 다운로드 완료');

    isDownloading.value = false;
  }
}
