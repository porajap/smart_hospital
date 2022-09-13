import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/pin_repository.dart';

part 'auth_pin_event.dart';

part 'auth_pin_state.dart';

class AuthenticationPinBloc extends Bloc<AuthenticationPinEvent, AuthenticationPinState> {
  final PINRepository pinRepository;

  AuthenticationPinBloc({required this.pinRepository})
      : super(const AuthenticationPinState(pinStatus: AuthenticationPINStatus.enterPIN)) {
    on<AuthenticationPinAddEvent>((event, emit) async {
      String pin = "${state.pin}${event.pinNum}";
      if (pin.length < 4) {
        emit(AuthenticationPinState(pin: pin, pinStatus: AuthenticationPINStatus.enterPIN));
      } else if (pin == "1111") {
        emit(AuthenticationPinState(pin: pin, pinStatus: AuthenticationPINStatus.equals));
      }else if (pin == "2222") {
        emit(AuthenticationPinState(pin: pin, pinStatus: AuthenticationPINStatus.equals));
      }else {
        emit(AuthenticationPinState(pin: pin, pinStatus: AuthenticationPINStatus.unequals));
        await Future.delayed(
          Duration(seconds: 1),
          () => emit(AuthenticationPinState(pinStatus: AuthenticationPINStatus.enterPIN)),
        );
      }
    });

    on<AuthenticationPinEraseEvent>((event, emit) {
      String pin = state.pin.substring(0, state.pin.length - 1);
      emit(AuthenticationPinState(pin: pin, pinStatus: AuthenticationPINStatus.enterPIN));
    });

    on<AuthenticationNullPINEvent>((event, emit) {
      emit(AuthenticationPinState(pinStatus: AuthenticationPINStatus.enterPIN));
    });
  }
}
