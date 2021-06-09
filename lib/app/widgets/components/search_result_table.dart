import 'package:belmer/app/models/belt_table_model.dart';
import 'package:belmer/app/models/belts.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/belt_table.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class SearchResultTable extends StatelessWidget {
  final List<String> columnTitles;
  final List<BeltRowModel> beltRowModels;
  final ScrollControllers scrollControllers;
  final void Function(BeltModel beltModel) onSelectRow;
  final double initialScrollOffsetX;
  final double initialScrollOffsetY;

  const SearchResultTable({
    Key key,
    this.columnTitles,
    this.beltRowModels,
    this.scrollControllers,
    this.onSelectRow,
    this.initialScrollOffsetX,
    this.initialScrollOffsetY,
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
      scrollControllers: scrollControllers,
      key: key,
      onSelectRow: onSelectRow,
      initialScrollOffsetX: initialScrollOffsetX,
      initialScrollOffsetY: initialScrollOffsetY,
      showCellBorder: true,
    );
  }
}
