import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/models/belt_table_model.dart';
import 'package:belmer/app/utils/importer.dart';

@immutable
abstract class BeltCardState extends Equatable {
  @override
  List<Object> get props => [];
}

class BeltCardStatePure extends BeltCardState {}

class BeltCardStateSuccess extends BeltCardState {
  final List<EffectModel> columnTitleModels;
  final Stream<List<BeltRowModel>> rowModelsStream;

  BeltCardStateSuccess({this.columnTitleModels, this.rowModelsStream});
}

class BeltCardStateProgress extends BeltCardState {}

class BeltCardStateFailure extends BeltCardState {}
