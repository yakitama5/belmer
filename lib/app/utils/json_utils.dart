import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

const String BASE_PATH = 'json/accessory.json';

class JsonUtils {
  static Future<AccessoryM> loadAccessoryJson() async {
    String path = (kIsWeb) ? 'assets/$BASE_PATH' : BASE_PATH;
    String jsonString = await rootBundle.loadString(path);
    return AccessoryM.fromJson(jsonDecode(jsonString));
  }

  static Future<List<BeltM>> loadAccessoryBeltJson() async {
    // JSON読み込み
    Future<AccessoryM> accMF = loadAccessoryJson();

    // 変換して返却
    return accMF.then((accM) => accM.belts);
  }
}
