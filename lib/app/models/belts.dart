import 'package:cloud_firestore/cloud_firestore.dart';
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
    this.createdAt,
  });

  String? id;
  String? type;
  String? memo;
  String? location;
  String? effect1;
  String? effect2;
  String? effect3;
  String? effect4;
  String? effect5;
  DateTime? createdAt;

  factory BeltModel.fromJson(Map<String, dynamic> json) =>
      _$BeltModelFromJson(json);

  Map<String, dynamic> toJson() => _$BeltModelToJson(this);
}
