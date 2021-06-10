import 'package:belmer/app/blocs/belt_search/belt_search_bloc.dart';
import 'package:belmer/app/blocs/belt_search/belt_search_event.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/utils/importer.dart';

class SearchFormBloc extends FormBloc<String, String> {
  // final Property
  final String? userId;
  final List<BeltM>? _beltsM;
  final BeltSearchBloc searchBloc;

  // Property
  final SelectFieldBloc<BeltM, String> beltType = SelectFieldBloc();
  final SelectFieldBloc<EffectModel, String> effectType = SelectFieldBloc();
  final SelectFieldBloc<EffectModel, String> effectValue = SelectFieldBloc();
  final TextFieldBloc<String> memoField = TextFieldBloc();
  final TextFieldBloc<String> locationField = TextFieldBloc();

  SearchFormBloc({
    required this.userId,
    required List<BeltM>? beltsM,
    required this.searchBloc,
  }) : _beltsM = beltsM {
    // 項目定義
    addFieldBlocs(fieldBlocs: [
      beltType,
      effectType,
      effectValue,
      memoField,
      locationField,
    ]);

    // 各種項目が変更された際のイベント定義
    _setFieldEvent();

    // 装備の一覧や効果は動的に制御する
    beltType.updateItems(beltsM);
    _updateAllEffects();
  }

  @override
  void onSubmitting() {
    try {
      searchBloc.add(BeltSearchEventSearch(
        userId: userId,
        beltType: beltType.value?.id,
        effectGroupName: effectType.value?.groupName,
        effectId: effectValue.value?.id,
        memo: memoField.value,
        warehouse: locationField.value,
      ));
      emitSuccess(
        successResponse: "成功しました",
        canSubmitAgain: true,
      );
    } catch (e) {
      emitFailure(failureResponse: "検索時にエラー");
    }
  }

  void _setFieldEvent() {
    // 装備種類
    beltType.onValueChanges(onData: (prev, current) => _updateAllEffects());

    // 効果値1～5
    effectType.onValueChanges(onData: (prev, current) {
      effectValue.updateItems(_getSelectableEffectValues(current.value));
      return Stream.empty();
    });
  }

  Stream<void> _updateAllEffects() {
    List<EffectModel> effects = _getSelectableEffectTypes();
    effectType.updateItems(effects);
    effectValue.updateItems(_getSelectableEffectValues(effectType.value));

    return Stream.empty();
  }

  List<EffectModel> _getSelectableEffectTypes() {
    // 装備が未選択の場合はスルー
    BeltM? selectBelt = beltType.value;
    if (selectBelt == null) {
      return [];
    }

    return _beltsM!
        .where((b) => b.id == selectBelt.id)
        .expand((b) => b.effects)
        .where((e) => e.maxFlag)
        .toList();
  }

  List<EffectModel> _getSelectableEffectValues(EffectModel? selectValue) {
    // 装備が未選択の場合はスルー
    BeltM? selectBelt = beltType.value;
    if (selectBelt == null || selectValue == null) {
      return [];
    }

    // 絞り込んで返却する
    return selectBelt.effects
        .where((effect) => effect.groupName == selectValue.groupName)
        .toList();
  }
}
