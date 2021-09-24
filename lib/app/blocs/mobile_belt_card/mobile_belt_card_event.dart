import 'package:belmer/app/utils/importer.dart';

@immutable
abstract class MobileBeltCardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MobileBeltCardEventLoad extends MobileBeltCardEvent {
  final String? userId;
  final String? beltType;

  MobileBeltCardEventLoad({required this.userId, this.beltType});
}
