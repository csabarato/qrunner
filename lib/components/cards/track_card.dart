import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrunner/constants/strings.dart';

import '../../models/track_model.dart';

class TrackCard extends StatelessWidget {
  final TrackModel trackModel;
  final VoidCallback onTap;

  const TrackCard({Key? key, required this.trackModel, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          elevation: 05.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.blueGrey,
              width: 3.0
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trackModel.name,
                    style: GoogleFonts.lexendDeca(
                      color: Colors.black,
                      fontSize: 18.0,
                    )),
                const SizedBox(
                  width: 15.0,
                ),
                const Divider(
                  thickness: 2.0,
                  color: Colors.blueGrey,
                ),
                const SizedBox(
                  height: 6.0,
                ),
                Text(
                  kTrackType + trackModel.trackType.name,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(
                  height: 6.0,
                ),
                const SizedBox(
                  height: 6.0,
                ),
                Text('$kNumOfPoints ${trackModel.numOfPoints}',
                    style: const TextStyle(fontSize: 16.0)),
              ],
            ),
          )),
    );
  }
}
