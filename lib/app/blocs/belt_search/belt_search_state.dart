import 'package:belmer/app/models/belt_table_model.dart';
import 'package:belmer/app/utils/importer.dart';

class BeltSearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BeltSearchStatePure extends BeltSearchState {}

class BeltSearchStateProgress extends BeltSearchState {}

class BeltSearchStateSuccess extends BeltSearchState {
  final List<BeltRowModel>? beltRowModels;
  final List<String> columnTitles;

  BeltSearchStateSuccess({this.beltRowModels, required this.columnTitles});

  @override
  List<Object?> get props => [this.beltRowModels, this.columnTitles];
}

class BeltSearchStateFailure extends BeltSearchState {}
