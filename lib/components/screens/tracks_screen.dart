import 'package:flutter/material.dart';

class TracksScreen extends StatefulWidget {
  const TracksScreen({Key? key}) : super(key: key);

  static const String id = 'tracks_screen';

  @override
  State<TracksScreen> createState() => _TracksScreenState();
}

class _TracksScreenState extends State<TracksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pályák'),
      ),
    );
  }
}