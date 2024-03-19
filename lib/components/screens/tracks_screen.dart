
import 'package:flutter/material.dart';
import 'package:qrunner/components/cards/track_card.dart';
import 'package:qrunner/components/screens/read_codes_screen.dart';
import 'package:qrunner/constants/strings.dart';
import 'package:qrunner/models/track_model.dart';
import 'package:qrunner/models/track_type.dart';

class TracksScreen extends StatefulWidget {
  const TracksScreen({Key? key}) : super(key: key);

  static const String id = 'tracks_screen';

  @override
  State<TracksScreen> createState() => _TracksScreenState();
}

class _TracksScreenState extends State<TracksScreen> {
  List<TrackModel> tracks = [];

  @override
  void initState() {
    super.initState();
    tracks = createTrackModels();
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
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                    return buildTrackCard(index);
                  }),
          ),
        ],
      ),
    );
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
              trackName: model.name,
              trackType: model.trackType,
              numOfPoints: model.numOfPoints,
              codeList: model.codeList);
        }));
      },
    );
  }

  List<TrackModel> createTrackModels() {
    List<TrackModel> tracks = [];
    final testTrack = TrackModel('test_track', 'Teszt pálya', TrackType.pointCollecting, 5,
        ["k7jRe", "Zx9F2", "p3oQv", "gHs4d", "Xt6Yw"]);

    final pointCollectingTrack = TrackModel('point_collecting', 'Pontbegyűjtő pálya', TrackType.pointCollecting, 20,
        ["pT5yN", "bQ9fZ", "mV3sD", "xR7wP", "jK2gL", "zH6tW", "cE1aM", "oU4iX", "rS8hB", "dI0cQ", "wO7nY", "tG4vJ", "lF9uZ", "qA3eR", "vM5kP", "gX1oT", "sD6zL", "nB2jK", "iY8rQ", "fJ0pW"]
    );

    final fixOrderTrack = TrackModel('fix_order', 'Kötött sorrendű pálya', TrackType.fixedOrderCollecting, 20,
        ["r7vKp", "m3yNq", "s2lOt", "t4fPu", "n8xGw", "v6aHz", "u5qLe", "j9dCi", "g0bMr", "i1cYs", "q3wJt", "o4hXu", "l2eFv", "h7rZw", "p6mSa", "f8kXt", "w9nYv", "c5pHx", "e0tUy", "a3oLz"]
    );

    tracks.add(testTrack);
    tracks.add(pointCollectingTrack);
    tracks.add(fixOrderTrack);
    return tracks;
  }
}
