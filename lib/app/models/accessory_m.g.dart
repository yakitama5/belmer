// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accessory_m.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EffectModel _$EffectModelFromJson(Map<String, dynamic> json) {
  return EffectModel(
    id: json['id'] as String,
    groupName: json['groupName'] as String,
    kindName: json['kindName'] as String,
    kindShortName: json['kindShortName'] as String,
    name: json['name'] as String,
    value: json['value'] as String,
    sortKey: json['sortKey'] as int,
    maxFlag: json['maxFlag'] as bool,
    listDispFlag: json['listDispFlag'] as bool,
  );
}

Map<String, dynamic> _$EffectModelToJson(EffectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupName': instance.groupName,
      'kindName': instance.kindName,
      'kindShortName': instance.kindShortName,
      'name': instance.name,
      'value': instance.value,
      'sortKey': instance.sortKey,
      'maxFlag': instance.maxFlag,
      'listDispFlag': instance.listDispFlag,
    };

BeltM _$BeltMFromJson(Map<String, dynamic> json) {
  return BeltM(
    json['id'] as String,
    json['name'] as String,
    (json['effects'] as List<dynamic>)
        .map((e) => EffectModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$BeltMToJson(BeltM instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'effects': instance.effects.map((e) => e.toJson()).toList(),
    };

AccessoryM _$AccessoryMFromJson(Map<String, dynamic> json) {
  return AccessoryM(
    (json['belts'] as List<dynamic>)
        .map((e) => BeltM.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$AccessoryMToJson(AccessoryM instance) =>
    <String, dynamic>{
      'belts': instance.belts.map((e) => e.toJson()).toList(),
    };
