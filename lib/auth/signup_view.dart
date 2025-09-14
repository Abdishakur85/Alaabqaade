import 'package:alaabqaade/auth/login_view.dart';
import 'package:alaabqaade/auth/auth.dart';
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
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  registration() async {
    // Validate all fields
    if (!AuthMethods.isValidUsername(name!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            "Username must start with a letter and can contain letters, numbers, spaces, and underscores (minimum 3 characters)",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    if (!AuthMethods.isValidEmail(email!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            "Please enter a valid email address",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    if (!AuthMethods.isValidPassword(password!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            "Password must be at least 6 characters long",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create Firebase Auth user first
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      
      // Generate unique ID for user data
      String id = randomAlphaNumeric(10);
      
      // Prepare user data map
      Map<String, dynamic> userInfoMap = {
        "Name": nameController.text.trim(),
        "Email": emailController.text.trim(),
        "id": id,
        "image": "", // Initialize with empty string for image
      };

      // Save to Firestore first (cloud storage)
      await DatabaseMethodes().addUserDetail(userInfoMap, id);
      
      // Only save to SharedPreferences after successful Firestore save
      await SharedPref().savedUserId(id);
      await SharedPref().savedUserName(nameController.text.trim());
      await SharedPref().savedUserEmail(emailController.text.trim());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF4C72AF),
          content: Text(
            "Registration successful!",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred. Please try again.";

      if (e.code == "weak-password") {
        errorMessage = "Password provided is too weak.";
      } else if (e.code == "email-already-in-use") {
        errorMessage = "An account with this email already exists.";
      } else if (e.code == "invalid-email") {
        errorMessage = "Invalid email address.";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Handle any other errors (like Firestore errors)
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            "Failed to save user data. Please try again.",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: AppColors.surface.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.track_changes_outlined,
                        size: 60,
                        color: AppColors.surface,
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Create Account",
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 32,
                        color: AppColors.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Join us today",
                      style: AppTextStyles.body.copyWith(
                        fontSize: 16,
                        color: AppColors.surface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Content Area
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Field
                        Text(
                          "Full Name",
                          style: AppTextStyles.subHeading.copyWith(
                            color: AppColors.onSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.form,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: nameController,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 16,
                              color: AppColors.onSecondary,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter your full name",
                              hintStyle: AppTextStyles.body.copyWith(
                                fontSize: 16,
                                color: AppColors.onSecondary.withOpacity(0.6),
                              ),
                              prefixIcon: Icon(
                                Icons.person_rounded,
                                color: AppColors.primary,
                                size: 22,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),

                        // Email Field
                        Text(
                          "Email Address",
                          style: AppTextStyles.subHeading.copyWith(
                            color: AppColors.onSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.form,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 16,
                              color: AppColors.onSecondary,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter your email",
                              hintStyle: AppTextStyles.body.copyWith(
                                fontSize: 16,
                                color: AppColors.onSecondary.withOpacity(0.6),
                              ),
                              prefixIcon: Icon(
                                Icons.email_rounded,
                                color: AppColors.primary,
                                size: 22,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),

                        // Password Field
                        Text(
                          "Password",
                          style: AppTextStyles.subHeading.copyWith(
                            color: AppColors.onSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.form,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: passwordController,
                            obscureText: !_isPasswordVisible,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 16,
                              color: AppColors.onSecondary,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter your password",
                              hintStyle: AppTextStyles.body.copyWith(
                                fontSize: 16,
                                color: AppColors.onSecondary.withOpacity(0.6),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_rounded,
                                color: AppColors.primary,
                                size: 22,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: AppColors.secondary,
                                  size: 22,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),

                        // Sign Up Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: _isLoading
                                  ? null
                                  : () {
                                      if (passwordController.text.isNotEmpty &&
                                          emailController.text.isNotEmpty &&
                                          nameController.text.isNotEmpty) {
                                        setState(() {
                                          email = emailController.text.trim();
                                          password = passwordController.text.trim();
                                          name = nameController.text.trim();
                                        });
                                        registration();
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: AppColors.error,
                                            content: Text(
                                              'Please fill in all fields.',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                alignment: Alignment.center,
                                child: _isLoading
                                    ? SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppColors.surface,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.person_add_rounded,
                                            color: AppColors.surface,
                                            size: 22,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'Create Account',
                                            style: AppTextStyles.button.copyWith(
                                              fontSize: 18,
                                              color: AppColors.surface,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        // Login Link
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 16,
                                  color: AppColors.onSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LogIn(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Login",
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 16,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
