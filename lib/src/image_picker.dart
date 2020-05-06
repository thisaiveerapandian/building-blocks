import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerModule {
  File _imageFile;
  static File newImagePath;
  static String newImageName;
  static File createLocalFile;

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

  void _onImagePicker(ImageSource source, {BuildContext context}) async {
    if (await checkAndRequestCameraPermissions()) {
      _imageFile = await ImagePicker.pickImage(
        source: source,
      );
      newImagePath = null;
      newImageName = null;
      if (_imageFile == null) return;
      final String makedDir =
          (await getExternalStorageDirectory()).path + '/images';
      bool isDirExist = await Directory(makedDir).exists();
      if (!isDirExist) Directory(makedDir).create();
      String imageSort = _imageFile.path.split('/').last;
      String tempPath = makedDir + '/' + imageSort;
      File image = File(tempPath);
      bool isExist = await image.exists();
      if (isExist) await image.delete();
      newImagePath = await _imageFile.copy(tempPath);
      print(newImagePath);
      newImageName = imageSort;
      Navigator.pop(context);
    }
  }

  writeFileInLocal(String fileName,
      {File filePath, Directory dirPath, String dirName}) async {
    final String makedDir = dirPath != null
        ? dirPath.path + dirName != null ? '/' + dirName : '/newFolder'
        : (await getExternalStorageDirectory()).path + dirName != null
            ? '/' + dirName
            : '/newFolder';
    bool isDirExist = await Directory(makedDir).exists();
    if (!isDirExist) Directory(makedDir).create();
    if (filePath == null) {
      String tempPath = makedDir + '/' + fileName;
      File file = File(tempPath);
      bool isExist = await file.exists();
      if (isExist) await file.delete();
      createLocalFile = await file.copy(tempPath);
    } else {
      String tempPath = filePath.toString();
      File file = File(tempPath);
      bool isExist = await file.exists();
      if (isExist) await file.delete();
      createLocalFile = await file.copy(tempPath);
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
                  Text('Image Pick From',
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
                      _onImagePicker(ImageSource.gallery, context: context);
                    },
                    child: const Icon(Icons.photo_library),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _onImagePicker(ImageSource.camera, context: context);
                    },
                    child: const Icon(Icons.camera_alt),
                  )
                ])
              ],
            ),
          );
        });
  }
}
