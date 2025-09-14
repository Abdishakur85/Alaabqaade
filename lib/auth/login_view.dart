import 'package:alaabqaade/auth/signup_view.dart';
import 'package:alaabqaade/auth/auth.dart';
import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/models/database.dart';
import 'package:alaabqaade/models/shared_pref.dart';
import 'package:alaabqaade/views/bottomnav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  userLogin() async {
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
      print("Attempting login with email: $email");
      
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      
      print("Firebase Auth successful for user: ${userCredential.user?.email}");
      
      // Fetch user data from Firestore and save to SharedPreferences
      await _loadUserDataFromFirestore();
      
      print("User data loaded successfully");
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code} - ${e.message}");
      String errorMessage = "An error occurred. Please try again.";

      switch (e.code) {
        case "user-not-found":
          errorMessage = "No user found for that email.";
          break;
        case "wrong-password":
          errorMessage = "Wrong password provided for that user.";
          break;
        case "invalid-email":
          errorMessage = "Invalid email address.";
          break;
        case "user-disabled":
          errorMessage = "This account has been disabled.";
          break;
        case "invalid-credential":
          errorMessage = "Invalid email or password. Please check your credentials.";
          break;
        case "too-many-requests":
          errorMessage = "Too many failed attempts. Please try again later.";
          break;
        case "network-request-failed":
          errorMessage = "Network error. Please check your internet connection.";
          break;
        case "operation-not-allowed":
          errorMessage = "Email/password sign-in is not enabled.";
          break;
        default:
          errorMessage = "Authentication failed: ${e.message}";
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print("General exception during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            "Unexpected error: ${e.toString()}",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserDataFromFirestore() async {
    try {
      // Get all users and find the one with matching email
      var usersSnapshot = await FirebaseFirestore.instance
          .collection("user")
          .where("Email", isEqualTo: email!)
          .limit(1)
          .get();
      
      if (usersSnapshot.docs.isNotEmpty) {
        var userDoc = usersSnapshot.docs.first;
        var userData = userDoc.data();
        
        // Save user data to SharedPreferences
        await SharedPref().savedUserId(userData['id'] ?? '');
        await SharedPref().savedUserName(userData['Name'] ?? '');
        await SharedPref().savedUserEmail(userData['Email'] ?? '');
        
        // Save image path if exists
        if (userData['image'] != null && userData['image'].toString().isNotEmpty) {
          await SharedPref().setUserImage(userData['image']);
        }
      }
    } catch (e) {
      print('Error loading user data from Firestore: $e');
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
                      "Welcome Back",
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 32,
                        color: AppColors.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Sign in to continue",
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

                        // Login Button
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
                                          emailController.text.isNotEmpty) {
                                        setState(() {
                                          email = emailController.text.trim();
                                          password = passwordController.text
                                              .trim();
                                        });
                                        userLogin();
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            backgroundColor: AppColors.error,
                                            content: Text(
                                              'Please fill in all fields.',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                              child: Center(
                                child: _isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.onPrimary,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        'Login',
                                        style: AppTextStyles.button.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.onPrimary,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        // Sign Up Link
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Don't have an account? ",
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
                                      builder: (context) => SignUp(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign Up",
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
                        SizedBox(height: 40),
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
