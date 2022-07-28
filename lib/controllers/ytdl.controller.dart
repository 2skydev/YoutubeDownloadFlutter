import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:throttling/throttling.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytdl/utils/LocalNotification.dart';
import 'package:ytdl/utils/index.dart';

import '../config/theme.dart';

const String savePath = '/storage/emulated/0/Download/YTDL';

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

    if (url.isEmpty) {
      snackbar('불러오기 오류', '복사한 URL이 없습니다.');
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
      snackbar('불러오기 오류', '복사한 URL이 올바르지 않습니다.');
    }

    isFetching.value = false;
  }

  dynamic download({bool audioOnly = true}) async {
    await Permission.manageExternalStorage.request();

    try {
      var saveDir = Directory(savePath);

      if (!await saveDir.exists()) {
        await saveDir.create(recursive: true);
      }
    } catch (e) {
      snackbar('다운로드 오류', '다운로드 경로를 생성할 수 없습니다.\n$e');
    }

    isDownloading.value = true;

    final thr = Throttling(duration: const Duration(milliseconds: 100));

    var maxProgress = items.length * 100;
    var progress = 0;

    for (var item in items) {
      item.downloadStatus.value = 'pending';
    }

    for (var item in items) {
      try {
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
            '$savePath/${item.video.title}.${streamInfo.container}',
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
          item.downloadStatus.value = 'error';
        }

        print('done ${item.video.title}');
        print('-----------------------------');
      } catch (e) {
        item.downloadStatus.value = 'error';
        snackbar('다운로드 오류', '${item.video.title} 다운로드 실패\n$e');
      }
    }

    await LocalNotification.cancel(0);
    await LocalNotification.send(
      id: 1,
      title: 'YTDL 다운로드 완료',
      enableVibration: true,
      playSound: true,
    );

    snackbar('다운로드 완료', '다운로드가 완료되었습니다.\n다운로드 경로: 내장 메모리 > 다운로드 > YTDL');

    isDownloading.value = false;
  }
}
