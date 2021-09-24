import 'package:flutter/gestures.dart';

import 'importer.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch, // 通常のタッチ入力デバイス
        PointerDeviceKind.mouse, // これを追加！
      };
}
