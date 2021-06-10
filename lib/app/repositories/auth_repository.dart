import 'package:belmer/app/utils/importer.dart';

///
/// Class: 認証用の通信を行うリポジトリ
///
abstract class AuthRepository {
  Future<bool> isSignIn();

  Future<void> signOut();

  Future<User?> getCurrentUser();

  Future<UserCredential> signInAnonymously();

  Future<UserCredential> signInMailAndPassword();

  Future<UserCredential> signInWithGoogle();

  Future<UserCredential> signInWithTwitter();
}
