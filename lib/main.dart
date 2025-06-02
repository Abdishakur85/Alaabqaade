// import 'package:alaabqaade/views/onboarding_view.dart';
import 'package:alaabqaade/views/post_view.dart';
import 'package:flutter/material.dart';
import 'package:alaabqaade/constants/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:alaabqaade/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: PostView(),
    );
  }
}
