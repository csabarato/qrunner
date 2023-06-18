import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrunner/models/result_model.dart';

class ResultService {

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> saveResult(ResultModel model) async {
    await db.collection("results").add(model.toJson());
  }
}