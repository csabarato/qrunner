import 'package:cloud_firestore/cloud_firestore.dart';


class TrackService {

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot> getTracksQuerySnapshots() {
    return db.collection("tracks").snapshots();
  }
}