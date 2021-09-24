import 'package:belmer/app/blocs/belt_search/belt_search_bloc.dart';
import 'package:belmer/app/blocs/belt_search/belt_search_event.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/utils/importer.dart';

class SearchFormBloc extends FormBloc<String, String> {
  // final Property
  final String? userId;
  final BeltSearchBloc searchBloc;

  // Property
  final SelectFieldBloc<BeltM, String> beltField = SelectFieldBloc();
  final effectsField = InputFieldBloc<List<EffectModel>, String>();
  final TextFieldBloc<String> memoField = TextFieldBloc();
  final TextFieldBloc<String> locationField = TextFieldBloc();

  SearchFormBloc({
    required this.userId,
    required List<BeltM>? beltsM,
    required this.searchBloc,
  }) {
    // 項目定義
    addFieldBlocs(fieldBlocs: [
      beltField,
      effectsField,
      memoField,
      locationField,
    ]);

    // 各種項目が変更された際のイベント定義
    beltField.onValueChanges(onData: (prev, current) {
      if (prev.value != null && prev.value?.id != current.value?.id) {
        effectsField.updateValue(null);
      }
      return Stream.empty();
    });

    // 装備の一覧や効果は動的に制御する
    beltField.updateItems(beltsM);
  }

  @override
  void onSubmitting() {
    try {
      searchBloc.add(BeltSearchEventSearch(
        userId: userId,
        beltType: beltField.value?.id,
        effectIds: effectsField.value?.map((e) => e.id).toList(),
        memo: memoField.value,
        warehouse: locationField.value,
      ));
      emitSuccess(
        successResponse: "",
        canSubmitAgain: true,
      );
    } catch (e) {
      emitFailure(failureResponse: "検索時にエラー");
    }
  }
}
