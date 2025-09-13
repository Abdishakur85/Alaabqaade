import 'package:firebase_auth/firebase_auth.dart';
import 'package:alaabqaade/models/database.dart';
import 'package:alaabqaade/models/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  Future SignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future deleteuser() async {
    User? user = await FirebaseAuth.instance.currentUser;
    user?.delete();
  }

  // Comprehensive delete user method
  Future<bool> deleteUserAccount() async {
    try {
      User? user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get user ID from shared preferences (the app uses custom IDs)
        String? userId = await SharedPref().getUserId();

        if (userId != null) {
          // Delete user data from Firestore
          await DatabaseMethodes().deleteUser(userId);
        }

        // Clear all shared preferences
        await _clearAllSharedPreferences();

        // Delete Firebase Auth user
        await user.delete();

        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error deleting user account: $e");
      return false;
    }
  }

  // Clear all shared preferences
  Future<void> _clearAllSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Also clear the custom shared preferences
      await SharedPref().savedUserId("");
      await SharedPref().savedUserName("");
      await SharedPref().savedUserEmail("");
      await SharedPref().setUserImage("");
    } catch (e) {
      print("Error clearing shared preferences: $e");
    }
  }

  // Email validation
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  // Username validation - must start with alphabetic, then can include letters, numbers, spaces, and underscores
  static bool isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z][a-zA-Z0-9_\s]*$').hasMatch(username) &&
        username.length >= 3;
  }

  // Password validation - at least 6 characters
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
}
