import 'package:belmer/app/models/belt_table_model.dart';

class SummaryBeltCellModel extends BeltCellModel {
  SummaryBeltCellModel({String value, int sortKey, this.crownDispFlag})
      : super(value: value, sortKey: sortKey);

  final bool crownDispFlag;
}
