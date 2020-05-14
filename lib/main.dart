import 'package:building/src/videopicker/video_player.dart';
import 'package:flutter/material.dart';
import './src/social_login.dart';
import './src/social_share.dart';
import './src/videopicker/video_picker.dart';
import './src/image_picker.dart';
import './src/database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: buildWidget(),
    );
  }

  Widget buildWidget() {
    return Center(child: Text('Welcome'));
  }
}
