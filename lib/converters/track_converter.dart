import 'dart:convert';

import 'package:qrunner/models/track_model.dart';
import 'package:qrunner/models/track_type.dart';

class TrackConverter {

  static Map<String, dynamic> convertToMapFromModel(TrackModel model) {
    Map<String, dynamic> data = {};
    data['id'] = model.id;
    data['name'] = model.name;
    data['trackType'] = model.trackType.name;
    data['numOfPoints'] = model.numOfPoints;
    data['codeList'] = jsonEncode(model.codeList);
    return data;
  }

  static TrackModel convertToModelFromJson(String jsonString) {

    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    var codeList =
    (jsonDecode(data["codeList"]) as List<dynamic>).map((e) => e as String).toList();

    return TrackModel(
      data["id"], data["name"], TrackType.getByName(data["trackType"]),
        data["numOfPoints"], codeList,);
  }
}
