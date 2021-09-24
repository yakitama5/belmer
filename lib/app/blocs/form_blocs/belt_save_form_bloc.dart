import 'package:belmer/app/models/belts.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/repositories/belts_repository.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:collection/collection.dart' show IterableExtension;

class BeltSaveFormBloc extends FormBloc<String, String> {
  // final Property
  final String _uid;
  final String? _beltId;
  final BeltsRepository _repository;
  final DateTime? _createdAt;

  // Property
  final memoField = TextFieldBloc();
  final locationField = TextFieldBloc();
  final SelectFieldBloc<BeltM, String> beltType =
      SelectFieldBloc(validators: [FieldBlocValidators.required]);
  final effect1 = InputFieldBloc<EffectModel, String>(
      validators: [FieldBlocValidators.required]);
  final effect2 = InputFieldBloc<EffectModel, String>();
  final effect3 = InputFieldBloc<EffectModel, String>();
  final effect4 = InputFieldBloc<EffectModel, String>();
  final effect5 = InputFieldBloc<EffectModel, String>();

  // Validator
  Validator<EffectModel> _duplicateEffectType(List<InputFieldBloc> effectList) {
    return (EffectModel? effectModel) {
      // 全ての効果一覧の中でから自身の効果種類の件数を取得
      final count = effectList
          .where((e) =>
              e.value != null && effectModel?.kindName == e.value.kindName)
          .length;

      if (count >= 1) {
        return "同じ種類の効果は入力出来ません";
      }

      return null;
    };
  }

  // Constructor
  BeltSaveFormBloc(
      {required String uid,
      String? beltId,
      required BeltsRepository repository,
      required List<BeltM> beltsM,
      BeltModel? beltModel})
      : _uid = uid,
        _beltId = beltId,
        _repository = repository,
        _createdAt = beltModel?.createdAt {
    // 項目定義
    addFieldBlocs(fieldBlocs: [
      memoField,
      locationField,
      beltType,
      effect1,
      effect2,
      effect3,
      effect4,
      effect5,
    ]);

    // 装備種類が変更された場合、効果1~5をリセットする
    beltType.onValueChanges(onData: (prev, current) {
      if (prev.value != null && prev.value?.id != current.value?.id) {
        effect1.updateValue(null);
        effect2.updateValue(null);
        effect3.updateValue(null);
        effect4.updateValue(null);
        effect5.updateValue(null);
      }
      return Stream.empty();
    });

    // 装備一覧を設定
    beltType.updateItems(beltsM);

    // 初期値の設定
    _setInitialValue(beltModel, beltsM);

    // カスタム入力チェック
    _setCustomValidator();
  }

  void _setInitialValue(BeltModel? beltModel, List<BeltM> beltsM) {
    if (beltModel == null) {
      return;
    }

    // 装備種類
    final BeltM? beltM = beltsM.firstWhereOrNull((e) => e.id == beltModel.type);
    beltType.updateInitialValue(beltM);

    // メモ
    memoField.updateInitialValue(beltModel.memo);

    // 保管場所
    locationField.updateInitialValue(beltModel.location);

    // 装備効果
    effect1.updateInitialValue(_getEffectModelById(beltM, beltModel.effect1));
    effect2.updateInitialValue(_getEffectModelById(beltM, beltModel.effect2));
    effect3.updateInitialValue(_getEffectModelById(beltM, beltModel.effect3));
    effect4.updateInitialValue(_getEffectModelById(beltM, beltModel.effect4));
    effect5.updateInitialValue(_getEffectModelById(beltM, beltModel.effect5));
  }

  void _setCustomValidator() {
    // TODO 整形したい
    effect1.addValidators([
      _duplicateEffectType([effect2, effect3, effect4, effect5])
    ]);
    effect2.addValidators([
      _duplicateEffectType([effect1, effect3, effect4, effect5])
    ]);
    effect3.addValidators([
      _duplicateEffectType([effect1, effect2, effect4, effect5])
    ]);
    effect4.addValidators([
      _duplicateEffectType([effect1, effect2, effect3, effect5])
    ]);
    effect5.addValidators([
      _duplicateEffectType([effect1, effect2, effect3, effect4])
    ]);
  }

  @override
  void onSubmitting() async {
    try {
      // パラメタ設定
      BeltModel belt = BeltModel(
        id: _beltId,
        memo: memoField.value,
        location: locationField.value,
        type: beltType.value?.id,
        effect1: effect1.value?.id,
        effect2: effect2.value?.id,
        effect3: effect3.value?.id,
        effect4: effect4.value?.id,
        effect5: effect5.value?.id,
        createdAt: _createdAt,
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

  EffectModel? _getEffectModelById(BeltM? beltM, String? effectId) {
    if (beltM == null || effectId == null) {
      return null;
    }

    return beltM.effects.firstWhereOrNull((element) => element.id == effectId);
  }
}
