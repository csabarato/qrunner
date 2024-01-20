import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrunner/converters/track_converter.dart';
import 'package:qrunner/models/track_model.dart';

import '../repository/db_repository.dart';


class TrackService {

  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static DbRepository dbRepository = DbRepository();
  static const String trackDataTable = 'TRACK_DATA';

  static void refreshTracksDataInLocalDb(List<TrackModel> trackModels) async {

    List<Map<String, dynamic>> dataList = [];
    for (var model in trackModels) {
      dataList.add(TrackConverter.convertToMapFromModel(model));
    }
    await dbRepository.refreshTableData(trackDataTable, dataList);
  }

  static Future<List<TrackModel>> loadTracksDataFromLocalDb() async {
    List<Map<String, dynamic>> dataList = await dbRepository.queryTableData(trackDataTable);
    List<TrackModel> trackModels = [];
    for (var data in dataList) {
      trackModels.add(TrackConverter.convertToModelFromMap(data));
    }
    return trackModels;
  }

  static Stream<QuerySnapshot> getTracksQuerySnapshots() {
    return db.collection("tracks").snapshots();
  }

  static Future<void> addUserToCompletedBy(String trackId, String userId) async {
    final trackRef = db.collection("tracks").doc(trackId);
    List<dynamic> listAdd = [userId];
    await trackRef.update({
      'completedBy' : FieldValue.arrayUnion(listAdd)
    });
  }
}