import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoPickerModule {
  static File _videoFile;
  static File newVideoPath;
  static String newVideoName;

  Future<bool> checkAndRequestCameraPermissions() async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.camera]);
      return permissions[PermissionGroup.camera] == PermissionStatus.granted;
    } else {
      return true;
    }
  }

  void onVideoPicker(ImageSource source, {BuildContext context}) async {
    if (await checkAndRequestCameraPermissions()) {
      _videoFile = await ImagePicker.pickVideo(
          source: source, maxDuration: const Duration(seconds: 10));
      newVideoPath = null;
      newVideoName = null;
      if (_videoFile == null) return;
      final String makedDir =
          (await getExternalStorageDirectory()).path + '/videos';
      bool isDirExist = await Directory(makedDir).exists();
      if (!isDirExist) Directory(makedDir).create();
      String videoSort = _videoFile.path.split('/').last;
      String tempPath = makedDir + '/' + videoSort;
      File video = File(tempPath);
      bool isExist = await video.exists();
      if (isExist) await video.delete();
      newVideoPath = await _videoFile.copy(tempPath);
      print(newVideoPath);
      newVideoName = videoSort;
      Navigator.pop(context);
    }
  }

  void modalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return new Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
            ),
            child: new Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Row(children: <Widget>[
                  SizedBox(
                    width: 50,
                  ),
                  Text('Video Pick From',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
                ]),
                SizedBox(
                  height: 30,
                ),
                Row(children: <Widget>[
                  SizedBox(
                    width: 70,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      onVideoPicker(ImageSource.gallery, context: context);
                    },
                    child: const Icon(Icons.video_library),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      onVideoPicker(ImageSource.camera, context: context);
                    },
                    child: const Icon(Icons.videocam),
                  )
                ])
              ],
            ),
          );
        });
  }
}
