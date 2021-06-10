import 'package:belmer/app/models/belts.dart';

class BeltRowModel {
  BeltRowModel({
    required this.beltModel,
    required this.legendCellValue,
    required this.cells,
  });

  final BeltModel beltModel;
  final String legendCellValue;
  final List<BeltCellModel?> cells;
}

class BeltColumnModel {}

class BeltCellModel {
  BeltCellModel({
    required this.value,
    this.sortKey,
  });

  final String value;
  final int? sortKey;
}
