import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrunner/constants/strings.dart';
import 'package:qrunner/utils/date_format_utils.dart';

import '../../models/track_model.dart';

class TrackCard extends StatelessWidget {
  final TrackModel trackModel;
  final VoidCallback onTap;

  const TrackCard({Key? key, required this.trackModel, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCompletedByUser() ? null : onTap,
      child: Card(
          elevation: 05.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(trackModel.name,
                        style: GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontSize: 18.0,
                        )),
                    const SizedBox(width: 15.0,),
                    if (isCompletedByUser()) Text(kTrackDone, style:
                      GoogleFonts.lexendDeca(color: Colors.green, fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
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
                Text(
                    kDateTime +
                        DateFormatUtils.getDateTime(trackModel.dateTime),
                    style: const TextStyle(fontSize: 16.0)),
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

  bool isCompletedByUser() {
    return trackModel.completedBy.contains(FirebaseAuth.instance.currentUser!.uid);
  }
}
