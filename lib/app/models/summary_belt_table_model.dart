import 'package:belmer/app/models/belt_table_model.dart';

class SummaryBeltCellModel extends BeltCellModel {
  SummaryBeltCellModel({
    required String value,
    int? sortKey,
    this.crownDispFlag = false,
  }) : super(value: value, sortKey: sortKey);

  final bool crownDispFlag;
}
