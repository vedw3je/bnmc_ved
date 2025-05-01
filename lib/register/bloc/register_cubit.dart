import 'package:bloc/bloc.dart';
import 'package:bncmc/repository/register_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  void registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String aadharNumber,
    required String bloodGroup,
  }) async {
    try {
      emit(RegisterLoading()); // Emit loading state

      // Call the API to register the user
      final success = await RegisterRepository().registerUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobileNo: mobile,
        adharNo: aadharNumber,
        bloodGroup: bloodGroup,
      );

      // Emit success or failure based on the result of the API call
      if (success == 'OTP Sent Successfully') {
        emit(RegisterSuccess()); // Emit success state
      } else {
        emit(
          RegisterFailure('Registration failed. Please try again.'),
        ); // Emit failure state
      }
    } catch (e) {
      emit(
        RegisterFailure('Registration failed: ${e.toString()}'),
      ); // Emit failure state
    }
  }
}
