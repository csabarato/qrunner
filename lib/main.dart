import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qrunner/components/screens/tracks_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Qrunner App',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        builder: EasyLoading.init(),
        home: const TracksScreen());
  }
}
