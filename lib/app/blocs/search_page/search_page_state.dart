import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/utils/importer.dart';

class SearchPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchPageStatePure extends SearchPageState {}

class SearchPageStateProgress extends SearchPageState {}

class SearchPageStateSuccess extends SearchPageState {
  final List<BeltM> beltM;

  SearchPageStateSuccess({this.beltM});
}

class SearchPageStateFailure extends SearchPageState {}
