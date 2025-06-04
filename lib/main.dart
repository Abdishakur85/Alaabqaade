// import 'package:alaabqaade/views/onboarding_view.dart';
import 'package:alaabqaade/auth/login_view.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:alaabqaade/constants/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:alaabqaade/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final press = await SharedPreferences.getInstance();
  final onboarding = press.getBool("Onboarding") ?? true;
  runApp(MyApp(onboarding: onboarding));
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp({super.key, required this.onboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColors.surface),
      debugShowCheckedModeBanner: false,

      //  home: onboarding ? OnboardingView() : PostView(),
      home: LogIn(),
    );
  }
}
