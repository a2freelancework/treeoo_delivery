// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:treeo_delivery/core/utils/string_constants.dart';
import 'package:treeo_delivery/domain/auth/entity/pickup_user.dart';
import 'package:treeo_delivery/domain/auth/usecases/forgot_password_usecase.dart';
import 'package:treeo_delivery/domain/auth/usecases/get_pickup_user_from_cache.dart';
import 'package:treeo_delivery/domain/auth/usecases/sign_in_usecase.dart';
import 'package:treeo_delivery/domain/auth/usecases/sign_out_usecase.dart';
import 'package:treeo_delivery/domain/auth/usecases/user_register_usecase.dart';
import 'package:treeo_delivery/presentation/authentication/auth_bloc/auth_helper.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required UserRegister userRegister,
    required SignIn signIn,
    required ForgotPassword forgotPassword,
    required SignOut signOut,
    required GetPickupUserFromCache getPickupUserFromCache,
  })  : _userRegister = userRegister,
        _signIn = signIn,
        _forgotPassword = forgotPassword,
        _signOut = signOut,
        _getPickupUserFromCache = getPickupUserFromCache,
        super(AuthUnInitializing()) {
    on<AuthEventInitialize>(_authEventInitialize);
    on<AuthLoginEvent>(_authLoginEvent);
    on<AuthRegisterEvent>(_authRegisterEvent);
    on<AuthResetPasswordEvent>(_authResetPasswordEvent);
    on<AuthSignOutEvent>(_authSignOutEvent);

    on<AuthGoToRegisterScreen>(_authGoToRegisterScreen);
    on<AuthGoToForgotPasswordScreen>(_authGoToForgotPasswordScreen);
  }

  final GetPickupUserFromCache _getPickupUserFromCache;

  final UserRegister _userRegister;
  final SignIn _signIn;
  final ForgotPassword _forgotPassword;
  final SignOut _signOut;

  FutureOr<void> _authEventInitialize(
    AuthEventInitialize event,
    Emitter<AuthState> emit,
  ) async {
    final res = _getPickupUserFromCache();
    await res.fold(
      (failure) async {
        final cred = Helper.getLoginCredential();
        emit(AuthLoggedOut(email: cred.email, password: cred.password));
      },
      (user) async {
        if (user.isSessionExpired) {
          final cred = Helper.getLoginCredential();
          await _signOut();
          emit(AuthLoggedOut(email: cred.email, password: cred.password));
        } else {
          emit(
            AuthLoggedIn(
              isVehicleSelected: user.vehicle != null,
              isLocationSelected: user.pickupLocation != null,
            ),
          );
        }
      },
    );
  }

  FutureOr<void> _authLoginEvent(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('*************LOGIN BLOC************');
    emit(const AuthLoading());
    unawaited(
      Helper.saveLoginCredential(
        email: event.email,
        password: event.password,
      ),
    );
    final result = await _signIn(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthLoggedIn(
        isVehicleSelected: false,
        isLocationSelected: false,
      ),),
    );
  }

  FutureOr<void> _authRegisterEvent(
    AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _userRegister(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) =>
          emit(const AuthVerificationSentState(EMAIL_VERIFICATION_LINK_SENT)),
    );
  }

  FutureOr<void> _authSignOutEvent(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signOut();

    result.fold(
      (failure) => emit(const AuthLoggedOut()),
      (_) => emit(const AuthLoggedOut()),
    );
  }

  FutureOr<void> _authResetPasswordEvent(
    AuthResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _forgotPassword(event.email);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthVerificationSentState(PASSWORD_RESET_LINK_SENT)),
    );
  }

  FutureOr<void> _authGoToRegisterScreen(
    AuthGoToRegisterScreen event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthRegisterScreenState());
  }

  FutureOr<void> _authGoToForgotPasswordScreen(
    AuthGoToForgotPasswordScreen event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthForgotPasswordScreenState());
  }
}
