import 'package:belmer/app/utils/importer.dart';

class SortEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SortEventSort extends SortEvent {
  final int columnIndex;

  SortEventSort({this.columnIndex});
}
