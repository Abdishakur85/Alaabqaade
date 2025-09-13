import 'dart:io';
import 'package:alaabqaade/auth/auth.dart';
import 'package:alaabqaade/auth/login_view.dart';
import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/models/database.dart';
import 'package:alaabqaade/models/shared_pref.dart';
import 'package:alaabqaade/views/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? id, name, email, image;
  File? localImage;
  bool _isDeleting = false;

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

    // First try to load from shared preferences (local file)
    if (image != null && image!.isNotEmpty && File(image!).existsSync()) {
      localImage = File(image!);
    } else {
      // If no local image, try to load from database
      if (id != null) {
        try {
          var userDoc = await FirebaseFirestore.instance
              .collection("user")
              .doc(id)
              .get();

          if (userDoc.exists) {
            var userData = userDoc.data();
            String? dbImagePath = userData?['image'];

            if (dbImagePath != null &&
                dbImagePath.isNotEmpty &&
                File(dbImagePath).existsSync()) {
              localImage = File(dbImagePath);
              await SharedPref().setUserImage(dbImagePath);
            }
          }
        } catch (e) {
          print("Error loading image from database: $e");
        }
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      if (mounted) {
        setState(() {
          localImage = File(pickedFile.path);
        });
      }
      // Save to shared preferences for local access
      await SharedPref().setUserImage(pickedFile.path);
      // Update database with image path
      if (id != null) {
        await DatabaseMethodes().updateUserImage(id!, pickedFile.path);
      }
    }
  }

  Future<void> _showDeleteConfirmation() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone and will permanently remove all your data.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isDeleting
                  ? null
                  : () async {
                      Navigator.of(context).pop();
                      await _deleteUserAccount();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isDeleting
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUserAccount() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      bool success = await AuthMethods().deleteUserAccount();

      if (mounted) {
        if (success) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Account deleted successfully',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to login page instead of onboarding
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LogIn()),
            (route) => false,
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(
                'Failed to delete account. Please try again.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(
              'An error occurred while deleting your account.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          ),
        ),
        child: Column(
          children: [
            // Custom AppBar with gradient
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(
                  "Profile",
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Main Content with rounded top corners
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(height: 16),

                      // Modern Profile Avatar
                      _buildModernAvatar(),

                      SizedBox(height: 32),

                      // Profile Info Cards
                      _buildModernInfoCard(
                        icon: Icons.person_outline,
                        label: "Name",
                        value: name ?? "Name",
                        color: AppColors.primary,
                      ),

                      SizedBox(height: 16),

                      _buildModernInfoCard(
                        icon: Icons.email_outlined,
                        label: "Email",
                        value: email ?? "Email",
                        color: AppColors.primary,
                      ),

                      SizedBox(height: 32),

                      // Action Buttons
                      _buildModernActionButton(
                        icon: Icons.logout_rounded,
                        title: "LogOut",
                        color: AppColors.primary,
                        removeShadow: true,
                        isWhiteBackground: true,
                        onTap: () async {
                          await AuthMethods().SignOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LogIn()),
                          );
                        },
                      ),

                      SizedBox(height: 16),

                      _buildModernActionButton(
                        icon: Icons.delete_forever_rounded,
                        title: _isDeleting ? "Deleting..." : "Delete Account",
                        color: Colors.red,
                        removeShadow: true,
                        onTap: _isDeleting
                            ? null
                            : () {
                                _showDeleteConfirmation();
                              },
                      ),

                      SizedBox(height: 32),
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

  Widget _buildModernAvatar() {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Color(0xFF667eea).withOpacity(0.2),
              Color(0xFF764ba2).withOpacity(0.2),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: localImage != null
                  ? Image.file(
                      localImage!,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/profile.jpg",
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF667eea),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF667eea).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernActionButton({
    required IconData icon,
    required String title,
    required Color color,
    bool isDestructive = false,
    bool isLoading = false,
    bool removeShadow = false,
    bool isWhiteBackground = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isDestructive
              ? LinearGradient(
                  colors: [
                    Colors.red.withOpacity(0.1),
                    Colors.red.withOpacity(0.05),
                  ],
                )
              : isWhiteBackground
                  ? LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white,
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        color.withOpacity(0.1),
                        Colors.white.withOpacity(0.4),
                      ],
                    ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDestructive 
                ? Colors.red.withOpacity(0.3)
                : isWhiteBackground
                    ? Colors.grey.withOpacity(0.3)
                    : color.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: removeShadow ? [] : [
            BoxShadow(
              color: (isDestructive ? Colors.red : color).withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isWhiteBackground 
                    ? color.withOpacity(0.15)
                    : (isDestructive ? Colors.red : color).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDestructive ? Colors.red : color,
                        ),
                      ),
                    )
                  : Icon(
                      icon,
                      color: isDestructive ? Colors.red : color,
                      size: 24,
                    ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDestructive 
                      ? Colors.red 
                      : isWhiteBackground 
                          ? Colors.grey[800]
                          : Colors.grey[800],
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isDestructive 
                  ? Colors.red 
                  : isWhiteBackground 
                      ? Colors.grey[600]
                      : Colors.grey[600],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
