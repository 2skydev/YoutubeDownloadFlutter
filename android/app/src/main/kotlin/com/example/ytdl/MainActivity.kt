package com.example.ytdl

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import android.webkit.MimeTypeMap
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.IOException

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                "flutter_media_store"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "addAudioItem" -> {
                    addAudioItem(call.argument("path")!!, call.argument("name")!!, call.argument("ext")!!)
                    result.success(null)
                }
                "addVideoItem" -> {
                    addVideoItem(call.argument("path")!!, call.argument("name")!!, call.argument("ext")!!)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun addAudioItem(path: String, name: String, ext: String) {
        Log.d("MediaStore", "path: $path")
        Log.d("MediaStore", "name: $name")
        Log.d("MediaStore", "DISPLAY_NAME: $name.$ext")
        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(ext)
        Log.d("MediaStore", "mimeType: $mimeType")

        val collection = MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)

        val values = ContentValues().apply {
            put(MediaStore.Audio.Media.RELATIVE_PATH, Environment.DIRECTORY_MUSIC + File.separator + "YTDL")
            put(MediaStore.Audio.Media.DISPLAY_NAME, "$name.$ext")
            put(MediaStore.Audio.Media.MIME_TYPE, mimeType)
        }

        val resolver = applicationContext.contentResolver
        val uri = resolver.insert(collection, values)!!

        resolver.openOutputStream(uri).use { os ->
            File(path).inputStream().use { it.copyTo(os!!) }
        }
    }

    private fun addVideoItem(path: String, name: String, ext: String) {
        Log.d("MediaStore", "path: $path")
        Log.d("MediaStore", "name: $name")
        Log.d("MediaStore", "DISPLAY_NAME: $name.$ext")
        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(ext)
        Log.d("MediaStore", "mimeType: $mimeType")

        val collection = MediaStore.Video.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)

        val values = ContentValues().apply {
            put(MediaStore.Video.Media.RELATIVE_PATH, Environment.DIRECTORY_MOVIES + File.separator + "YTDL")
            put(MediaStore.Video.Media.DISPLAY_NAME, "$name.$ext")
            put(MediaStore.Video.Media.MIME_TYPE, mimeType)
        }

        val resolver = applicationContext.contentResolver
        val uri = resolver.insert(collection, values)!!

        resolver.openOutputStream(uri).use { os ->
            File(path).inputStream().use { it.copyTo(os!!) }
        }
    }
}
