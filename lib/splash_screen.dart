import 'package:defender/home_screen.dart';
import 'package:defender/login_screen.dart';
import 'package:defender/sailor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLogged = false;
  bool isLoading = true;

  @override
  void initState() {
    checkIsLoggedIn();
    super.initState();
  }

  void checkIsLoggedIn() {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (FirebaseAuth.instance.currentUser == null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Sailor.push(const LoginScreen());
        });
      } else {
        Sailor.replaceStackWith(const HomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            const Text(
              'Defender',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
