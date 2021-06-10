import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/models/belts.dart';
import 'package:belmer/app/utils/importer.dart';

@immutable
abstract class BeltRegistPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class BeltRegistPageStatePure extends BeltRegistPageState {}

class BeltRegistPageStateSuccess extends BeltRegistPageState {
  final List<BeltM> beltM;
  final BeltModel? beltModel;

  BeltRegistPageStateSuccess({required this.beltM, this.beltModel});
}

class BeltRegistPageStateProgress extends BeltRegistPageState {}

class BeltRegistPageStateFailure extends BeltRegistPageState {}
