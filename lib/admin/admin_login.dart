import 'package:alaabqaade/admin/home_admin.dart';
import 'package:alaabqaade/constants/theme_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                "assets/administrator.png",
                height: 180,
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),

              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20.0),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      "Admin Login",
                      style: AppTextStyles.heading.copyWith(fontSize: 30.0),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Text(
                    "Username",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.surface,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.navbackground,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your user name",
                        hintStyle: AppTextStyles.description.copyWith(
                          fontSize: 20,
                        ),
                        prefixIcon: Icon(Icons.person_rounded),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    "Password",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.surface,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.navbackground,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your password",
                        hintStyle: AppTextStyles.description.copyWith(
                          fontSize: 20,
                        ),
                        prefixIcon: Icon(Icons.lock_rounded),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.0),
                ],
              ),
            ),
            SizedBox(height: 40.0),
            GestureDetector(
              onTap: () {
                loginAdmin();
              },
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Center(
                    child: Text("LogIn", style: AppTextStyles.heading),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()["username"] != usernameController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(
                "Your User name is not correct.",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        } else if (result.data()["password"] !=
            passwordController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(
                "Wrong password .",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeAdmin()),
          );
        }
      });
    });
  }
}
