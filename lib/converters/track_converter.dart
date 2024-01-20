import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrunner/models/track_model.dart';
import 'package:qrunner/models/track_type.dart';

class TrackConverter {
  static TrackModel convertToModel(DocumentSnapshot doc) {
    Timestamp timestamp = doc["dateTime"];

    List<String> codeList =
        (doc["codeList"] as List<dynamic>).map((e) => e as String).toList();

    List<String> completedByUsersList =
    (doc["completedBy"] as List<dynamic>).map((e) => e as String).toList();

    return TrackModel(
      doc.id,
      doc["name"],
      TrackType.values.byName(doc["trackType"]),
      timestamp.toDate(),
      doc["numOfPoints"],
      codeList,
      completedByUsersList,
    );
  }

  static Map<String, dynamic> convertToMapFromModel(TrackModel model) {
    Map<String, dynamic> data = {};
    data['id'] = model.id;
    data['name'] = model.name;
    data['trackType'] = model.trackType.name;
    data['dateTime'] = model.dateTime.toIso8601String();
    data['numOfPoints'] = model.numOfPoints;
    data['codeList'] = jsonEncode(model.codeList);
    data['completedBy'] = jsonEncode(model.completedBy);
    return data;
  }

  static TrackModel convertToModelFromMap(Map<String, dynamic> data) {

    var codeList =
    (jsonDecode(data["codeList"]) as List<dynamic>).map((e) => e as String).toList();
    var completedByList =
    (jsonDecode(data["completedBy"]) as List<dynamic>).map((e) => e as String).toList() ;

    return TrackModel(
      data["id"], data["name"], TrackType.getByName(data["trackType"]),DateTime.parse(data["dateTime"]),
        data["numOfPoints"], codeList, completedByList);
  }
}
