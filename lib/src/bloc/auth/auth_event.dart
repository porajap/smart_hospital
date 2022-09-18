part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}


class AuthEventAppStart extends AuthEvent {}

class AuthEventLoggedIn extends AuthEvent {
  final String pin;
  const AuthEventLoggedIn({required this.pin});

  @override
  List<Object?> get props => [pin];
}

class AuthEventLoggedOut extends AuthEvent {}

class AuthEventTokenInvalid extends AuthEvent {}

class AuthEventCheckLogin extends AuthEvent{
  final String phone;

  AuthEventCheckLogin({required this.phone});

  @override
  List<Object?> get props => [];
}
