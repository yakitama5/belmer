import 'package:belmer/app/blocs/sort/sort_event.dart';
import 'package:belmer/app/blocs/sort/sort_state.dart';
import 'package:belmer/app/utils/importer.dart';

class SortBloc extends Bloc<SortEvent, SortState> {
  SortBloc({SortState initialState}) : super(initialState ?? SortStatePure());

  @override
  Stream<SortState> mapEventToState(SortEvent event) async* {
    if (event is SortEventSort) {
      bool isReverse = false;
      if (this.state is SortStateSorted) {
        SortStateSorted sortedState = this.state;
        isReverse = sortedState.columnIndex == event.columnIndex &&
            !sortedState.isReverse;
      }

      yield SortStateSorted(
          columnIndex: event.columnIndex, isReverse: isReverse);
    }
  }
}
