import 'dart:async';
import 'package:flutter_share/flutter_share.dart';

class SocialShare {
  Future<void> share(String shareType,
      {String link, String filePath, String title, String text}) async {
    if (shareType == 'link')
      await FlutterShare.share(title: title, text: text, linkUrl: link);
    if (shareType == 'file')
      await FlutterShare.shareFile(
          title: title, text: text, filePath: filePath);
  }
}