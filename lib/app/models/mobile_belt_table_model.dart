class MobileBeltCardEffectModel {
  const MobileBeltCardEffectModel({
    this.title,
    this.belts,
  });

  final String? title;
  final List<MobileBeltCardBeltModel>? belts;
}

class MobileBeltCardBeltModel {
  const MobileBeltCardBeltModel({
    this.memo,
    this.effect,
    this.crownDispFlag = false,
  });

  final String? memo;
  final String? effect;
  final bool crownDispFlag;
}
