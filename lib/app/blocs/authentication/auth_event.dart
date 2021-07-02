import 'package:belmer/app/utils/importer.dart';

@immutable
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class SignInAnonymously extends AuthEvent {}

class SignInMailAndPassword extends AuthEvent {}

class SignInWithGoogle extends AuthEvent {}

class SignInWithTwitter extends AuthEvent {}

class SignOut extends AuthEvent {}
