import 'package:alaabqaade/auth/signup_view.dart';
import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/views/bottomnav.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => LogInState();
}

class LogInState extends State<LogIn> {
  String? email, password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(
              "No user found for that email.",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      } else if (e.code == "User not found. please check your email.") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(
              "Wrong password provided for that user.",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nav,
      body: Container(
        margin: EdgeInsets.only(top: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 23.0,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.only(left: 40, right: 40),

              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: AppTextStyles.body.copyWith(
                    color: AppColors.onSurface,
                    fontSize: 23,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),

                    borderSide: BorderSide(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 200),
              child: Row(
                children: [
                  Text(
                    "Forget Password?",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),
            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sign in',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.surface,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (passwordController.text != "" &&
                          emailController.text != "") {
                        setState(() {
                          email = emailController.text.trim();
                          password = passwordController.text.trim();
                        });
                        userLogin();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please fill in all fields.',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.error,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: AppColors.form,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: AppColors.nav,
                          size: 60.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.surface,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
