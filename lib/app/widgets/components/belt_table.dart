import 'package:belmer/app/blocs/sort/sort_bloc.dart';
import 'package:belmer/app/blocs/sort/sort_event.dart';
import 'package:belmer/app/blocs/sort/sort_state.dart';
import 'package:belmer/app/models/belt_table_model.dart';
import 'package:belmer/app/models/belts.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/my_table_components.dart';
import 'package:belmer/app/widgets/components/scrollable_hint_container.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class BeltTable extends StatelessWidget {
  final String? legendCellTitle;
  final List<String> columnTitles;
  final List<BeltRowModel>? rowModels;
  final CellDimensions cellDimensions;
  final double height;
  final void Function(BeltModel beltModel)? onSelectRow;
  final ScrollControllers? scrollControllers;
  final double? initialScrollOffsetX;
  final double? initialScrollOffsetY;
  final bool showCellBorder;
  final bool showScrollableHint;

  const BeltTable({
    Key? key,
    this.legendCellTitle,
    required this.columnTitles,
    required this.rowModels,
    required this.cellDimensions,
    required this.height,
    this.onSelectRow,
    this.scrollControllers,
    this.initialScrollOffsetX,
    this.initialScrollOffsetY,
    this.showCellBorder = false,
    this.showScrollableHint = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SortBloc>(
      create: (_) => SortBloc(),
      child: Builder(
        builder: (context) =>
            BlocBuilder<SortBloc, SortState>(builder: (context, state) {
          // リストのソート
          int? sortColumnIndex;
          bool? isReverse;
          if (state is SortStateSorted) {
            sortColumnIndex = state.columnIndex;
            isReverse = state.isReverse;

            rowModels?.sort((a, b) {
              int sortKeyA = a.cells[sortColumnIndex!]?.sortKey ?? -1;
              int sortKeyB = b.cells[sortColumnIndex]?.sortKey ?? -1;

              String valueA = a.cells[sortColumnIndex]?.value ?? "";
              String valueB = b.cells[sortColumnIndex]?.value ?? "";

              int compareResult = isReverse!
                  ? sortKeyA.compareTo(sortKeyB)
                  : sortKeyB.compareTo(sortKeyA);

              compareResult = compareResult == 0
                  ? state.isReverse
                      ? valueA.compareTo(valueB)
                      : valueB.compareTo(valueA)
                  : compareResult;

              return compareResult;
            });
          }

          return Container(
            height: height,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: ScrollableHintContainer(
              showScrollableHint: showScrollableHint,
              child: StickyHeadersTable(
                key: key,
                // スクロール制御
                scrollControllers: scrollControllers,
                initialScrollOffsetX: initialScrollOffsetX ?? 0.0,
                initialScrollOffsetY: initialScrollOffsetY ?? 0.0,

                // テーブルスタイル設定
                columnsLength: columnTitles.length,
                rowsLength: rowModels?.length ?? 0,
                cellDimensions: cellDimensions,

                // 各セル生成
                legendCell: generetedLegendCell(),
                columnsTitleBuilder: (columnIndex) => generetedColumnsTitle(
                    columnIndex, sortColumnIndex, isReverse),
                rowsTitleBuilder: generatedRowsTitle,
                contentCellBuilder: generateContentsCell,

                // イベント定義
                onRowTitlePressed: (rowIndex) =>
                    _onRowTitlePressed(context, rowIndex, rowModels!),
                onColumnTitlePressed: (columnIndex) =>
                    _onColumnTitlePressed(context, columnIndex),
              ),
            ),
          );
        }),
      ),
    );
  }

  ///
  /// Event-------------------
  ///

  _onRowTitlePressed(
      BuildContext context, int rowIndex, List<BeltRowModel> rows) {
    // 押下されたベルトの取得
    BeltModel beltModel = rows[rowIndex].beltModel;

    // 呼び出し元の処理を実行する
    if (onSelectRow != null) {
      onSelectRow!(beltModel);
    }
  }

  _onColumnTitlePressed(BuildContext context, int columnIndex) {
    // ソートを行う
    context.read<SortBloc>().add(SortEventSort(columnIndex: columnIndex));
  }

  ///
  /// Builder-------------------
  ///

  Widget generetedLegendCell() {
    return MyTableHeaderCell(
      child: Text("$legendCellTitle"),
      showCellBorder: showCellBorder,
    );
  }

  Widget generetedColumnsTitle(
      int columnIndex, int? sortColumnIndex, bool? isReverse) {
    Widget sortIcon = columnIndex == sortColumnIndex
        ? Icon(
            (isReverse ?? false) ? Icons.arrow_drop_down : Icons.arrow_drop_up,
          )
        : Container();

    return MyTableHeaderCell(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(columnTitles[columnIndex]),
          sortIcon,
        ],
      ),
      showCellBorder: showCellBorder,
    );
  }

  Widget generatedRowsTitle(int rowIndex) {
    return MyTableLegendCell(
      child: Text(
        "${rowModels![rowIndex].legendCellValue}",
        style: TextStyle(decoration: TextDecoration.underline),
        softWrap: true,
        overflow: TextOverflow.clip,
      ),
      showCellBorder: showCellBorder,
    );
  }

  Widget generateContentsCell(int columnIndex, int rowIndex) {
    BeltCellModel? cellModel = rowModels![rowIndex].cells[columnIndex];

    return MyTableContentsCell(
      child:
          cellModel != null ? Center(child: Text("${cellModel.value}")) : null,
      showCellBorder: showCellBorder,
    );
  }
}
