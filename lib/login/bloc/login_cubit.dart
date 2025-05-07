import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bncmc/repository/login_repository.dart';
import 'package:bncmc/repository/user_details_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:xml/xml.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginrepository;
  final UserDetailsRepository userDetailsRepository;

  LoginCubit(this.loginrepository, this.userDetailsRepository)
    : super(LoginInitial());

  // Future<void> login(String contactNumber) async {
  //   if (!isClosed) emit(LoginLoading());
  //   try {
  //     await Future.delayed(Duration(seconds: 2));
  //     if (!isClosed) emit(otpSent(contactNumber));
  //   } catch (error) {
  //     if (!isClosed) emit(LoginError(error.toString()));
  //   }
  // }

  Future<void> sendOtp(String contactNumber) async {
    if (!isClosed) emit(LoginLoading());

    try {
      final userDetails = await userDetailsRepository.getUserDetails(
        contactNumber,
      );

      if (userDetails == null) {
        if (!isClosed)
          emit(otpError('Invalid contact number or user not found.'));
        return;
      }

      final otpResponse = await loginrepository.sendOtpForRegisteredUser(
        userDetails,
      );
      //print(otpResponse);

      if (otpResponse == null) {
        if (!isClosed) emit(otpError('Failed to send OTP.'));
        return;
      }

      if (otpResponse == 'OTP Sent Successfully') {
        if (!isClosed) emit(otpSent(contactNumber));
      } else {
        if (!isClosed) emit(otpError('OTP sending failed.'));
      }
    } catch (error) {
      if (!isClosed) emit(otpError(error.toString()));
    }
  }

  ////////////
  ///
  ///

  Future<void> verifyOtp(String contactNumber, String otp) async {
    print('verifyOtp called');

    // Emit loading state
    if (!isClosed) emit(LoginLoading());

    try {
      final isVerified = await loginrepository.verifyOtp(contactNumber, otp);

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
      final userDetails = await userDetailsRepository.getUserDetails(
        contactNumber,
      );

      if (userDetails == null) {
        if (!isClosed)
          emit(otpError('Invalid contact number or user not found.'));
        return;
      }

      final otpResponse = await loginrepository.sendOtpForRegisteredUser(
        userDetails,
      );
      //print(otpResponse);

      if (otpResponse == null) {
        if (!isClosed) emit(otpError('Failed to send OTP.'));
        return;
      }

      if (otpResponse == 'OTP Sent Successfully') {
        if (!isClosed) emit(otpSent(contactNumber));
      } else {
        if (!isClosed) emit(otpError('OTP sending failed.'));
      }
    } catch (error) {
      if (!isClosed) emit(otpError(error.toString()));
    }
  }
}
