// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultModel _$ResultModelFromJson(Map<String, dynamic> json) => ResultModel(
      json['userId'] as String,
      json['trackId'] as String,
      (json['resultMap'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), CodeScanData.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ResultModelToJson(ResultModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'trackId': instance.trackId,
      'resultMap': instance.resultMap.map((k, e) => MapEntry(k.toString(), e)),
    };
