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
              childlen: g.value.entries
                  .map((k) => EffectTreeNode(
                        dispValue: k.key,
                        childlen: k.value
                            .map((e) => EffectTreeNode(
                                  effect: e,
                                  selected: widget._selectedEffects
                                          ?.firstWhereOrNull((selectedEffect) =>
                                              selectedEffect.id == e.id) !=
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

  static void hide(BuildContext context) => Navigator.pop(context);

  ///
  /// Builder --------------------------
  ///

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
    bool isParent = treeNode.childlen != null;

    if (isParent) {
      return _buildParentTreeNode(context, treeNode);
    } else {
      return _buildChildTreeNode(context, treeNode);
    }
  }

  Widget _buildParentTreeNode(BuildContext context, EffectTreeNode treeNode) {
    // TODO: 要リファクタリング(共通化出来る箇所は共通化すること)
    bool? isParentSelected = _isParentSelected(treeNode);

    return ExpansionTile(
      key: treeNode.initialDisp ? _globalKey : null,
      title: Text(treeNode.dispValue),
      initiallyExpanded: isParentSelected != false,
      collapsedTextColor: Theme.of(context).textTheme.headline3?.color,
      collapsedIconColor: Theme.of(context).textTheme.headline3?.color,
      textColor: Theme.of(context).colorScheme.onPrimary,
      iconColor: Theme.of(context).colorScheme.onPrimary,
      leading: Checkbox(
        activeColor: Theme.of(context).colorScheme.onPrimary,
        tristate: true,
        value: isParentSelected,
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
  }

  Widget _buildChildTreeNode(BuildContext context, EffectTreeNode treeNode) {
    return ListTile(
      title: Text(treeNode.dispValue),
      leading: Checkbox(
        activeColor: Theme.of(context).colorScheme.onPrimary,
        tristate: true, // なぜかここもtrueにしないと変な挙動になる
        value: treeNode.selected,
        onChanged: (value) => _onCheck(treeNode, value),
      ),
    );
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
        onPressed: () => _onOk(context),
        child: Text("OK"),
      ),
    );
  }

  ///
  /// Events --------------------------
  ///

  void _onCheck(EffectTreeNode treeNode, bool? value) {
    setState(() {
      // TODO: 要リファクタリング
      treeNode.selected = value ?? false;
      treeNode.childlen?.forEach((e) {
        e.selected = value ?? false;
        e.childlen?.forEach((e) {
          e.selected = value ?? false;
        });
      });
    });
  }

  void _onOk(BuildContext context) {
    hide(context);

    if (widget._onSelect != null) {
      List<EffectModel>? effects = _treeNodes
          ?.map((e) => _getSelectedEffect(e))
          .expand((e) => e)
          .toList();

      widget._onSelect!(effects);
    }
  }

  List<EffectModel> _getSelectedEffects(List<EffectTreeNode> treeNodes) {
    return treeNodes
        .map((e) => _getSelectedEffect(e))
        .expand((e) => e)
        .toList();
  }

  List<EffectModel> _getSelectedEffect(EffectTreeNode treeNode) {
    if (treeNode.childlen != null) {
      return _getSelectedEffects(treeNode.childlen!);
    }

    if (treeNode.selected == true) {
      return [treeNode.effect!];
    } else {
      return List.empty();
    }
  }

  ///
  /// Methods
  ///

  bool? _isParentSelected(EffectTreeNode? treeNode) {
    if (_isAllSelected(treeNode)) {
      return true;
    } else if (_isAnySelected(treeNode)) {
      return null;
    } else {
      return false;
    }
  }

  bool _isAllSelected(EffectTreeNode? treeNode) {
    List<EffectTreeNode>? childlen = treeNode?.childlen;

    if (childlen == null) {
      return true;
    }

    return childlen
        .where((e) =>
            e.childlen != null ? !_isAllSelected(e) : e.selected == false)
        .isEmpty;
  }

  bool _isAnySelected(EffectTreeNode? treeNode) {
    List<EffectTreeNode>? childlen = treeNode?.childlen;

    if (childlen == null) {
      return false;
    }

    return childlen
        .where(
            (e) => e.childlen != null ? _isAnySelected(e) : e.selected == true)
        .isNotEmpty;
  }
}
