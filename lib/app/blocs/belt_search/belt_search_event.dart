import 'package:belmer/app/utils/importer.dart';

class BeltSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BeltSearchEventSearch extends BeltSearchEvent {
  final String? userId;
  final String? beltType;
  final String? effectGroupName;
  final String? effectId;
  final String? memo;
  final String? warehouse;

  BeltSearchEventSearch({
    required this.userId,
    this.beltType,
    this.effectGroupName,
    this.effectId,
    this.memo,
    this.warehouse,
  });
}
