import 'package:bncmc/home/homescreen.dart';
import 'package:bncmc/login/bloc/login_cubit.dart';
import 'package:bncmc/login/screen/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bncmc/login/bloc/login_cubit.dart'; // Import your LoginCubit

class AlreadyRegisteredScreen extends StatelessWidget {
  const AlreadyRegisteredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController contactController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple[700],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/bncmc_logo.jpeg'),
        ), // Icon to the left
        title: Text(
          'Bhiwandi mSeva',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
