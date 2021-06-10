import 'package:belmer/app/models/belts.dart';

abstract class BeltsRepository {
  Stream<List<BeltModel>> fetchByUserId(String? userId);
  Future<List<BeltModel>> selectByUserId(String? userId);
  Future<BeltModel> selectById(String? userId, String? beltId);
  Future<void> save(String? userId, BeltModel belt);
  Future<void> delete(String? userId, String? beltId);
}
