import 'package:json_annotation/json_annotation.dart';

import 'code_scan_data.dart';
part 'result_model.g.dart';

@JsonSerializable()
class ResultModel {

  String userId;
  String trackId;

  @JsonKey(toJson: resultMapToJson)
  Map<int, CodeScanData> resultMap;

  ResultModel(this.userId, this.trackId, this.resultMap);

  Map<String, dynamic> toJson() => _$ResultModelToJson(this);
}

Map<String, dynamic> resultMapToJson(Map<int, CodeScanData> resultMap) {
    return resultMap.map((key, value) => MapEntry(key.toString(),value.toJson()));
}