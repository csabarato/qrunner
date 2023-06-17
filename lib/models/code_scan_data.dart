
import 'package:json_annotation/json_annotation.dart';

part 'code_scan_data.g.dart';

@JsonSerializable()
class CodeScanData {
  String code;
  DateTime scanTimestamp;

  CodeScanData(this.code, this.scanTimestamp);

  factory CodeScanData.fromJson(Map<String, dynamic> json) => _$CodeScanDataFromJson(json);
}