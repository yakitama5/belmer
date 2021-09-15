import 'package:collection/collection.dart';
import 'package:belmer/app/blocs/belt_card/belt_card_event.dart';
import 'package:belmer/app/blocs/belt_card/belt_card_state.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/models/belt_table_model.dart';
import 'package:belmer/app/models/belts.dart';
import 'package:belmer/app/models/summary_belt_table_model.dart';
import 'package:belmer/app/repositories/belts_repository.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/utils/json_utils.dart';

class BeltCardBloc extends Bloc<BeltCardEvent, BeltCardState> {
  final BeltsRepository _repository;

  BeltCardBloc({required BeltsRepository repository})
      : _repository = repository,
        super(BeltCardStatePure());

  @override
  Stream<BeltCardState> mapEventToState(event) async* {
    if (event is BeltCardEventLoad) {
      yield* _load(event);
    }
  }

  Stream<BeltCardState> _load(BeltCardEventLoad event) async* {
    yield BeltCardStateProgress();

    try {
      // ベルトのマスタを取得
      final List<BeltM> beltsM = await JsonUtils.loadAccessoryBeltJson();
      final List<EffectModel> allEffects =
          beltsM.firstWhereOrNull((e) => e.id == event.beltType)?.effects ?? [];

      // ベルト一覧の取得
      final Stream<List<BeltModel>> beltModelsStream = _repository
          .fetchByUserId(event.userId)
          .map((e) => e.where((belt) => belt.type == event.beltType).toList());

      // 効果の一覧からサマリ表示対象のみを抽出する
      final List<EffectModel> columnTitleEffects =
          allEffects.where((e) => e.maxFlag && e.listDispFlag).toList();

      final Stream<List<BeltRowModel>> rowModelsStream =
          toRowModelsStream(allEffects, columnTitleEffects, beltModelsStream);

      yield BeltCardStateSuccess(
        columnTitleModels: columnTitleEffects,
        rowModelsStream: rowModelsStream,
      );
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      yield BeltCardStateFailure();
    }
  }

  Stream<List<BeltRowModel>> toRowModelsStream(
      List<EffectModel> allEffects,
      List<EffectModel> columnTitleEffects,
      Stream<List<BeltModel>> beltModelsStream) {
    // 列毎の効果一覧をMap形式で取得
    final Map<String?, List<EffectModel>> columnTitleMap =
        groupBy(allEffects, (item) => item.kindName);

    // 取得したベルト一覧をテーブル行一覧に変換する
    return beltModelsStream.map((List<BeltModel> belts) {
      return belts.map((belt) {
        // ベルトの効果一覧を設定
        List<String?> beltEffectModels = [
          belt.effect1,
          belt.effect2,
          belt.effect3,
          belt.effect4,
          belt.effect5,
        ];

        List<SummaryBeltCellModel?> cells = columnTitleEffects.map((effect) {
          // カラム内の効果一覧を取得
          List<EffectModel>? columnEffectModels =
              columnTitleMap[effect.kindName];

          EffectModel? effectModel = columnEffectModels
              ?.firstWhereOrNull((e) => beltEffectModels.contains(e.id));

          return effectModel != null
              ? SummaryBeltCellModel(
                  value: effectModel.value,
                  sortKey: effectModel.sortKey,
                  crownDispFlag: effectModel.maxFlag,
                )
              : null;
        }).toList();

        return BeltRowModel(
          beltModel: belt,
          legendCellValue: belt.memo ?? "",
          cells: cells,
        );
      }).toList();
    });
  }
}
