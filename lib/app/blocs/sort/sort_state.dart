import 'package:belmer/app/utils/importer.dart';

class SortState extends Equatable {
  @override
  List<Object> get props => [];
}

class SortStatePure extends SortState {}

class SortStateSorted extends SortState {
  final int columnIndex;
  final bool isReverse;

  SortStateSorted({this.columnIndex, this.isReverse});

  @override
  List<Object> get props => [columnIndex, isReverse];
}
