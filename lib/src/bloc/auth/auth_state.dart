part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthStateUninitialized extends AuthState {}

class AuthStateAuthenticated extends AuthState {
  final int role;

  AuthStateAuthenticated({required this.role});

  @override
  // TODO: implement props
  List<Object?> get props => [role];
}

class AuthStateLoading extends AuthState {}

// ignore: must_be_immutable
class AuthStateUnauthenticated extends AuthState {
  bool showAlert;
  final String message;

  AuthStateUnauthenticated({this.showAlert = false, this.message = ""});

  @override
  List<Object> get props => [showAlert, message];
}

class AuthStateTokenInvalid extends AuthState {}

class AuthStateCheckLogin extends AuthState{
  final CheckPhoneModel checkLoginData;

  AuthStateCheckLogin({required this.checkLoginData});

  @override
  // TODO: implement props
  List<Object?> get props => [checkLoginData];
}

class AuthStatePINUnEqual extends AuthState{}
