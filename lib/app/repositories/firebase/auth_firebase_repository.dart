import 'package:belmer/app/utils/importer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth_repository.dart';

class AuthFirestoreRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthFirestoreRepository(
      {FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  ///
  /// Method: 認証済か否かを判定する.
  ///
  @override
  Future<bool> isSignIn() async {
    try {
      // リロード対策で3秒待つ
      // Notes: https://qiita.com/hummer/items/65b296803f8b200838bd
      await Future.any([
        _firebaseAuth.userChanges().firstWhere((u) => u != null),
        Future.delayed(Duration(milliseconds: 3000)),
      ]);

      final user = _firebaseAuth.currentUser;
      return user != null;
    } catch (e) {
      return false;
    }
  }

  ///
  /// Method: 認証状態をクリアする.
  ///
  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  ///
  /// Method: 匿名ログイン
  ///
  @override
  Future<UserCredential> signInAnonymously() async {
    return _firebaseAuth.signInAnonymously();
  }

  ///
  /// Method: Googleログイン
  ///
  @override
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await (_googleSignIn.signIn() as FutureOr<GoogleSignInAccount>);

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<UserCredential> signInWithTwitter() {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signInMailAndPassword() {
    // TODO: メール＆パスワード認証も実装する
    throw UnimplementedError();
  }

  @override
  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }
}
