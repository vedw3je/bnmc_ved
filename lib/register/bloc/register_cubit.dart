import 'package:bloc/bloc.dart';
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
  }) {
    try {
      emit(RegisterLoading());

      // Simulate a registration process
      final user = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'mobile': mobile,
        'aadharNumber': aadharNumber,
        'bloodGroup': bloodGroup,
      };

      // emit(RegisterSuccess(user));
    } catch (e) {
      emit(RegisterFailure('Registration failed: ${e.toString()}'));
    }
  }
}
