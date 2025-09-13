// import 'package:alaabqaade/views/onboarding_view.dart';

import 'package:alaabqaade/admin/admin_login.dart';
import 'package:alaabqaade/admin/home_admin.dart';
import 'package:alaabqaade/admin/manage_users.dart';
import 'package:alaabqaade/admin/orders_admin.dart';
import 'package:alaabqaade/auth/login_view.dart';
import 'package:alaabqaade/auth/signup_view.dart';
import 'package:alaabqaade/views/bottomnav.dart';
import 'package:alaabqaade/views/onboarding_view.dart';
import 'package:alaabqaade/views/profile_view.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:alaabqaade/constants/theme_data.dart';

import 'package:alaabqaade/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColors.surface),
      debugShowCheckedModeBanner: false,
      // home: LogIn(),
      home: OnboardingView(),
      // home: AdminLogin(),
    );
  }
}
