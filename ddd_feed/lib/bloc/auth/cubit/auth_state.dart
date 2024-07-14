part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginLoading extends AuthState {}

class GetCurrentUserLoading extends AuthState {}

class LoggedIn extends AuthState {
  final bool? isLoggedInSuccess;
  LoggedIn({this.isLoggedInSuccess});
}

class LoginError extends AuthState {}

class UploadProfileSuccess extends AuthState {
  final ProfileUploadResponse? profileUploadResponse;
  UploadProfileSuccess({this.profileUploadResponse});
}

class UploadProfileFailure extends AuthState {
  final String? message;
  UploadProfileFailure({this.message});
}

class RegisterUserSuccess extends AuthState {
  final bool? isSuccess;
  RegisterUserSuccess({this.isSuccess});
}

class RegisterUserFailure extends AuthState {
  final String? message;
  RegisterUserFailure({this.message});
}

class GetCurrentUserSuccess extends AuthState {
  final UserInfo? userInfo;
  GetCurrentUserSuccess({this.userInfo});
}

class GetCurrentUserFailure extends AuthState {
  final String? message;
  GetCurrentUserFailure({this.message});
}
