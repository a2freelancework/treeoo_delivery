part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthUnInitializing extends AuthState {}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthNeedVerification extends AuthState {}

final class AuthLoggedOut extends AuthState {
  const AuthLoggedOut({
    this.email = '',
    this.password = '',
  });

  final String email;
  final String password;
}

final class AuthLoggedIn extends AuthState {
  const AuthLoggedIn({required this.isVehicleSelected});
  final bool isVehicleSelected;
}

final class AuthVerificationSentState extends AuthState {
  const AuthVerificationSentState(this.message);

  final String message;
}

final class AuthRegisterScreenState extends AuthState {
  const AuthRegisterScreenState();
}

final class AuthForgotPasswordScreenState extends AuthState {
  const AuthForgotPasswordScreenState();
}

final class AuthAdminApprovalPending extends AuthState {}

final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;
}
