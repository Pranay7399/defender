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
            const Text(
              'Defender',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
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
