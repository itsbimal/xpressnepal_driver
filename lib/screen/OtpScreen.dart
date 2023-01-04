import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snack/snack.dart';
import 'package:xpressnepal/provider/app_data.dart';
import 'package:xpressnepal/screen/ButtonNavbar.dart';

Color colors = const Color(0xfffe9721);

class otpVerificationScreen extends StatefulWidget {
  const otpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<otpVerificationScreen> createState() => _otpVerificationScreenState();
}

class _otpVerificationScreenState extends State<otpVerificationScreen> {
  String? otp;
  late SharedPreferences sharedPreferences;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String? verificationID = Provider.of<AppData>(context).verification;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/chat.png",
              height: 100,
              width: 100,
            ),

            const Text(
              "otp verification",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),

            // Text Field
            const SizedBox(
              height: 20,
            ),
            Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.only(left: 40, right: 40),
                child: TextField(
                  onChanged: (value) => {otp = value},
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter OTP",
                    hintStyle: TextStyle(color: Colors.grey.shade700),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: colors)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: colors)),
                  ),
                )),
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
                onPressed: () async {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationID, smsCode: otp!);

                  try {
                    await auth.signInWithCredential(credential);
                    final uuid = auth.currentUser!.uid;
                    // sharedPreferences = await SharedPreferences.getInstance();
                    // await sharedPreferences.setString("token", uuid.toString());

                    final doc = await FirebaseFirestore.instance
                        .collection('user')
                        .doc(uuid)
                        .get();

                    if (doc.exists) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ButtonNavbar()));
                    } else {
                      const SnackBar(content: Text('Account does not exist'))
                          .show(context);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text(
                  'verify code',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "enter the code we just sent you",
              style: TextStyle(
                  color: Color.fromARGB(255, 195, 195, 195), fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _textFieldOTP() {
  return SizedBox(
    height: 65,
    child: AspectRatio(
      aspectRatio: 1.0,
      child: TextField(
        autofocus: true,
        showCursor: false,
        readOnly: false,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counter: const Offstage(),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.black12),
              borderRadius: BorderRadius.circular(7)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 2, color: Color.fromARGB(255, 169, 64, 187)),
              borderRadius: BorderRadius.circular(7)),
        ),
      ),
    ),
  );
}
