import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/models/belts.dart';
import 'package:belmer/app/repositories/belts_repository.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/utils/json_utils.dart';

import 'belt_regist_page_event.dart';
import 'belt_regist_page_state.dart';

class BeltRegistPageBloc
    extends Bloc<BeltRegistPageEvent, BeltRegistPageState> {
  final BeltsRepository _repository;

  BeltRegistPageBloc({BeltsRepository repository})
      : assert(repository != null),
        _repository = repository,
        super(BeltRegistPageStatePure());

  @override
  Stream<BeltRegistPageState> mapEventToState(event) async* {
    if (event is BeltRegistPageEventInit) {
      yield* _init(event);
    }
  }

  Stream<BeltRegistPageState> _init(BeltRegistPageEventInit event) async* {
    yield BeltRegistPageStateProgress();

    try {
      // JSONファイル(マスタ)内容を読み込む
      List<BeltM> beltM = await JsonUtils.loadAccessoryBeltJson();

      // ベルトの取得
      BeltModel beltModel;
      if (event.beltId != null) {
        beltModel = await _repository.selectById(event.userId, event.beltId);
      }

      yield BeltRegistPageStateSuccess(
        beltM: beltM,
        beltModel: beltModel,
      );
    } catch (e) {
      yield BeltRegistPageStateFailure();
    }
  }
}
