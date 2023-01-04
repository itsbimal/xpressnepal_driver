import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpressnepal/provider/app_data.dart';
import 'package:xpressnepal/screen/ButtonNavbar.dart';
import 'package:xpressnepal/screen/OtpScreen.dart';
import 'package:xpressnepal/screen/SigninScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/navbar',
        routes: {
          '/navbar': (context) => const ButtonNavbar(),
          '/signin': (context) => const SigninScreen(),
          '/otp': (context) => const otpVerificationScreen(),
        },
      ),
    );
  }
}
