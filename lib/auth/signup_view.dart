import 'package:alaabqaade/auth/login_view.dart';

import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/models/database.dart';
import 'package:alaabqaade/models/shared_pref.dart';
import 'package:alaabqaade/views/bottomnav.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  String? name, email, password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  registration() async {
    if (passwordController.text != "" &&
        emailController.text != "" &&
        nameController.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);
        String id = randomAlphaNumeric(10);
        await SharedPref().savedUserId(id);
        await SharedPref().savedUserName(nameController.text);
        await SharedPref().savedUserEmail(emailController.text);

        Map<String, dynamic> userInfoMap = {
          "Name": nameController.text,
          "Email": emailController.text,
          "id": id,
        };
        await DatabaseMethodes().addUserDetail(userInfoMap, id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Registration successfuly",
              style: AppTextStyles.body,
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(
                "Password provided is too week.",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (e.code == "email-already in use.") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(
                "account already exists.",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/notebook.png"),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Name",
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
            SizedBox(height: 20),
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
            SizedBox(height: 20),
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
              padding: EdgeInsets.only(left: 30.0, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sign Up',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.surface,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (passwordController.text != "" &&
                          emailController.text != "" &&
                          nameController.text != "") {
                        setState(() {
                          email = emailController.text.trim();
                          password = passwordController.text.trim();
                        });
                        registration();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.error,
                            content: Text(
                              'Please fill in all fields.',
                              style: AppTextStyles.body.copyWith(
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
                  "all ready have an account!",
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
                      MaterialPageRoute(builder: (context) => LogIn()),
                    );
                  },
                  child: Text(
                    "Login",
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
