import 'package:belmer/app/blocs/search_page/search_page_event.dart';
import 'package:belmer/app/blocs/search_page/search_page_state.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/utils/json_utils.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchPageState> {
  SearchPageBloc({SearchPageState? initialState})
      : super(initialState ?? SearchPageStatePure());

  @override
  Stream<SearchPageState> mapEventToState(SearchPageEvent event) async* {
    if (event is SearchPageEventInit) {
      yield* _init(event);
    }
  }

  Stream<SearchPageState> _init(SearchPageEventInit event) async* {
    yield SearchPageStateProgress();

    try {
      // JSONファイル(マスタ)内容を読み込む
      List<BeltM> beltM = await JsonUtils.loadAccessoryBeltJson();

      yield SearchPageStateSuccess(beltM: beltM);
    } catch (e) {
      yield SearchPageStateFailure();
    }
  }
}
