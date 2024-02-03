part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthEventInitialize extends AuthEvent {}

final class AuthLoginEvent extends AuthEvent {
  const AuthLoginEvent({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;
}

final class AuthGoToRegisterScreen extends AuthEvent {}

final class AuthRegisterEvent extends AuthEvent {
  const AuthRegisterEvent({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;
}

final class AuthGoToForgotPasswordScreen extends AuthEvent {}

final class AuthResetPasswordEvent extends AuthEvent {
  const AuthResetPasswordEvent(this.email);

  final String email;
}

final class AuthSignOutEvent extends AuthEvent {
  const AuthSignOutEvent();
}
