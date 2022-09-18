import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_hospital/src/bloc/auth_pin/auth_pin_bloc.dart';
import 'package:smart_hospital/src/model/login/logged_model.dart';
import 'package:smart_hospital/src/model/login/login_model.dart';

import '../../model/login/check_phone_model.dart';
import '../../pages/my_app.dart';
import '../../services/auth_service.dart';
import '../../services/custom_exception.dart';
import '../../services/preferences_service.dart';
import '../../utils/constants.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authService = AuthService();
  final _preferencesService = SharedPreferencesService();

  AuthBloc() : super(AuthInitial()) {
    on<AuthEventAppStart>(_onStartToState);
    on<AuthEventCheckLogin>(_onCheckLoginToState);
    on<AuthEventTokenInvalid>(_onTokenInvalid);
    on<AuthEventLoggedIn>(_onLogin);
    on<AuthEventLoggedOut>(_onLogout);
  }

  _onStartToState(AuthEventAppStart event, Emitter emit) async {
    final bool isLogin = await _preferencesService.getIsLoggedIn();
    final int role = await _preferencesService.getRole();

    if (isLogin) {
      emit(AuthStateAuthenticated(role: role));
    } else {
      emit(AuthStateUnauthenticated());
    }
  }

  _onLogin(AuthEventLoggedIn event, Emitter emit) async {
    emit(AuthStateLoading());
    try {
      LoggedModel _result = await _authService.login(pin: event.pin);

      bool _error = _result.error ?? false;
      int _role = _result.data?.role != null ? _result.data?.role as int : 0;

      if (!_error) {
        emit(AuthStateAuthenticated(role: _role));
      } else {
        emit(AuthStatePINUnEqual());
      }
    } on TimeoutException {
      String _message = "${Constants.textInternetLost}";
      emit(AuthStateUnauthenticated(showAlert: true, message: _message));
    } on AuthenticationException catch (e) {
      String _message = e.message;
      emit(AuthStateUnauthenticated(showAlert: true, message: _message));
    }
  }

  _onLogout(AuthEventLoggedOut event, Emitter emit) async {
    emit(AuthStateLoading());
    await _authService.logout();
    emit(AuthStateUnauthenticated(showAlert: false));
  }

  _onTokenInvalid(AuthEventTokenInvalid event, Emitter emit) async {
    emit(AuthStateLoading());
    await _authService.logout();
    emit(AuthStateTokenInvalid());
  }

  _onCheckLoginToState(AuthEventCheckLogin event, Emitter<AuthState> emit) async {
    emit(AuthStateLoading());

    CheckPhoneModel _result = await _authService.checkPhone(phone: event.phone.trim());

    emit(AuthStateCheckLogin(checkLoginData: _result));
  }

}
