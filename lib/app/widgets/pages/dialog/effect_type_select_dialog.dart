import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:supercharged/supercharged.dart';

class EffectTypeSelectDialog extends StatelessWidget {
  final BeltM? _beltM;
  final EffectModel? _selectedEffect;
  final void Function(EffectModel effectModel)? _onSelect;

  const EffectTypeSelectDialog({
    Key? key,
    BeltM? beltM,
    void Function(EffectModel effectModel)? onSelect,
    EffectModel? selectedEffect,
  })  : _beltM = beltM,
        _onSelect = onSelect,
        _selectedEffect = selectedEffect,
        super(key: key);

  void _handleSelect(BuildContext context, EffectModel effectModel) {
    hide(context);
    if (_onSelect != null) {
      _onSelect!(effectModel);
    }
  }

  static void show(
    BuildContext context, {
    BeltM? beltM,
    void Function(EffectModel effectModel)? onSelect,
    EffectModel? selectedEffect,
  }) {
    AwesomeDialog(
      context: context,
      padding: EdgeInsets.only(
        top: 20,
        left: 30,
        right: 30,
        bottom: 50,
      ),
      useRootNavigator: true,
      borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 2),
      dismissOnTouchOutside: true,
      dialogBackgroundColor: Theme.of(context).backgroundColor,
      headerAnimationLoop: false,
      width: 700,
      animType: AnimType.SCALE,
      body: EffectTypeSelectDialog(
        beltM: beltM,
        onSelect: onSelect,
        selectedEffect: selectedEffect,
      ),
      showCloseIcon: true,
      dialogType: DialogType.NO_HEADER,
    )..show();
  }

  static void hide(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, List<EffectModel>>>? effectsMap = _beltM?.effects
        .groupListsBy((element) => element.groupName)
        .entries
        .map((e) => MapEntry<String, Map<String, List<EffectModel>>>(
            e.key, e.value.groupBy((element) => element.kindName)))
        .toMap();

    final Color? collapasedColor = Theme.of(context).textTheme.headline3?.color;

    if (effectsMap == null) {
      return Container();
    }

    // TODO レイアウトを変更する
    // TODO 選択されている場合は、その選択肢の位置までスクロールする仕組みを作る
    return Container(
      height: 600,
      child: SingleChildScrollView(
        child: Column(
          children: effectsMap.entries
              .map(
                (groupEntry) => Container(
                  child: ExpansionTile(
                    title: Text(groupEntry.key),
                    initiallyExpanded:
                        _selectedEffect?.groupName == groupEntry.key,
                    collapsedTextColor: collapasedColor,
                    collapsedIconColor: collapasedColor,
                    children: groupEntry.value.entries
                        .map(
                          (kindEntry) => Container(
                            padding: EdgeInsets.only(left: 10),
                            child: ExpansionTile(
                              title: Text(kindEntry.key),
                              initiallyExpanded:
                                  _selectedEffect?.kindName == kindEntry.key,
                              collapsedTextColor: collapasedColor,
                              collapsedIconColor: collapasedColor,
                              children: kindEntry.value
                                  .map(
                                    (effect) => Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: ListTile(
                                        title: Text(effect.value),
                                        leading: Icon(Icons.add),
                                        onTap: () =>
                                            _handleSelect(context, effect),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
