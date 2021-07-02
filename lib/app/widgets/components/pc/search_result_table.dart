import 'package:belmer/app/models/belt_table_model.dart';
import 'package:belmer/app/models/belts.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/pc/belt_table.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class SearchResultTable extends StatelessWidget {
  final List<String> columnTitles;
  final List<BeltRowModel>? beltRowModels;
  final ScrollController horizontalBodyController;
  final ScrollController horizontalTitleController;
  final ScrollController verticalBodyController;
  final ScrollController verticalTitleController;
  final void Function(BeltModel beltModel)? onSelectRow;

  const SearchResultTable({
    Key? key,
    required this.columnTitles,
    this.beltRowModels,
    required this.horizontalBodyController,
    required this.horizontalTitleController,
    required this.verticalBodyController,
    required this.verticalTitleController,
    this.onSelectRow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BeltTable(
      legendCellTitle: "メモ",
      columnTitles: columnTitles,
      rowModels: beltRowModels,
      cellDimensions: CellDimensions.fixed(
          contentCellWidth: 250,
          contentCellHeight: 60,
          stickyLegendWidth: 180,
          stickyLegendHeight: 60),
      height: 600,
      horizontalBodyController: horizontalBodyController,
      horizontalTitleController: horizontalTitleController,
      verticalBodyController: verticalBodyController,
      verticalTitleController: verticalTitleController,
      key: key,
      onSelectRow: onSelectRow,
      showCellBorder: true,
    );
  }
}
