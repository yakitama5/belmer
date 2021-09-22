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
  final effects = InputFieldBloc<List<EffectModel>, String>();
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
      effects,
      memoField,
      locationField,
    ]);

    // 各種項目が変更された際のイベント定義
    beltType.onValueChanges(onData: (prev, current) {
      if (prev.value != null && prev.value?.id != current.value?.id) {
        effects.updateValue(null);
      }
      return Stream.empty();
    });

    // 装備の一覧や効果は動的に制御する
    beltType.updateItems(beltsM);
  }

  @override
  void onSubmitting() {
    try {
      searchBloc.add(BeltSearchEventSearch(
        userId: userId,
        beltType: beltType.value?.id,
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
}
