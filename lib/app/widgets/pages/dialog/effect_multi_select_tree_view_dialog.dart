import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/models/effect_tree_node.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/form_items.dart';
import 'package:supercharged/supercharged.dart';

class EffectMultiSelectTreeViewDialog extends StatefulWidget {
  final BeltM? _beltM;
  final List<EffectModel>? _selectedEffects;
  final void Function(List<EffectModel>? effects)? _onSelect;

  static void show(
    BuildContext context, {
    BeltM? beltM,
    void Function(List<EffectModel>? effects)? onSelect,
    List<EffectModel>? selectedEffects,
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
      body: EffectMultiSelectTreeViewDialog(
        beltM: beltM,
        onSelect: onSelect,
        selectedEffects: selectedEffects,
      ),
      showCloseIcon: true,
      dialogType: DialogType.NO_HEADER,
    )..show();
  }

  const EffectMultiSelectTreeViewDialog({
    Key? key,
    BeltM? beltM,
    void Function(List<EffectModel>? effects)? onSelect,
    List<EffectModel>? selectedEffects,
  })  : _beltM = beltM,
        _onSelect = onSelect,
        _selectedEffects = selectedEffects,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _Widget();
}

class _Widget extends State<EffectMultiSelectTreeViewDialog> {
  final _globalKey = GlobalKey();
  List<EffectTreeNode>? _treeNodes;

  @override
  void initState() {
    super.initState();

    // 効果の生成
    Map<String, Map<String, List<EffectModel>>>? effectsMap = widget
        ._beltM?.effects
        .groupListsBy((element) => element.groupName)
        .entries
        .map((e) => MapEntry<String, Map<String, List<EffectModel>>>(
            e.key, e.value.groupBy((element) => element.kindName)))
        .toMap();
    _treeNodes = effectsMap?.entries
        .map((g) => EffectTreeNode(
              dispValue: g.key,
              selected: widget._selectedEffects
                      ?.firstWhereOrNull((e) => e.groupName == g.key) !=
                  null,
              childlen: g.value.entries
                  .map((k) => EffectTreeNode(
                        dispValue: k.key,
                        selected: widget._selectedEffects?.firstWhereOrNull(
                                (e) => e.kindName == k.key) !=
                            null,
                        childlen: k.value
                            .map((e) => EffectTreeNode(
                                  effect: e,
                                  selected: widget._selectedEffects
                                          ?.firstWhereOrNull(
                                              (e) => e.id == e.id) !=
                                      null,
                                  dispValue: e.name,
                                ))
                            .toList(),
                      ))
                  .toList(),
            ))
        .toList();

    // 既に選択済の効果が存在する場合は、表示箇所までスクロール
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      BuildContext? context = _globalKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(context);
      }
    });
  }

  void _handleSelect(BuildContext context, List<EffectModel>? effects) {
    hide(context);
    if (widget._onSelect != null) {
      widget._onSelect!(effects);
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
    if (_treeNodes == null) {
      return Container();
    }

    return Container(
      height: 550,
      child: SingleChildScrollView(
        child: Column(
          children:
              _treeNodes?.map((e) => _buildTreeNode(context, e)).toList() ?? [],
        ),
      ),
    );
  }

  Widget _buildTreeNode(BuildContext context, EffectTreeNode treeNode) {
    Widget parentWidget = ExpansionTile(
      key: treeNode.initialDisp ? _globalKey : null,
      title: Text(treeNode.dispValue),
      initiallyExpanded: treeNode.selected ?? false,
      collapsedTextColor: Theme.of(context).textTheme.headline3?.color,
      collapsedIconColor: Theme.of(context).textTheme.headline3?.color,
      textColor: Theme.of(context).colorScheme.onPrimary,
      iconColor: Theme.of(context).colorScheme.onPrimary,
      leading: Checkbox(
        activeColor: Theme.of(context).colorScheme.onPrimary,
        tristate: true,
        value: treeNode.selected,
        onChanged: (value) => _onCheck(treeNode, value),
      ),
      children: treeNode.childlen
              ?.map((child) => Container(
                    padding: EdgeInsets.only(left: 10),
                    child: _buildTreeNode(context, child),
                  ))
              .toList() ??
          [],
    );

    Widget childWidget = ListTile(
      title: Text(treeNode.dispValue),
      leading: Checkbox(
        activeColor: Theme.of(context).colorScheme.onPrimary,
        tristate: true, // なぜかここもtrueにしないと変な挙動になる
        value: treeNode.selected,
        onChanged: (value) => _onCheck(treeNode, value),
      ),
    );

    return Container(
      child: treeNode.childlen != null ? parentWidget : childWidget,
    );
  }

  void _onCheck(EffectTreeNode treeNode, bool? value) {
    setState(() {
      treeNode.selected = value;
    });
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
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
