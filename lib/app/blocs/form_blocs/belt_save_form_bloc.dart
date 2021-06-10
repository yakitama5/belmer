import 'package:belmer/app/models/belts.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/repositories/belts_repository.dart';
import 'package:belmer/app/utils/importer.dart';

class BeltSaveFormBloc extends FormBloc<String, String> {
  // final Property
  final String _uid;
  final String _beltId;
  final BeltsRepository _repository;

  // Property
  final memoField = TextFieldBloc();
  final locationField = TextFieldBloc();
  final SelectFieldBloc<BeltM, String> beltType =
      SelectFieldBloc(validators: [FieldBlocValidators.required]);
  final SelectFieldBloc<EffectModel, String> effectType1 =
      SelectFieldBloc(validators: [FieldBlocValidators.required]);
  final SelectFieldBloc<EffectModel, String> effectValue1 =
      SelectFieldBloc(validators: [FieldBlocValidators.required]);
  final SelectFieldBloc<EffectModel, String> effectType2 = SelectFieldBloc();
  final SelectFieldBloc<EffectModel, String> effectValue2 = SelectFieldBloc();
  final SelectFieldBloc<EffectModel, String> effectType3 = SelectFieldBloc();
  final SelectFieldBloc<EffectModel, String> effectValue3 = SelectFieldBloc();
  final SelectFieldBloc<EffectModel, String> effectType4 = SelectFieldBloc();
  final SelectFieldBloc<EffectModel, String> effectValue4 = SelectFieldBloc();
  final SelectFieldBloc<EffectModel, String> effectType5 = SelectFieldBloc();
  final SelectFieldBloc<EffectModel, String> effectValue5 = SelectFieldBloc();

  // Validator
  Validator<EffectModel> _duplicateEffectType(
      List<SelectFieldBloc> effectList) {
    return (EffectModel effectModel) {
      // 全ての効果一覧の中でから自身の効果種類の件数を取得
      final count = effectList
          .where((e) =>
              e.value != null && effectModel?.groupName == e?.value?.groupName)
          .length;

      if (count >= 1) {
        return "同じ種類の効果は入力出来ません";
      }

      return null;
    };
  }

  // Constructor
  BeltSaveFormBloc(
      {String uid,
      String beltId,
      @required BeltsRepository repository,
      @required List<BeltM> beltsM,
      BeltModel beltModel})
      : _uid = uid,
        _beltId = beltId,
        _repository = repository {
    // 項目定義
    addFieldBlocs(fieldBlocs: [
      memoField,
      locationField,
      beltType,
      effectType1,
      effectValue1,
      effectType2,
      effectValue2,
      effectType3,
      effectValue3,
      effectType4,
      effectValue4,
      effectType5,
      effectValue5,
    ]);

    // 各種項目が変更された際のイベント定義
    _setFieldEvent();

    // 装備の一覧や効果は動的に制御する
    beltType.updateItems(beltsM);
    _updateAllEffects();

    // 初期値の設定
    _setInitialValue(beltModel, beltsM);

    // カスタム入力チェック
    _setCustomValidator();
  }

  void _setInitialValue(BeltModel beltModel, List<BeltM> beltsM) {
    if (beltModel == null) {
      return;
    }

    // 装備種類
    final BeltM initBeltType =
        beltsM.firstWhere((e) => e.id == beltModel?.type, orElse: () => null);
    if (initBeltType != null) {
      beltType.updateInitialValue(initBeltType);
    }

    // メモ
    memoField.updateInitialValue(beltModel.memo);

    // 保管場所
    locationField.updateInitialValue(beltModel.location);

    // 装備効果
    // TODO: 後から成形(Reflection?)
    EffectModel initEffectModel = initBeltType.effects
        .firstWhere((e) => e.id == beltModel.effect1, orElse: () => null);
    EffectModel typeEffectModel;
    if (initEffectModel != null) {
      typeEffectModel = initBeltType.effects.firstWhere(
          (e) => e.groupName == initEffectModel.groupName && e.maxFlag,
          orElse: () => null);
      effectType1.updateInitialValue(typeEffectModel);
      effectValue1.updateInitialValue(initEffectModel);
    }
    initEffectModel = initBeltType.effects
        .firstWhere((e) => e.id == beltModel.effect2, orElse: () => null);
    if (initEffectModel != null) {
      typeEffectModel = initBeltType.effects.firstWhere(
          (e) => e.groupName == initEffectModel.groupName && e.maxFlag,
          orElse: () => null);
      effectType2.updateInitialValue(typeEffectModel);
      effectValue2.updateInitialValue(initEffectModel);
    }
    initEffectModel = initBeltType.effects
        .firstWhere((e) => e.id == beltModel.effect3, orElse: () => null);
    if (initEffectModel != null) {
      typeEffectModel = initBeltType.effects.firstWhere(
          (e) => e.groupName == initEffectModel.groupName && e.maxFlag,
          orElse: () => null);
      effectType3.updateInitialValue(typeEffectModel);
      effectValue3.updateInitialValue(initEffectModel);
    }
    initEffectModel = initBeltType.effects
        .firstWhere((e) => e.id == beltModel.effect4, orElse: () => null);
    if (initEffectModel != null) {
      typeEffectModel = initBeltType.effects.firstWhere(
          (e) => e.groupName == initEffectModel.groupName && e.maxFlag,
          orElse: () => null);
      effectType4.updateInitialValue(typeEffectModel);
      effectValue4.updateInitialValue(initEffectModel);
    }
    initEffectModel = initBeltType.effects
        .firstWhere((e) => e.id == beltModel.effect5, orElse: () => null);
    if (initEffectModel != null) {
      typeEffectModel = initBeltType.effects.firstWhere(
          (e) => e.groupName == initEffectModel.groupName && e.maxFlag,
          orElse: () => null);
      effectType5.updateInitialValue(typeEffectModel);
      effectValue5.updateInitialValue(initEffectModel);
    }
  }

  void _setCustomValidator() {
    // TODO 整形したい
    effectType1.addValidators([
      _duplicateEffectType([
        effectType2,
        effectType3,
        effectType4,
        effectType5,
      ])
    ]);
    effectType2.addValidators([
      _duplicateEffectType([
        effectType1,
        effectType3,
        effectType4,
        effectType5,
      ])
    ]);
    effectType3.addValidators([
      _duplicateEffectType([
        effectType1,
        effectType2,
        effectType4,
        effectType5,
      ])
    ]);
    effectType4.addValidators([
      _duplicateEffectType([
        effectType1,
        effectType2,
        effectType3,
        effectType5,
      ])
    ]);
    effectType5.addValidators([
      _duplicateEffectType([
        effectType1,
        effectType2,
        effectType3,
        effectType4,
      ])
    ]);
  }

  void _setFieldEvent() {
    // 装備種類
    beltType.onValueChanges(onData: (prev, current) => _updateAllEffects());

    // 効果値1～5
    effectType1.onValueChanges(onData: (prev, current) {
      effectValue1.updateItems(_getSelectableEffectValues(current.value));
      return Stream.empty();
    });
    effectType2.onValueChanges(onData: (prev, current) {
      effectValue2.updateItems(_getSelectableEffectValues(current.value));
      return Stream.empty();
    });
    effectType3.onValueChanges(onData: (prev, current) {
      effectValue3.updateItems(_getSelectableEffectValues(current.value));
      return Stream.empty();
    });
    effectType4.onValueChanges(onData: (prev, current) {
      effectValue4.updateItems(_getSelectableEffectValues(current.value));
      return Stream.empty();
    });
    effectType5.onValueChanges(onData: (prev, current) {
      effectValue5.updateItems(_getSelectableEffectValues(current.value));
      return Stream.empty();
    });
  }

  Stream<void> _updateAllEffects() {
    // 効果種類1～5
    List<EffectModel> effectType = _getSelectableEffectTypes();
    effectType1.updateItems(effectType);
    effectType2.updateItems(effectType);
    effectType3.updateItems(effectType);
    effectType4.updateItems(effectType);
    effectType5.updateItems(effectType);

    // 効果値1～5
    effectValue1.updateItems(_getSelectableEffectValues(effectType1.value));
    effectValue2.updateItems(_getSelectableEffectValues(effectType2.value));
    effectValue3.updateItems(_getSelectableEffectValues(effectType3.value));
    effectValue4.updateItems(_getSelectableEffectValues(effectType4.value));
    effectValue5.updateItems(_getSelectableEffectValues(effectType5.value));

    return Stream.empty();
  }

  @override
  void onSubmitting() async {
    try {
      // パラメタ設定
      BeltModel belt = BeltModel(
        id: _beltId,
        memo: memoField?.value,
        location: locationField?.value,
        type: beltType?.value?.id,
        effect1: effectValue1?.value?.id,
        effect2: effectValue2?.value?.id,
        effect3: effectValue3?.value?.id,
        effect4: effectValue4?.value?.id,
        effect5: effectValue5?.value?.id,
      );

      // 保存
      await _repository.save(_uid, belt);
      emitSuccess(successResponse: "保存しました");
    } catch (e) {
      emitFailure(failureResponse: "保存に失敗しました");
    }
  }

  @override
  void onDeleting() async {
    try {
      if (_beltId == null) {
        throw Exception();
      }

      await _repository.delete(_uid, _beltId);
      emitSuccess(successResponse: "削除しました");
    } catch (e) {
      emitFailure(failureResponse: "削除に失敗しました");
    }
  }

  List<EffectModel> _getSelectableEffectTypes() {
    // 装備が未選択の場合はスルー
    BeltM selectBelt = beltType.value;
    if (selectBelt == null) {
      return [];
    }

    // 各選択肢種類で一つずつ表示する
    return selectBelt.effects.where((effect) => effect.maxFlag).toList();
  }

  List<EffectModel> _getSelectableEffectValues(EffectModel selectValue) {
    // 装備が未選択の場合はスルー
    BeltM selectBelt = beltType.value;
    if (selectBelt == null || selectValue == null) {
      return [];
    }

    // 絞り込んで返却する
    return selectBelt.effects
        .where((effect) => effect.groupName == selectValue.groupName)
        .toList();
  }
}
