import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qrunner/components/cards/track_card.dart';
import 'package:qrunner/components/screens/read_codes_list_screen.dart';
import 'package:qrunner/constants/strings.dart';
import 'package:qrunner/converters/track_converter.dart';
import 'package:qrunner/models/track_model.dart';
import 'package:qrunner/services/track_service.dart';
import 'package:qrunner/utils/dialog_utils.dart';
import 'package:qrunner/utils/progress_indicators.dart';

class TracksScreen extends StatefulWidget {
  const TracksScreen({Key? key}) : super(key: key);

  static const String id = 'tracks_screen';

  @override
  State<TracksScreen> createState() => _TracksScreenState();
}

class _TracksScreenState extends State<TracksScreen> {

  List<TrackModel> tracks = [];
  late StreamSubscription<QuerySnapshot> tracksSubscription;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    subscribeToTracksStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kTracksScreenTitle),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: isLoading ? 1 : tracks.length,
            itemBuilder: (context, index) {
                if (isLoading) {
                  showLoadingIndicator('Loading...');
                  return const SizedBox();
                } else {
                  return buildTrackCard(index);
                }
            }),
      ),
    );
  }

  subscribeToTracksStream() {
    try {
      Stream<QuerySnapshot> tracksStream =  TrackService.getTracksQuerySnapshots();

      tracksSubscription = tracksStream.listen((event) {
        tracks = event.docs.map((e) => TrackConverter.convertToModel(e)).toList();
        EasyLoading.dismiss();
        isLoading = false;
        setState(() {});
      });
    } catch(e) {
      showErrorDialog(context, e.toString());
    }
  }

  TrackCard buildTrackCard(int index) {

    TrackModel model = tracks[index];

    return TrackCard(trackModel: tracks[index], onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return ReadCodesListScreen(trackType: model.trackType, numOfPoints: model.numOfPoints, codeList: model.codeList);
      }));
    },);
  }

  @override
  void dispose() {
    super.dispose();
    tracksSubscription.cancel();
  }
}