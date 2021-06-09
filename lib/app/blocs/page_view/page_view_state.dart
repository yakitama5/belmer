import 'package:belmer/app/utils/importer.dart';

@immutable
abstract class PageViewState extends Equatable {
  @override
  List<Object> get props => [];
}

class PageViewStatePure extends PageViewState {}

class PageViewStateProgress extends PageViewState {}

class PageViewStateHome extends PageViewState {}

class PageViewStateSearch extends PageViewState {}

class PageViewStateTest extends PageViewState {}
