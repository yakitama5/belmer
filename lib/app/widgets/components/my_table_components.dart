import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/utils/my_colors.dart';
import 'package:flutter/rendering.dart';

class MyTableHeaderCell extends StatelessWidget {
  const MyTableHeaderCell({
    Key? key,
    this.child,
    this.showCellBorder = false,
  }) : super(key: key);

  final Widget? child;
  final bool showCellBorder;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: MyTableCell(
        color: Theme.of(context).buttonColor,
        child: child,
        showCellBorder: showCellBorder,
      ),
    );
  }
}

class MyTableLegendCell extends StatelessWidget {
  const MyTableLegendCell({
    Key? key,
    this.child,
    this.showCellBorder = false,
  }) : super(key: key);

  final Widget? child;
  final bool showCellBorder;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: MyTableContentsCell(
        showCellBorder: showCellBorder,
        child: child,
      ),
    );
  }
}

class MyTableContentsCell extends StatelessWidget {
  const MyTableContentsCell({
    Key? key,
    this.child,
    this.showCellBorder = false,
  }) : super(key: key);

  final Widget? child;
  final bool showCellBorder;

  @override
  Widget build(BuildContext context) {
    return MyTableCell(
      color: MyColors.secondryWhiteColor,
      child: child,
      showCellBorder: showCellBorder,
    );
  }
}

class MyTableCell extends StatelessWidget {
  const MyTableCell({
    Key? key,
    this.child,
    this.showCellBorder = false,
    required this.color,
  }) : super(key: key);

  final bool showCellBorder;
  final Widget? child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: color,
        border: showCellBorder
            ? Border.all(
                style: BorderStyle.solid,
                color: Theme.of(context).dividerColor,
                width: 1,
              )
            : null,
      ),
      child: Center(
        child: child ?? Container(),
      ),
    );
  }
}
