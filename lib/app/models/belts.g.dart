// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'belts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeltModel _$BeltModelFromJson(Map<String, dynamic> json) {
  return BeltModel(
    id: json['id'] as String?,
    type: json['type'] as String?,
    memo: json['memo'] as String?,
    location: json['location'] as String?,
    effect1: json['effect1'] as String?,
    effect2: json['effect2'] as String?,
    effect3: json['effect3'] as String?,
    effect4: json['effect4'] as String?,
    effect5: json['effect5'] as String?,
    createdAt: json['createdAt'] == null
        ? null
        : (json['createdAt'] as Timestamp).toDate(),
  );
}

Map<String, dynamic> _$BeltModelToJson(BeltModel instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'memo': instance.memo,
      'location': instance.location,
      'effect1': instance.effect1,
      'effect2': instance.effect2,
      'effect3': instance.effect3,
      'effect4': instance.effect4,
      'effect5': instance.effect5,
      'createdAt': instance.createdAt == null
          ? null
          : Timestamp.fromDate(instance.createdAt!),
    };
