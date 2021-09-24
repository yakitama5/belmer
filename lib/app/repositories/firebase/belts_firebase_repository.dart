import 'package:belmer/app/models/belts.dart';
import 'package:belmer/app/repositories/belts_repository.dart';
import 'package:belmer/app/utils/importer.dart';

class BeltsFirebaseRepository extends BeltsRepository {
  final FirebaseFirestore _firestore;

  BeltsFirebaseRepository({FirebaseFirestore? firestore})
      : this._firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<BeltModel>> fetchByUserId(String? userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("belts")
        .orderBy('createdAt')
        .snapshots()
        .map((col) =>
            col.docs.map((doc) => BeltModel.fromJson(doc.data())).toList());
  }

  @override
  Future<void> save(String? userId, BeltModel belt) async {
    CollectionReference beltsCol =
        _firestore.collection("users").doc(userId).collection("belts");

    if (belt.id == null) {
      // 登録して、登録したIDを保持
      DocumentReference addedDoc = await beltsCol.add(belt.toJson());

      return addedDoc.update({
        'id': addedDoc.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      // 更新(登録後の場合はID項目を設定)
      return beltsCol.doc(belt.id).update(belt.toJson());
    }
  }

  @override
  Future<BeltModel> selectById(String? userId, String? beltId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("belts")
        .doc(beltId)
        .get()
        .then((doc) => BeltModel.fromJson(doc.data()!));
  }

  @override
  Future<void> delete(String? userId, String? beltId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("belts")
        .doc(beltId)
        .delete();
  }

  @override
  Future<List<BeltModel>> selectByUserId(String? userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection('belts')
        .orderBy('createdAt')
        .get()
        .then((col) =>
            col.docs.map((doc) => BeltModel.fromJson(doc.data())).toList());
  }
}
