import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrunner/models/track_model.dart';
import 'package:qrunner/models/track_type.dart';

class TrackConverter {
  static TrackModel convertToModel(DocumentSnapshot doc) {
    Timestamp timestamp = doc["dateTime"];

    List<String> codeList =
        (doc["codeList"] as List<dynamic>).map((e) => e as String).toList();

    return TrackModel(
      doc.id,
      doc["name"],
      TrackType.values.byName(doc["trackType"]),
      timestamp.toDate(),
      doc["numOfPoints"],
      codeList,
    );
  }
}
