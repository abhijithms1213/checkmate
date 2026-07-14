import 'dart:async';

import 'package:checkmate/core/constants/app_assets.dart';
import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/features/auth/presentation/pages/login.dart';
import 'package:checkmate/features/bookings/presentation/pages/homepage.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      final isLoggedIn = s1<LocalStorageService>().isLoggedIn;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isLoggedIn ? const HomeScreen() : const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.logoWithTexts),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
