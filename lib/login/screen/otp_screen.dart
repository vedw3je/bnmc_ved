import 'package:bncmc/home/homescreen.dart';
import 'package:bncmc/login/bloc/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpScreen extends StatelessWidget {
  final String contactNumber;
  const OtpScreen({super.key, required this.contactNumber});

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[700],

        centerTitle: true,
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
        ),
      ),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is otpError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
          if (state is LoginSuccessful) {
            print('OTP Verified - Navigating to Home');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(contactNumber: contactNumber),
                ),
              );
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple[100]!,
                      Colors.deepPurple[400]!,
                      Colors.deepPurple[700]!,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'OTP',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the OTP received',
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final otp = otpController.text.trim();
                        if (otp.isNotEmpty) {
                          context.read<LoginCubit>().verifyOtp(
                            contactNumber,
                            otp,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter OTP')),
                          );
                        }
                      },
                      child: const Text('Verify'),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  // Expanded(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       context.read<LoginCubit>().resendOtp(contactNumber);
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.grey[700],
                  //     ),
                  //     child: const Text('Resend OTP'),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
