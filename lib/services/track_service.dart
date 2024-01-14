import 'package:cloud_firestore/cloud_firestore.dart';


class TrackService {

  static final FirebaseFirestore db = FirebaseFirestore.instance;

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