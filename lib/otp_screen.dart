import 'package:defender/home_screen.dart';
import 'package:defender/sailor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();

  FilteringTextInputFormatter numberOnly =
      FilteringTextInputFormatter.allow(RegExp('[0-9]'));

  Future<void> signInWithOtp(String otp) async {
    AuthCredential authCredential;

    authCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser!.isAnonymous) {
      await FirebaseAuth.instance.signOut();
    }
    await signInWithAuthCredential(authCredential);
  }

  Future signInWithAuthCredential(AuthCredential authCredential) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signInWithCredential(authCredential).catchError((error) {
      verificationFailed(error);
    }).then((UserCredential value) async {
      checkUser();
    });
  }

  Future<void> checkUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      if (FirebaseAuth.instance.currentUser!.isAnonymous) {
        await FirebaseAuth.instance.signOut();
      }
    }
    FirebaseAuth.instance.userChanges().listen((event) async {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        await Future.delayed(const Duration(seconds: 2));
      }
      if (firebaseUser == null) {
        return;
      } else {
        //Navigate to home
        Sailor.replaceStackWith(const HomeScreen());
      }
    });
  }

  void verificationFailed(FirebaseAuthException error) {
    print('Wrong otp!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Please verify your otp",
              style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              maxLength: 6,
              inputFormatters: [
                numberOnly,
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey[200]!)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey[300]!)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "Enter OTP"),
              controller: _otpController,
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                textColor: Colors.white,
                padding: const EdgeInsets.all(16),
                onPressed: verifyOtp,
                color: Colors.blue,
                child: const Text("Login"),
              ),
            )
          ],
        ),
      ),
    ));
  }

  void verifyOtp() {
    signInWithOtp(_otpController.text);
  }
}
