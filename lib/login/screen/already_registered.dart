import 'package:bncmc/commonwidgets/gradient_container.dart';
import 'package:bncmc/login/bloc/login_cubit.dart';
import 'package:bncmc/login/screen/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import your LoginCubit

class AlreadyRegisteredScreen extends StatelessWidget {
  const AlreadyRegisteredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController contactController = TextEditingController();

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
            const SizedBox(width: 8), // Space between image and text
            const Text(
              'Bhiwandi mSeva',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ), // Title in the AppBar
      ),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state is otpSent) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value:
                          context
                              .read<LoginCubit>(), // REUSE the existing cubit
                      child: OtpScreen(contactNumber: contactController.text),
                    ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientContainer(text: 'Already Registered'),
              SizedBox(height: 20.0),
              Text(
                'Contact No.',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: contactController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your contact number',
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final contactNo = contactController.text.trim();
                    if (contactNo.isNotEmpty) {
                      context.read<LoginCubit>().sendOtp(contactNo);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter a contact number'),
                        ),
                      );
                    }
                  },
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
