import 'package:bncmc/home/homescreen.dart';
import 'package:bncmc/login/bloc/login_cubit.dart';
import 'package:bncmc/login/screen/already_registered.dart';
import 'package:bncmc/repository/login_repository.dart';
import 'package:bncmc/splashscreen/widget/KenBurnsSplash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/user_details_repository.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () {
      if (context.mounted) {
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
      }
    });
    return Scaffold(
      body: KenBurnsSplash(
        image: AssetImage('assets/bncmc_splash2.jpg'), // Background image
        logo: AssetImage('assets/bncmc_logo.jpeg'), // BNMC logo
        duration: Duration(seconds: 5), // Duration for the splash screen
      ),
    );
  }
}
