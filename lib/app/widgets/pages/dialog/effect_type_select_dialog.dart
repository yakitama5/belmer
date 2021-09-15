import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:supercharged/supercharged.dart';

class EffectTypeSelectDialog extends StatefulWidget {
  final BeltM? _beltM;
  final EffectModel? _selectedEffect;
  final void Function(EffectModel effectModel)? _onSelect;

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

  const EffectTypeSelectDialog({
    Key? key,
    BeltM? beltM,
    void Function(EffectModel effectModel)? onSelect,
    EffectModel? selectedEffect,
  })  : _beltM = beltM,
        _onSelect = onSelect,
        _selectedEffect = selectedEffect,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _Widget();
}

class _Widget extends State<EffectTypeSelectDialog> {
  final _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // 既に選択済の効果が存在する場合は、表示箇所までスクロール
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      BuildContext? context = _globalKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(context);
      }
    });
  }

  void _handleSelect(BuildContext context, EffectModel effectModel) {
    hide(context);
    if (widget._onSelect != null) {
      widget._onSelect!(effectModel);
    }
  }

  static void hide(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, List<EffectModel>>>? effectsMap = widget
        ._beltM?.effects
        .groupListsBy((element) => element.groupName)
        .entries
        .map((e) => MapEntry<String, Map<String, List<EffectModel>>>(
            e.key, e.value.groupBy((element) => element.kindName)))
        .toMap();

    final Color? collapasedColor = Theme.of(context).textTheme.headline3?.color;

    if (effectsMap == null) {
      return Container();
    }

    // TODO レイアウトを変更する？
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
                        widget._selectedEffect?.groupName == groupEntry.key,
                    collapsedTextColor: collapasedColor,
                    collapsedIconColor: collapasedColor,
                    children: groupEntry.value.entries.map(
                      (kindEntry) {
                        bool isSelectedKind =
                            widget._selectedEffect?.kindName == kindEntry.key;

                        return Container(
                          padding: EdgeInsets.only(left: 10),
                          child: ExpansionTile(
                            key: isSelectedKind ? _globalKey : null,
                            title: Text(kindEntry.key),
                            initiallyExpanded: isSelectedKind,
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
                        );
                      },
                    ).toList(),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
