import 'package:belmer/app/blocs/belt_search/belt_search_event.dart';
import 'package:belmer/app/blocs/belt_search/belt_search_state.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/models/belt_table_model.dart';
import 'package:belmer/app/models/belts.dart';
import 'package:belmer/app/repositories/belts_repository.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:collection/collection.dart' show IterableExtension;

class BeltSearchBloc extends Bloc<BeltSearchEvent, BeltSearchState> {
  final BeltsRepository _repository;
  final List<BeltM> _beltM;
  static const List<String> COLUMN_TITLES = [
    "装備",
    "効果1",
    "効果2",
    "効果3",
    "効果4",
    "効果5",
    "倉庫"
  ];

  BeltSearchBloc(
      {BeltSearchState? initialState,
      required BeltsRepository repository,
      required List<BeltM> beltM})
      : _repository = repository,
        _beltM = beltM,
        super(initialState ?? BeltSearchStatePure());

  @override
  Stream<BeltSearchState> mapEventToState(BeltSearchEvent event) async* {
    if (event is BeltSearchEventSearch) {
      yield* _search(event);
    }
  }

  Stream<BeltSearchState> _search(BeltSearchEventSearch event) async* {
    yield BeltSearchStateProgress();

    try {
      // 検索
      List<BeltModel> beltModels = await select(event);

      // 変換
      List<BeltRowModel> beltRowModels = toBeltRowModels(beltModels);

      yield BeltSearchStateSuccess(
        beltRowModels: beltRowModels,
        columnTitles: COLUMN_TITLES,
      );
    } catch (e) {
      yield BeltSearchStateFailure();
    }
  }

  Future<List<BeltModel>> select(BeltSearchEventSearch event) async {
    List<BeltModel> beltModels = await _repository.selectByUserId(event.userId);

    List<String?> effectIds = [];
    if (event.effectId != null) {
      effectIds.add(event.effectId);
    } else if (event.effectGroupName != null) {
      effectIds.addAll(_beltM
          .expand((b) => b.effects)
          .where((e) => e.kindName == event.effectGroupName)
          .map((e) => e.id)
          .toList());
    }

    return beltModels.where((belt) {
      // 検索条件毎に判定を行う
      // ベルト種類
      bool isBeltTypeMatch =
          event.beltType == null || event.beltType == belt.type;

      // 効果種類・効果値
      List<String?> beltEffects = [
        belt.effect1,
        belt.effect2,
        belt.effect3,
        belt.effect4,
        belt.effect5,
      ];
      bool isEffectMatch =
          effectIds.isEmpty || beltEffects.any((e) => effectIds.contains(e));

      // メモ
      bool isMemoMatch = event.memo == null || belt.memo!.contains(event.memo!);

      // 倉庫
      bool isWarehouseMatch =
          event.warehouse == null || belt.location!.contains(event.warehouse!);

      return isBeltTypeMatch &&
          isEffectMatch &&
          isMemoMatch &&
          isWarehouseMatch;
    }).toList();
  }

  List<BeltRowModel> toBeltRowModels(List<BeltModel> beltModels) {
    return beltModels.map((belt) {
      List<BeltCellModel> cells = COLUMN_TITLES.mapIndexed((index, item) {
        String value = "";
        switch (index) {
          case 0:
            value = toBeltTypeName(belt.type);
            break;
          case 1:
            value = toEffectName(belt.effect1);
            break;
          case 2:
            value = toEffectName(belt.effect2);
            break;
          case 3:
            value = toEffectName(belt.effect3);
            break;
          case 4:
            value = toEffectName(belt.effect4);
            break;
          case 5:
            value = toEffectName(belt.effect5);
            break;
          case 6:
            value = belt.location ?? "";
            break;
          default:
        }

        return BeltCellModel(
          value: value,
          sortKey: null,
        );
      }).toList();

      return BeltRowModel(
        beltModel: belt,
        legendCellValue: belt.memo ?? "",
        cells: cells,
      );
    }).toList();
  }

  String toEffectName(String? effectId) {
    if (effectId == null) {
      return "";
    }

    return _beltM
            .expand((beltM) => beltM.effects)
            .firstWhereOrNull((effect) => effect.id == effectId)
            ?.name ??
        "";
  }

  String toBeltTypeName(String? beltId) {
    if (beltId == null) {
      return "";
    }

    return _beltM.firstWhereOrNull((beltM) => beltM.id == beltId)?.name ?? "";
  }
}
