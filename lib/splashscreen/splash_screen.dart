import 'package:bncmc/home/homescreen.dart';
import 'package:bncmc/login/screen/already_registered.dart';
import 'package:bncmc/register/screen/register_screen.dart';
import 'package:bncmc/repository/user_details_repository.dart';
import 'package:bncmc/splashscreen/widget/KenBurnsSplash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () async {
      final prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('is_loggedin') ?? false;

      if (isLoggedIn) {
        String mobileNo = prefs.getString('mobile_no') ?? '';

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(contactNumber: mobileNo),
            ),
          );
        }
      } else {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        }
      }
    });

    return Scaffold(
      body: KenBurnsSplash(
        image: AssetImage(
          'assets/drawable/splash_screen.jpg',
        ), // Background image
        logo: AssetImage('assets/bncmc_logo.jpeg'), // BNMC logo
        duration: Duration(seconds: 5), // Duration for the splash screen
      ),
    );
  }
}
