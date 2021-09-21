import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/form_items.dart';
import 'package:supercharged/supercharged.dart';

class EffectSelectDialog extends StatefulWidget {
  final BeltM? _beltM;
  final EffectModel? _selectedEffect;
  final void Function(EffectModel? effectModel)? _onSelect;

  static void show(
    BuildContext context, {
    BeltM? beltM,
    void Function(EffectModel? effectModel)? onSelect,
    EffectModel? selectedEffect,
  }) {
    AwesomeDialog(
      context: context,
      padding: EdgeInsets.only(
        top: 20,
        left: 30,
        right: 30,
        bottom: 0,
      ),
      useRootNavigator: true,
      borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 2),
      dismissOnTouchOutside: true,
      dialogBackgroundColor: Theme.of(context).colorScheme.background,
      headerAnimationLoop: false,
      width: 700,
      animType: AnimType.SCALE,
      body: EffectSelectDialog(
        beltM: beltM,
        onSelect: onSelect,
        selectedEffect: selectedEffect,
      ),
      showCloseIcon: true,
      dialogType: DialogType.NO_HEADER,
    )..show();
  }

  const EffectSelectDialog({
    Key? key,
    BeltM? beltM,
    void Function(EffectModel? effectModel)? onSelect,
    EffectModel? selectedEffect,
  })  : _beltM = beltM,
        _onSelect = onSelect,
        _selectedEffect = selectedEffect,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _Widget();
}

class _Widget extends State<EffectSelectDialog> {
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

  void _handleSelect(BuildContext context, EffectModel? effectModel) {
    hide(context);
    if (widget._onSelect != null) {
      widget._onSelect!(effectModel);
    }
  }

  static void hide(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBody(context),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
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

    return Container(
      height: 550,
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
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    iconColor: Theme.of(context).colorScheme.onPrimary,
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
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            iconColor: Theme.of(context).colorScheme.onPrimary,
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

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      // constraints: BoxConstraints(maxHeight: 70),
      padding: EdgeInsets.only(top: 15, bottom: 15),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      alignment: Alignment.center,
      child: FormElevatedButton(
        onPressed: () => _handleSelect(context, null),
        child: Text("選択クリア"),
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.primary,
            onPrimary: Theme.of(context).colorScheme.onPrimary,
            side: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            )).merge(Theme.of(context).elevatedButtonTheme.style),
      ),
    );
  }
}
