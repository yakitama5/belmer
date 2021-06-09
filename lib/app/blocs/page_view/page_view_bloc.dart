import 'package:belmer/app/blocs/page_view/page_view_event.dart';
import 'package:belmer/app/blocs/page_view/page_view_state.dart';
import 'package:belmer/app/utils/importer.dart';

class PageViewBloc extends Bloc<PageViewEvent, PageViewState> {
  PageViewBloc() : super(PageViewStatePure());

  @override
  Stream<PageViewState> mapEventToState(event) async* {
    if (event is PageViewEventHome) {
      yield* _home(event);
    } else if (event is PageViewEventSearch) {
      yield* _search(event);
    } else if (event is PageViewEventTest) {
      yield* _test(event);
    }
  }

  Stream<PageViewState> _home(PageViewEventHome event) async* {
    if (this.state is! PageViewStateHome) {
      yield PageViewStateProgress();
      await Future.delayed(Duration(milliseconds: 500));

      yield PageViewStateHome();
    }
  }

  Stream<PageViewState> _search(PageViewEventSearch event) async* {
    if (this.state is! PageViewStateSearch) {
      yield PageViewStateProgress();
      await Future.delayed(Duration(milliseconds: 500));

      yield PageViewStateSearch();
    }
  }

  Stream<PageViewState> _test(PageViewEventTest event) async* {
    if (this.state is! PageViewStateTest) {
      yield PageViewStateProgress();
      await Future.delayed(Duration(milliseconds: 500));

      yield PageViewStateTest();
    }
  }
}
