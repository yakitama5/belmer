import 'package:belmer/app/models/login_model.dart';
import 'package:belmer/app/repositories/auth_repository.dart';
import 'package:belmer/app/utils/importer.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({AuthRepository repository})
      : assert(repository != null),
        _repository = repository,
        super(AuthStatePure());

  @override
  Stream<AuthState> mapEventToState(event) async* {
    if (event is AppStarted) {
      yield* _appStarted(event);
    } else if (event is SignInAnonymously) {
      yield* _signInAnonymously(event);
    } else if (event is SignInWithGoogle) {
      yield* _signInWithGoogle(event);
    } else if (event is SignInWithTwitter) {
      yield* _signInWithTwitter(event);
    } else if (event is SignInMailAndPassword) {
    } else if (event is LoggedOut) {
      yield* _loggedOut(event);
    }
  }

  ///
  /// Event: アプリ起動
  ///
  Stream<AuthState> _appStarted(AppStarted event) async* {
    // 認証状態の確認
    final bool isSignIn = await _repository.isSignIn();

    if (isSignIn) {
      // ユーザー情報の取得
      final User user = await _repository.getCurrentUser();
      yield AuthSuccess(loginModel: _userToLoginModel(user));
    } else {
      yield NotAuth();
    }
  }

  ///
  /// Event: 匿名ログイン
  ///
  Stream<AuthState> _signInAnonymously(SignInAnonymously event) async* {
    yield AuthProgress();

    try {
      UserCredential userCredential = await _repository.signInAnonymously();
      yield AuthSuccess(loginModel: _credentialToLoginModel(userCredential));
    } catch (e, stackTrace) {
      yield AuthFialure();
    }
  }

  ///
  /// Event: Googleログイン
  ///
  Stream<AuthState> _signInWithGoogle(SignInWithGoogle event) async* {
    yield AuthProgress();

    try {
      UserCredential userCredential = await _repository.signInWithGoogle();
      yield AuthSuccess(loginModel: _credentialToLoginModel(userCredential));
    } catch (e, stackTrace) {
      yield AuthFialure();
    }
  }

  ///
  /// Event: Twitterログイン
  ///
  Stream<AuthState> _signInWithTwitter(SignInWithTwitter event) async* {
    yield AuthProgress();

    try {
      UserCredential userCredential = await _repository.signInWithTwitter();
      yield AuthSuccess(loginModel: _credentialToLoginModel(userCredential));
    } catch (e) {
      yield AuthFialure();
    }
  }

  ///
  /// Event: ログアウト
  ///
  Stream<AuthState> _loggedOut(LoggedOut event) async* {
    yield AuthStatePure();
    await _repository.signOut();
    yield NotAuth();
  }

  LoginModel _credentialToLoginModel(UserCredential userCredential) {
    return _userToLoginModel(userCredential?.user);
  }

  LoginModel _userToLoginModel(User user) {
    return LoginModel(
      uid: user?.uid,
    );
  }
}
