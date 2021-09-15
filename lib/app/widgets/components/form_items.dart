import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/pages/dialog/effect_select_dialog.dart';

///
/// 共通：ボタン
///
class FormElevatedButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final ButtonStyle? style;

  const FormElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: style,
      ),
    );
  }
}

///
/// 効果選択
///
class EffectSelectFormField extends StatelessWidget {
  final InputFieldBloc<EffectModel, String> fieldBloc;
  final SelectFieldBloc<BeltM, String> beltType;
  final String labelText;

  const EffectSelectFormField({
    Key? key,
    required this.fieldBloc,
    required this.beltType,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputFieldBloc<EffectModel, String>,
        InputFieldBlocState<EffectModel, String>>(
      bloc: fieldBloc,
      builder: (context, state) {
        // TODO 必須エラー時のエラーメッセージをここで設定しないといけない

        return Container(
          child: InkWell(
            child: TextField(
              controller: TextEditingController(text: state.value?.name),
              enabled: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_tree_rounded),
                labelText: labelText,
                labelStyle: Theme.of(context).textTheme.headline3,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                errorText: state.error,
                errorStyle: TextStyle(color: Theme.of(context).errorColor),
              ),
            ),
            onTap: () => beltType.value == null
                ? null
                : EffectSelectDialog.show(
                    context,
                    beltM: beltType.value,
                    onSelect: (e) => fieldBloc.updateValue(e),
                    selectedEffect: fieldBloc.value,
                  ),
          ),
        );
      },
    );
  }
}

///
/// ドロップダウン - 下線
///
class UnderlineDropDownFormField extends StatelessWidget {
  final SelectFieldBloc selectFieldBloc;
  final bool showEmptyItem;
  final String labelText;
  final String Function(BuildContext context, dynamic obj) itemBuilder;

  const UnderlineDropDownFormField({
    Key? key,
    required this.selectFieldBloc,
    this.showEmptyItem = true,
    required this.labelText,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownFieldBlocBuilder(
      selectFieldBloc: selectFieldBloc,
      itemBuilder: itemBuilder,
      showEmptyItem: showEmptyItem,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.headline3,
      ),
    );
  }
}

///
/// テキストボックス - 下線
///
class UnderlineTextFormField extends StatelessWidget {
  final TextFieldBloc textFieldBloc;
  final String labelText;
  final int maxLength;

  const UnderlineTextFormField({
    Key? key,
    required this.textFieldBloc,
    required this.labelText,
    required this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldBlocBuilder(
      textFieldBloc: textFieldBloc,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.headline3,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      cursorColor: Theme.of(context).accentColor,
      buildCounter: (BuildContext context,
              {int? currentLength, int? maxLength, required bool isFocused}) =>
          isFocused
              ? Text(
                  '$currentLength/$maxLength ',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                )
              : null,
    );
  }
}
