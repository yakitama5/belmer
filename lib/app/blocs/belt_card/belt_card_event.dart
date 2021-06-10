import 'package:belmer/app/utils/importer.dart';

@immutable
abstract class BeltCardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BeltCardEventLoad extends BeltCardEvent {
  final String? userId;
  final String? beltType;

  BeltCardEventLoad({required this.userId, this.beltType});
}
