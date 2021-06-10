import 'package:belmer/app/models/accessory_m.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:flutter/services.dart';

const String BASE_PATH = 'json/accessory.json';

class JsonUtils {
  static Future<AccessoryM> loadAccessoryJson() async {
    String jsonString = await rootBundle.loadString(BASE_PATH);
    return AccessoryM.fromJson(jsonDecode(jsonString));
  }

  static Future<List<BeltM>> loadAccessoryBeltJson() async {
    // JSON読み込み
    Future<AccessoryM> accMF = loadAccessoryJson();

    // 変換して返却
    return accMF.then((accM) => accM.belts);
  }
}
