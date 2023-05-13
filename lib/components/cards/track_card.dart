import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrunner/constants/strings.dart';
import 'package:qrunner/utils/date_format_utils.dart';

import '../../models/track_model.dart';

class TrackCard extends StatelessWidget {
  final TrackModel trackModel;

  const TrackCard({Key? key, required this.trackModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
              Text(trackModel.name,
                  style: GoogleFonts.lexendDeca(
                    color: Colors.black,
                    fontSize: 18.0,
                  )),
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
              Text(kDateTime + DateFormatUtils.getDateTime(trackModel.dateTime),
                  style: const TextStyle(fontSize: 16.0)),
              const SizedBox(
                height: 6.0,
              ),
              Text('$kNumOfPoints ${trackModel.numOfPoints}',
                  style: const TextStyle(fontSize: 16.0)),
            ],
          ),
        ));
  }
}
