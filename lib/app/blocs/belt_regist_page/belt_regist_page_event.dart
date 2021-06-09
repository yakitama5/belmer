import 'package:belmer/app/utils/importer.dart';

@immutable
abstract class BeltRegistPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BeltRegistPageEventInit extends BeltRegistPageEvent {
  final String userId;
  final String beltId;

  BeltRegistPageEventInit({@required this.userId, this.beltId});
}
