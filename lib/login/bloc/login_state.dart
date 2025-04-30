part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccessful extends LoginState {}

class LoginError extends LoginState {
  final String errorMessage;

  const LoginError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class otpSent extends LoginState {
  final String otp;

  const otpSent(this.otp);

  @override
  List<Object?> get props => [otp];
}

class otpError extends LoginState {
  final String errorMessage;

  const otpError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
