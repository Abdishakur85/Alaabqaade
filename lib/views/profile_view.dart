import 'dart:io';
import 'package:alaabqaade/auth/auth.dart';
import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/models/shared_pref.dart';
import 'package:alaabqaade/views/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? id, name, email, image;
  File? localImage;

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  Future<void> getSharedPref() async {
    id = await SharedPref().getUserId();
    name = await SharedPref().getUserName();
    email = await SharedPref().getUserEmail();
    image = await SharedPref().getUserImage();

    if (image != null && image!.isNotEmpty && File(image!).existsSync()) {
      localImage = File(image!);
    }

    setState(() {});
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        localImage = File(pickedFile.path);
      });
      await SharedPref().setUserImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onePrimary,
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 50.0),
            Center(
              child: Text(
                "Profile",
                style: AppTextStyles.heading.copyWith(
                  fontSize: 26.0,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: pickImage,
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(80),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: localImage != null
                                ? Image.file(
                                    localImage!,
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/profile.jpg",
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: AppColors.onPrimary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: AppColors.secondary,
                                  size: 40,
                                ),
                                SizedBox(width: 15.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      name ?? "Name",
                                      style: AppTextStyles.body.copyWith(
                                        fontSize: 22.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: AppColors.onPrimary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.mail_rounded,
                                  color: AppColors.secondary,
                                  size: 40,
                                ),
                                SizedBox(width: 15.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      email ?? "Email",
                                      style: AppTextStyles.body.copyWith(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      GestureDetector(
                        onTap: () async {
                          await AuthMethods().SignOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnboardingView(),
                            ),
                          );
                        },
                        child: Container(
                          child: Material(
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: AppColors.onPrimary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout_rounded,
                                    color: AppColors.secondary,
                                    size: 40,
                                  ),
                                  SizedBox(width: 15.0),
                                  Text(
                                    "LogOut",
                                    style: AppTextStyles.body.copyWith(
                                      color: AppColors.onSecondary,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.onSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      GestureDetector(
                        onTap: () async {
                          await AuthMethods().deleteuser();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnboardingView(),
                            ),
                          );
                        },
                        child: Container(
                          child: Material(
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: AppColors.onPrimary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_rounded,
                                    color: AppColors.secondary,
                                    size: 40,
                                  ),
                                  SizedBox(width: 15.0),
                                  Text(
                                    "Delete Account",
                                    style: AppTextStyles.body.copyWith(
                                      color: Colors.black,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.onSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
