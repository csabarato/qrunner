// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_scan_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeScanData _$CodeScanDataFromJson(Map<String, dynamic> json) => CodeScanData(
      json['code'] as String,
      DateTime.parse(json['scanTimestamp'] as String),
    );

Map<String, dynamic> _$CodeScanDataToJson(CodeScanData instance) =>
    <String, dynamic>{
      'code': instance.code,
      'scanTimestamp': instance.scanTimestamp.toIso8601String(),
    };
