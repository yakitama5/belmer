import 'package:belmer/app/models/belts.dart';

class BeltRowModel {
  BeltRowModel({
    this.beltModel,
    this.legendCellValue,
    this.cells,
  });

  final BeltModel beltModel;
  final String legendCellValue;
  final List<BeltCellModel> cells;
}

class BeltColumnModel {}

class BeltCellModel {
  BeltCellModel({
    this.value,
    this.sortKey,
  });

  final String value;
  final int sortKey;
}
