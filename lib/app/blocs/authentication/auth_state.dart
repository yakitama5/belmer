import 'package:belmer/app/models/login_model.dart';
import 'package:belmer/app/utils/importer.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthStatePure extends AuthState {}

class NotAuth extends AuthState {}

class AuthProgress extends AuthState {}

class AuthSuccess extends AuthState {
  final LoginModel loginModel;

  AuthSuccess({required this.loginModel});
}

class AuthFialure extends AuthState {}
