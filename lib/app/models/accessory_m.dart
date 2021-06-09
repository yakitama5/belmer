import 'package:json_annotation/json_annotation.dart';
part 'accessory_m.g.dart';

@JsonSerializable()
class EffectModel {
  EffectModel({
    this.id,
    this.groupName,
    this.groupShortName,
    this.name,
    this.value,
    this.maxFlag,
    this.listDispFlag,
  });

  String id;
  String groupName;
  String groupShortName;
  String name;
  String value;
  int sortKey;
  bool maxFlag;
  bool listDispFlag;

  factory EffectModel.fromJson(Map<String, dynamic> json) =>
      _$EffectModelFromJson(json);

  Map<String, dynamic> toJson() => _$EffectModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BeltM {
  String id;
  String name;
  List<EffectModel> effects = [];

  BeltM(this.id, this.name, this.effects);

  factory BeltM.fromJson(Map<String, dynamic> json) => _$BeltMFromJson(json);

  Map<String, dynamic> toJson() => _$BeltMToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AccessoryM {
  List<BeltM> belts = [];
  AccessoryM(this.belts);

  factory AccessoryM.fromJson(Map<String, dynamic> json) =>
      _$AccessoryMFromJson(json);

  Map<String, dynamic> toJson() => _$AccessoryMToJson(this);
}
