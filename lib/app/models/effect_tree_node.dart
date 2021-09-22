import 'package:belmer/app/models/accessory_m.dart';

class EffectTreeNode {
  final List<EffectTreeNode>? childlen;
  final EffectModel? effect;
  final String dispValue;
  bool? selected;
  bool initialDisp;

  EffectTreeNode({
    this.childlen,
    this.effect,
    required this.dispValue,
    this.selected = false,
    this.initialDisp = false,
  });
}
