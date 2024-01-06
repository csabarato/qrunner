import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrunner/models/code_scan_data.dart';
import 'package:qrunner/models/result_model.dart';

import '../repository/db_repository.dart';

class ResultService {

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static late DbRepository dbRepository;

  ResultService() {
    dbRepository = DbRepository();
  }

  static Future<void> saveResult(ResultModel model) async {
    await db.collection("results").add(model.toJson());
  }

  static void saveCodeScanToLocalDb(String userId, String trackId, String code,
      int index, DateTime timestamp) async {
    dbRepository = DbRepository();
    Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['trackId'] = trackId;
    data['pointIndex'] = index;
    data['code'] = code;
    data['scanTimestamp'] = timestamp.toIso8601String();

    await dbRepository.insertData('CODE_SCAN_DATA', data);
  }

  static Future<Map<int, CodeScanData>> readScannedCodes(String trackId) async {
    dbRepository = DbRepository();
    Map<int, CodeScanData> barcodeMap = {};
    List<Map<String, Object?>> scannedCodes = await dbRepository.readDataScannedCodesByTrackId(trackId);
    for(Map<String,Object?> scannedCode in scannedCodes) {
      print('scanned code:');
      print(scannedCode.toString());
      int pointIndex = scannedCode['pointIndex'] as int;
      String codeText = scannedCode['code'] as String;
      String scanTimestamp = scannedCode['scanTimestamp'] as String;
      CodeScanData codeScanData = CodeScanData(codeText, DateTime.parse(scanTimestamp));
      barcodeMap[pointIndex] = codeScanData;
    }
    return barcodeMap;
  }
}