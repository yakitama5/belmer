import 'package:belmer/app/models/belt_table_model.dart';
import 'package:belmer/app/models/belts.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/models/summary_belt_table_model.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/utils/my_icons.dart';
import 'package:belmer/app/widgets/components/belt_table.dart';
import 'package:belmer/app/widgets/components/my_table_components.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class SummaryTable extends StatelessWidget {
  final List<EffectModel> _columnTitleModels;
  final List<BeltRowModel>? _rowModels;
  final void Function(BeltModel beltModel)? onSelectRow;
  final ScrollControllers? scrollControllers;
  final double? initialScrollOffsetX;
  final double? initialScrollOffsetY;
  final bool showScrollableHint;

  SummaryTable({
    Key? key,
    required List<EffectModel> columnTitleModels,
    List<BeltRowModel>? rowModels,
    this.scrollControllers,
    this.onSelectRow,
    this.initialScrollOffsetX = 0.0,
    this.initialScrollOffsetY = 0.0,
    this.showScrollableHint = false,
  })  : _columnTitleModels = columnTitleModels,
        _rowModels = rowModels,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> columntTitles =
        _columnTitleModels.map((e) => e.groupShortName).toList();

    return _SummaryBeltTable(
      columnTitles: columntTitles,
      rowModels: _rowModels,
      height: 500,
      cellDimensions: CellDimensions.fixed(
          contentCellWidth: 60,
          contentCellHeight: 60,
          stickyLegendWidth: 180,
          stickyLegendHeight: 60),
      scrollControllers: scrollControllers,
      key: key,
      onSelectRow: onSelectRow,
      initialScrollOffsetX: initialScrollOffsetX,
      initialScrollOffsetY: initialScrollOffsetY,
      showScrollableHint: showScrollableHint,
    );
  }
}

class _SummaryBeltTable extends BeltTable {
  static const String LEGEND_CELL_TITLE = "メモ";

  const _SummaryBeltTable({
    Key? key,
    required List<String> columnTitles,
    required List<BeltRowModel>? rowModels,
    required CellDimensions cellDimensions,
    required double height,
    void Function(BeltModel beltModel)? onSelectRow,
    ScrollControllers? scrollControllers,
    double? initialScrollOffsetX,
    double? initialScrollOffsetY,
    bool showScrollableHint = false,
  }) : super(
          key: key,
          legendCellTitle: LEGEND_CELL_TITLE,
          columnTitles: columnTitles,
          rowModels: rowModels,
          cellDimensions: cellDimensions,
          height: height,
          onSelectRow: onSelectRow,
          scrollControllers: scrollControllers,
          initialScrollOffsetX: initialScrollOffsetX,
          initialScrollOffsetY: initialScrollOffsetY,
          showScrollableHint: showScrollableHint,
        );

  @override
  Widget generateContentsCell(int columnIndex, int rowIndex) {
    BeltCellModel? cellModel = rowModels![rowIndex].cells[columnIndex];
    SummaryBeltCellModel? summaryCellModel = cellModel as SummaryBeltCellModel?;

    return MyTableContentsCell(
        child: summaryCellModel != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 最大値の場合のみ、王冠マークを表示
                  summaryCellModel.crownDispFlag
                      ? Icon(
                          MyIcons.crown,
                          color: Colors.yellow,
                        )
                      : Container(),

                  // 値をそのまま表示
                  Text("${summaryCellModel.value}"),
                ],
              )
            : null);
  }
}
