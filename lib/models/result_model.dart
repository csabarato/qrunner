
import 'code_scan_data.dart';

class ResultModel {

  String trackId;
  Map<int, CodeScanData> resultMap;

  ResultModel(this.trackId, this.resultMap);
}
