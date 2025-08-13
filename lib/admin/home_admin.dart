import 'package:alaabqaade/admin/manage_users.dart';
import 'package:alaabqaade/admin/orders_admin.dart';
import 'package:alaabqaade/constants/theme_data.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onePrimary,
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            Center(
              child: Text(
                "HOME ADMIN",
                style: AppTextStyles.heading.copyWith(fontSize: 28),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),

                child: Container(
                  margin: EdgeInsets.only(top: 150),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    child: Column(
                      children: [
                        // First container - Manage Orders
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrdersAdmin(),
                              ),
                            );
                          },
                          child: Material(
                            elevation: 6,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.14,
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: AppColors.navbackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 8,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,

                                children: [
                                  Image.asset(
                                    'assets/notebookbox.png',
                                    // change to your asset
                                    height: 100,
                                    width: 100,
                                  ),
                                  const SizedBox(width: 15),
                                  const Expanded(
                                    child: Text(
                                      "Manage Orders",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        // Second container - Manage Users
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageUsers(),
                              ),
                            );
                          },
                          child: Material(
                            elevation: 5,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.14,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.navbackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 8,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/administrator.png', // change to your asset
                                    height: 100,
                                    width: 100,
                                  ),
                                  const SizedBox(width: 15),
                                  const Expanded(
                                    child: Text(
                                      "Manage Users",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 20),
                                ],
                              ),
                            ),
                          ),
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
    );
  }
}
