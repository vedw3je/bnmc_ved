import 'package:bncmc/home/homescreen.dart';
import 'package:bncmc/login/bloc/login_cubit.dart';
import 'package:bncmc/login/screen/already_registered.dart';
import 'package:bncmc/login/screen/otp_screen.dart';
import 'package:bncmc/register/bloc/register_cubit.dart';
import 'package:bncmc/register/bloc/register_state.dart';
import 'package:bncmc/register/widget/textfield.dart';
import 'package:bncmc/repository/login_repository.dart';
import 'package:bncmc/repository/user_details_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBloodGroup;
  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _aadhar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple[700],

        title: Row(
          mainAxisSize: MainAxisSize.min, // Prevent extra space

          children: [
            SizedBox(
              width: 60,
              height: 30,
              child: Image.asset(
                'assets/drawable/bncmc_nav_head.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Bhiwandi mSeva',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider(
                        create:
                            (_) => LoginCubit(
                              LoginRepository(),
                              UserDetailsRepository(),
                            ),
                        child: OtpScreen(contactNumber: _mobile.text),
                      ),
                ),
              );
            });
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple[100]!, // Light purple
                      Colors.deepPurple[400]!, // Medium purple
                      Colors.deepPurple[700]!, // Dark purple
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Already Registered',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildTextField(
                          controller: _firstName,
                          label: 'First Name',
                        ),
                        buildTextField(
                          controller: _lastName,
                          label: 'Last Name',
                        ),
                        buildTextField(
                          controller: _email,
                          label: 'Email',
                          inputType: TextInputType.emailAddress,
                        ),
                        buildTextField(
                          controller: _mobile,
                          label: 'Mobile',
                          inputType: TextInputType.phone,
                        ),
                        buildTextField(
                          controller: _aadhar,
                          label: 'Aadhar Number',
                          inputType: TextInputType.number,
                          isRequired: false,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Blood Group',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedBloodGroup,
                          items:
                              bloodGroups.map((group) {
                                return DropdownMenuItem(
                                  value: group,
                                  child: Text(group),
                                );
                              }).toList(),
                          onChanged:
                              (value) => setState(() {
                                _selectedBloodGroup = value;
                              }),
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<RegisterCubit, RegisterState>(
                          builder: (context, state) {
                            if (state is RegisterLoading) {
                              return const CircularProgressIndicator();
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context
                                          .read<RegisterCubit>()
                                          .registerUser(
                                            firstName: _firstName.text,
                                            lastName: _lastName.text,
                                            email: _email.text,
                                            mobile: _mobile.text,
                                            aadharNumber: _aadhar.text,
                                            bloodGroup:
                                                _selectedBloodGroup ?? "",
                                          );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text('Register'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => BlocProvider(
                                              create:
                                                  (_) => LoginCubit(
                                                    LoginRepository(),
                                                    UserDetailsRepository(),
                                                  ),
                                              child: AlreadyRegisteredScreen(),
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.red, // red background
                                    foregroundColor: Colors.white, // white text
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    elevation: 4,
                                    shadowColor: Colors.redAccent,
                                  ),
                                  child: const Text('Already Registered?'),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
