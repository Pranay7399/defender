import 'package:country_picker/country_picker.dart';
import 'package:defender/helpers.dart';
import 'package:defender/otp_screen.dart';
import 'package:defender/sailor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  String? selectedCountryCode;
  bool isLoading = false;

  FilteringTextInputFormatter numberOnly =
      FilteringTextInputFormatter.allow(RegExp('[0-9]'));

  late String verificationId;

  void codeSent(String verificationId, int? forceResendingToken) {
    Sailor.push(OTPScreen(
      verificationId: verificationId,
    ));
  }

  Future<void> verifyPhoneNumber() async {
    if (selectedCountryCode == null) {
      showSnackBar(
          title: 'Please select country code ',
          type: SnackType.info,
          context: context);
      return;
    }
    if (_phoneController.text.isEmpty || _phoneController.text.length != 10) {
      showSnackBar(
          title: 'Invalid mobile number',
          type: SnackType.error,
          context: context);
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      String phoneNumber = selectedCountryCode! + _phoneController.text;
      print('phone number' + phoneNumber);
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+$phoneNumber',
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Something went wrong!');
      print(e);
    }
  }

  void verificationCompleted(PhoneAuthCredential phoneAuthCredential) {
    signInWithAuthCredential(phoneAuthCredential);
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    // emit(state.copyWith(authenticationEnum: AuthenticationEnum.otp));
  }

  Future signInWithAuthCredential(AuthCredential authCredential) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signInWithCredential(authCredential).catchError((error) {
      verificationFailed(error);
    }).then((UserCredential value) async {
      checkUser();
    });
  }

  void verificationFailed(FirebaseAuthException error) {
    showSnackBar(title: 'Wrong OTP!', type: SnackType.error);
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
      } else {}
    });
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
              "Please verify your phone number",
              style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey)),
                  child: selectedCountryCode == null
                      ? IconButton(
                          icon: const Icon(Icons.arrow_drop_down_sharp),
                          onPressed: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode:
                                  true, // optional. Shows phone code before the country name.
                              onSelect: (Country country) {
                                setState(() {
                                  selectedCountryCode = country.phoneCode;
                                });
                              },
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: Text(
                            '+${selectedCountryCode!}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextFormField(
                    inputFormatters: [
                      numberOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey[200]!)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey[300]!)),
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: "Phone Number"),
                    controller: _phoneController,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                textColor: Colors.white,
                padding: const EdgeInsets.all(16),
                onPressed: verifyPhoneNumber,
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Login"),
                    const SizedBox(
                      width: 4,
                    ),
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const SizedBox()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
