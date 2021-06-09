import 'package:belmer/app/utils/importer.dart';

@immutable
abstract class PageViewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PageViewEventHome extends PageViewEvent {}

class PageViewEventSearch extends PageViewEvent {}

class PageViewEventTest extends PageViewEvent {}
