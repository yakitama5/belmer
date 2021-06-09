import 'package:json_annotation/json_annotation.dart';
part 'belts.g.dart';

@JsonSerializable()
class BeltModel {
  BeltModel({
    this.id,
    this.type,
    this.memo,
    this.location,
    this.effect1,
    this.effect2,
    this.effect3,
    this.effect4,
    this.effect5,
  });

  String id;
  String type;
  String memo;
  String location;
  String effect1;
  String effect2;
  String effect3;
  String effect4;
  String effect5;

  factory BeltModel.fromJson(Map<String, dynamic> json) =>
      _$BeltModelFromJson(json);

  Map<String, dynamic> toJson() => _$BeltModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Belts {
  List<BeltModel> belts = [];
  Belts(this.belts);

  factory Belts.fromJson(Map<String, dynamic> json) => _$BeltsFromJson(json);

  Map<String, dynamic> toJson() => _$BeltsToJson(this);
}
