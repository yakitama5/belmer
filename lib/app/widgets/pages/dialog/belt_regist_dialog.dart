import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:belmer/app/blocs/belt_regist_page/belt_regist_page_importer.dart';
import 'package:belmer/app/blocs/form_blocs/belt_save_form_bloc.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/models/login_model.dart';
import 'package:belmer/app/repositories/firebase/belts_firebase_repository.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/utils/my_colors.dart';
import 'package:belmer/app/widgets/components/form_elevated_button.dart';
import 'package:belmer/app/widgets/components/pc/failure_widget.dart';
import 'package:belmer/app/widgets/components/slime_indicator.dart';
import 'package:belmer/app/widgets/pages/dialog/dqx_progress_dialog.dart';
import 'package:belmer/app/widgets/pages/dialog/effect_type_select_dialog.dart';
import 'package:flutter/foundation.dart';

class BeltRegistDialog extends StatelessWidget {
  final String? beltId;
  final void Function()? onUpdated;

  const BeltRegistDialog({Key? key, this.beltId, this.onUpdated})
      : super(key: key);

  static void show(BuildContext context,
      {Key? key, String? beltId, void Function()? onUpdated}) {
    // ダイアログはRoot配下に所属するため、Provider.valueで引き渡し
    // Notes: https://qiita.com/popy1017/items/f4c6f6167dde4aa206ef#%E3%81%A9%E3%81%86%E3%81%99%E3%82%8B%E3%81%8B
    LoginModel loginModel = context.read<LoginModel>();

    AwesomeDialog(
      context: context,
      padding: EdgeInsets.only(
        top: 20,
        left: 10,
        right: 10,
        bottom: 10,
      ),
      useRootNavigator: true,
      borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 2),
      dismissOnTouchOutside: false,
      headerAnimationLoop: false,
      width: 600,
      animType: AnimType.SCALE,
      body: Provider.value(
        value: loginModel,
        child: BeltRegistDialog(
          beltId: beltId,
          onUpdated: onUpdated,
        ),
      ),
      showCloseIcon: true,
      dialogType: DialogType.NO_HEADER,
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    LoginModel loginModel = context.read<LoginModel>();

    return BlocProvider(
      create: (context) =>
          BeltRegistPageBloc(repository: BeltsFirebaseRepository())
            ..add(BeltRegistPageEventInit(
              userId: loginModel.uid,
              beltId: this.beltId,
            )),
      child: Builder(
        builder: (_) => BlocBuilder<BeltRegistPageBloc, BeltRegistPageState>(
          builder: _buildPageState,
        ),
      ),
    );
  }

  Widget _buildPageState(BuildContext context, BeltRegistPageState state) {
    LoginModel loginModel = context.read<LoginModel>();

    if (state is BeltRegistPageStateFailure) {
      return FailureWidget();
    } else if (state is BeltRegistPageStateSuccess) {
      return BlocProvider(
        create: (_) => BeltSaveFormBloc(
          uid: loginModel.uid,
          repository: BeltsFirebaseRepository(),
          beltsM: state.beltM,
          beltId: beltId,
          beltModel: state.beltModel,
        ),
        child: Builder(builder: _builderForm),
      );
    }

    return SlimeIndicator();
  }

  Widget _builderForm(BuildContext context) {
    return FormBlocListener<BeltSaveFormBloc, String, String>(
      onSubmitting: _onSubmitting,
      onDeleting: _onDeleting,
      onSuccess: _onSuccess,
      onFailure: _onFailure,
      child: Column(
        children: [
          _buildInputItems(context),
          _buildFooterItems(context),
        ],
      ),
    );
  }

  Widget _buildInputItems(BuildContext context) {
    BeltSaveFormBloc formBloc = context.read<BeltSaveFormBloc>();

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 500),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MyTextField(
                labelText: "メモ",
                textFieldBloc: formBloc.memoField,
                maxLength: 20,
              ),
              _MyTextField(
                labelText: "倉庫",
                textFieldBloc: formBloc.locationField,
                maxLength: 30,
              ),
              _MyDropDownField(
                labelText: "種類",
                selectFieldBloc: formBloc.beltType,
                itemBuilder: (context, beltM) => beltM.name,
                showEmptyItem: false,
              ),
              _BeltSelectField(
                fieldBloc: formBloc.effect1,
                beltType: formBloc.beltType,
                labelText: "効果1",
              ),
              _BeltSelectField(
                fieldBloc: formBloc.effect2,
                beltType: formBloc.beltType,
                labelText: "効果2",
              ),
              _BeltSelectField(
                fieldBloc: formBloc.effect3,
                beltType: formBloc.beltType,
                labelText: "効果3",
              ),
              _BeltSelectField(
                fieldBloc: formBloc.effect4,
                beltType: formBloc.beltType,
                labelText: "効果4",
              ),
              _BeltSelectField(
                fieldBloc: formBloc.effect5,
                beltType: formBloc.beltType,
                labelText: "効果5",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterItems(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 200),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _CancelButton(),
          // 「削除」ボタンは更新時のみ表示
          if (this.beltId != null) _DeleteButton(),
          _SubmitButton(),
        ],
      ),
    );
  }

  ///
  /// Events
  ///

  void _onSubmitting(context, state) {
    DqxProgressDialog.show(context);
  }

  void _onDeleting(context, state) {
    DqxProgressDialog.show(context);
  }

  void _onSuccess(context, state) {
    DqxProgressDialog.hide(context);
    Navigator.pop(context);
    if (onUpdated != null) {
      onUpdated!();
    }
  }

  void _onFailure(context, state) {
    DqxProgressDialog.hide(context);
  }
}

///
/// Components in the page
///

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormElevatedButton(
      onPressed: () => context.read<BeltSaveFormBloc>().submit(),
      child: Text("保存"),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormElevatedButton(
      onPressed: () => context.read<BeltSaveFormBloc>().delete(),
      child: Text("削除"),
      style: ElevatedButton.styleFrom(
        primary: MyColors.deleteButtonColor,
        onPrimary: Theme.of(context).primaryColor,
      ).merge(Theme.of(context).elevatedButtonTheme.style),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormElevatedButton(
      onPressed: () => Navigator.pop(context),
      child: Text("キャンセル"),
      style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          onPrimary: Theme.of(context).accentColor,
          side: BorderSide(
            color: Theme.of(context).accentColor,
            width: 1,
          )).merge(Theme.of(context).elevatedButtonTheme.style),
    );
  }
}

class _MyDropDownField extends StatelessWidget {
  final SelectFieldBloc selectFieldBloc;
  final bool showEmptyItem;
  final String labelText;
  final String Function(BuildContext context, dynamic obj) itemBuilder;

  const _MyDropDownField({
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

class _BeltSelectField extends StatelessWidget {
  final InputFieldBloc<EffectModel, String> fieldBloc;
  final SelectFieldBloc<BeltM, String> beltType;
  final String labelText;

  const _BeltSelectField({
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
                : EffectTypeSelectDialog.show(
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

class _MyTextField extends StatelessWidget {
  final TextFieldBloc textFieldBloc;
  final String labelText;
  final int maxLength;

  const _MyTextField({
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
