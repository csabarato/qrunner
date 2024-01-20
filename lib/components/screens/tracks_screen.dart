import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qrunner/components/buttons/rounded_button.dart';
import 'package:qrunner/components/cards/track_card.dart';
import 'package:qrunner/components/screens/home_screen.dart';
import 'package:qrunner/components/screens/read_codes_screen.dart';
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
  ConnectivityResult connectivityResult = ConnectivityResult.none;

  StreamSubscription? connectivityChangedSubscription;
  late StreamSubscription<QuerySnapshot> tracksSubscription;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Connectivity().checkConnectivity().
        then((result) {
          if (result != ConnectivityResult.wifi || result != ConnectivityResult.mobile) {
            handleNoInternetConnection();
          }
        });

    connectivityChangedSubscription =
        Connectivity().onConnectivityChanged.listen((result) {
          onConnectivityChanged(result);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kTracksScreenTitle),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
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
          RoundedButton(
              text: 'Logout',
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, HomeScreen.id);
              })
        ],
      ),
    );
  }

  onConnectivityChanged(ConnectivityResult result) {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      subscribeToTracksStream();
    } else {
      handleNoInternetConnection();
    }
  }

  subscribeToTracksStream() {
    try {
      Stream<QuerySnapshot> tracksStream =
          TrackService.getTracksQuerySnapshots();

      tracksSubscription = tracksStream.listen((event) {
        tracks =
            event.docs.map((e) => TrackConverter.convertToModel(e)).toList();
        TrackService.refreshTracksDataInLocalDb(tracks);
        EasyLoading.dismiss();
        isLoading = false;
        setState(() {});
      });
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  handleNoInternetConnection() {
    TrackService.loadTracksDataFromLocalDb()
        .then<void>((tracksData) {
      tracks = tracksData;
      EasyLoading.dismiss();
      isLoading = false;
    })
        .catchError((e, stackTrace) {
      EasyLoading.dismiss();
      isLoading = false;
      print(stackTrace);
      showErrorDialog(context, kLoadTracksFailed);
    });
  }

  TrackCard buildTrackCard(int index) {
    TrackModel model = tracks[index];

    return TrackCard(
      trackModel: tracks[index],
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ReadCodesScreen(
              trackId: model.id,
              trackType: model.trackType,
              numOfPoints: model.numOfPoints,
              codeList: model.codeList,
              currentUser: FirebaseAuth.instance.currentUser);
        }));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    tracksSubscription.cancel();
    if (connectivityChangedSubscription != null) connectivityChangedSubscription!.cancel();
  }
}
