import 'package:qrunner/models/code_scan_data.dart';

import '../repository/db_repository.dart';

class ResultService {

  static late DbRepository dbRepository;

  ResultService() {
    dbRepository = DbRepository();
  }

  static void saveCodeScanToLocalDb(String trackId, String code,
      int index, DateTime timestamp) async {
    dbRepository = DbRepository();
    Map<String, dynamic> data = {};
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
      int pointIndex = scannedCode['pointIndex'] as int;
      String codeText = scannedCode['code'] as String;
      String scanTimestamp = scannedCode['scanTimestamp'] as String;
      CodeScanData codeScanData = CodeScanData(codeText, DateTime.parse(scanTimestamp));
      barcodeMap[pointIndex] = codeScanData;
    }
    return barcodeMap;
  }

  static Future<int> deleteCodeScanData() async {
    dbRepository = DbRepository();
    return dbRepository.deleteData('CODE_SCAN_DATA');
  }
}