import 'package:bloc/bloc.dart';
import 'package:bncmc/repository/bnmc_repository.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final BnmcRepository bnmcRepository;

  LoginCubit(this.bnmcRepository) : super(LoginInitial());

  Future<void> login(String contactNumber) async {
    if (!isClosed) emit(LoginLoading());
    try {
      await Future.delayed(Duration(seconds: 2));
      if (!isClosed) emit(otpSent(contactNumber));
    } catch (error) {
      if (!isClosed) emit(LoginError(error.toString()));
    }
  }

  Future<void> sendOtp(String contactNumber) async {
    if (!isClosed) emit(LoginLoading());
    try {
      await Future.delayed(Duration(seconds: 2));
      if (!isClosed) emit(otpSent(contactNumber));
    } catch (error) {
      if (!isClosed) emit(otpError(error.toString()));
    }
  }

  Future<void> verifyOtp(String contactNumber, String otp) async {
    print('verifyOtp called');

    // Emit loading state
    if (!isClosed) emit(LoginLoading());

    try {
      final isVerified = await bnmcRepository.verifyOtp(contactNumber, otp);

      await Future.delayed(Duration(seconds: 2));

      if (isVerified) {
        if (!isClosed) emit(LoginSuccessful());
      } else {
        if (!isClosed) emit(otpError('Invalid OTP or verification failed.'));
      }
    } catch (error) {
      if (!isClosed) emit(otpError(error.toString()));
    }
  }

  Future<void> resendOtp(String contactNumber) async {
    if (!isClosed) emit(LoginLoading());
    try {
      await Future.delayed(Duration(seconds: 2));
      if (!isClosed) emit(otpSent(contactNumber));
    } catch (error) {
      if (!isClosed) emit(otpError(error.toString()));
    }
  }
}
