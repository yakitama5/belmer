// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'belts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeltModel _$BeltModelFromJson(Map<String, dynamic> json) {
  return BeltModel(
    id: json['id'] as String,
    type: json['type'] as String,
    memo: json['memo'] as String,
    location: json['location'] as String,
    effect1: json['effect1'] as String,
    effect2: json['effect2'] as String,
    effect3: json['effect3'] as String,
    effect4: json['effect4'] as String,
    effect5: json['effect5'] as String,
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
    };

Belts _$BeltsFromJson(Map<String, dynamic> json) {
  return Belts(
    (json['belts'] as List)
        ?.map((e) =>
            e == null ? null : BeltModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BeltsToJson(Belts instance) => <String, dynamic>{
      'belts': instance.belts?.map((e) => e?.toJson())?.toList(),
    };
