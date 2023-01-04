import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snack/snack.dart';
import 'package:xpressnepal/globalVariable.dart';
import 'package:xpressnepal/provider/app_data.dart';

Color colors = Colors.black;

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});
  static String verify = "";

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  String? mobileNo;
  var resenToken;
  FirebaseAuth auth = FirebaseAuth.instance;

  void phoneVerification(String phone) async {
    showProgressDialog(context);
    await auth.verifyPhoneNumber(
      phoneNumber: '+977$phone',
      timeout: const Duration(seconds: 30),
      forceResendingToken: resenToken,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          const SnackBar(content: Text('Invalid Phone Number')).show(context);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        Provider.of<AppData>(context, listen: false)
            .setVerification(verificationId);
        SigninScreen.verify = verificationId;
        Navigator.pushNamed(context, '/otp');
        SnackBar(content: Text('OTP has been sent to +977 $phone'))
            .show(context);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    hideProgressDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/email.png",
              height: 100,
              width: 100,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "valid phone number",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.only(left: 40, right: 40),
              child: TextField(
                onChanged: (value) => {mobileNo = value},
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  hintText: "98########",
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: colors)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: colors)),
                  suffixIcon: const Icon(
                    Icons.check_circle,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 40, right: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  if (mobileNo != null) {
                    phoneVerification(mobileNo!);
                  } else {
                    const SnackBar(content: Text('Enter Phone Number'))
                        .show(context);
                  }
                },
                child: const Text(
                  'Get code',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "We will send you a verification code",
              style: TextStyle(
                  color: Color.fromARGB(255, 195, 195, 195), fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
