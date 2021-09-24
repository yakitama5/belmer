import 'package:belmer/app/blocs/mobile_belt_card/mobile_belt_card_event.dart';
import 'package:belmer/app/blocs/mobile_belt_card/mobile_belt_card_state.dart';
import 'package:belmer/app/models/mobile_belt_table_model.dart';
import 'package:collection/collection.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/models/belt_table_model.dart';
import 'package:belmer/app/models/belts.dart';
import 'package:belmer/app/models/summary_belt_table_model.dart';
import 'package:belmer/app/repositories/belts_repository.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/utils/json_utils.dart';

class MobileBeltCardBloc
    extends Bloc<MobileBeltCardEvent, MobileBeltCardState> {
  final BeltsRepository _repository;

  MobileBeltCardBloc({required BeltsRepository repository})
      : _repository = repository,
        super(MobileBeltCardStatePure());

  @override
  Stream<MobileBeltCardState> mapEventToState(event) async* {
    if (event is MobileBeltCardEventLoad) {
      yield* _load(event);
    }
  }

  Stream<MobileBeltCardState> _load(MobileBeltCardEventLoad event) async* {
    yield MobileBeltCardStateProgress();

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

      // TODO: モバイル用のRow,Columnに変換する
      final Stream<List<MobileBeltCardEffectModel>> rowModelsStream =
          Stream.value(List.empty());

      yield MobileBeltCardStateSuccess(
        columnTitleModels: columnTitleEffects,
        rowModelsStream: rowModelsStream,
      );
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      yield MobileBeltCardStateFailure();
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
