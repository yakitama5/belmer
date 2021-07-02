import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/models/mobile_belt_table_model.dart';
import 'package:belmer/app/utils/importer.dart';

@immutable
abstract class MobileBeltCardState extends Equatable {
  @override
  List<Object> get props => [];
}

class MobileBeltCardStatePure extends MobileBeltCardState {}

class MobileBeltCardStateSuccess extends MobileBeltCardState {
  final List<EffectModel> columnTitleModels;
  final Stream<List<MobileBeltCardEffectModel>> rowModelsStream;

  MobileBeltCardStateSuccess({
    required this.columnTitleModels,
    required this.rowModelsStream,
  });
}

class MobileBeltCardStateProgress extends MobileBeltCardState {}

class MobileBeltCardStateFailure extends MobileBeltCardState {}
