import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/models/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class OrdersAdmin extends StatefulWidget {
  const OrdersAdmin({super.key});

  @override
  State<OrdersAdmin> createState() => _OrdersAdminState();
}

class _OrdersAdminState extends State<OrdersAdmin> {
  Stream? OrderStream;
  Widget allOrder() {
    return StreamBuilder(
      stream: OrderStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];

                  return ds["Tracker"] == 3
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Package Icon Header
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primary.withOpacity(0.1),
                                            AppColors.secondary.withOpacity(
                                              0.1,
                                            ),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Image.asset(
                                        "assets/box2.png",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        "Order #${ds.id.substring(0, 8)}",
                                        style: AppTextStyles.heading.copyWith(
                                          fontSize: 18,
                                          color: AppColors.onSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),

                                // Drop-off Information
                                _buildInfoSection(
                                  title: "Drop-off Information",
                                  icon: Icons.location_on_rounded,
                                  iconColor: Colors.red,
                                  address: ds["DropeOffAddress"],
                                  name: ds["DropeOffUsername"],
                                  phone: ds["DropeOffNumber"],
                                ),

                                SizedBox(height: 16),

                                // Pickup Information
                                _buildInfoSection(
                                  title: "Pickup Information",
                                  icon: Icons.my_location_rounded,
                                  iconColor: Colors.blue,
                                  address: ds["PickUpaddress"],
                                  name: ds["PickUpUsername"],
                                  phone: ds["pickUpNumber"],
                                ),

                                SizedBox(height: 20),

                                // Status Tracking
                                _buildStatusSection(ds),
                              ],
                            ),
                          ),
                        );
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 80,
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "No orders found",
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 20,
                        color: AppColors.onSecondary.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String address,
    required String name,
    required String phone,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.heading.copyWith(
            fontSize: 16,
            color: AppColors.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                address,
                style: AppTextStyles.body.copyWith(
                  fontSize: 16,
                  color: AppColors.onSecondary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.person_rounded, color: iconColor, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.body.copyWith(
                  fontSize: 16,
                  color: AppColors.onSecondary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.phone_rounded, color: iconColor, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                phone,
                style: AppTextStyles.body.copyWith(
                  fontSize: 16,
                  color: AppColors.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusSection(DocumentSnapshot ds) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Order Status",
                style: AppTextStyles.heading.copyWith(
                  fontSize: 16,
                  color: AppColors.onSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              ds["Tracker"] >= 0 ? "In Progress" : "Not Started",
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                color: AppColors.onSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: ds["Tracker"] / 3,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 16),
            Text(
              "${(ds["Tracker"] / 3 * 100).round()}%",
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                color: AppColors.onSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (ds["Tracker"] < 3) {
                    int updatedTracker = ds["Tracker"];
                    updatedTracker++;
                    await DatabaseMethodes().updateAdminTracker(
                      ds.id,
                      updatedTracker,
                    );
                    await DatabaseMethodes().updateUserTracker(
                      ds["UserId"],
                      updatedTracker,
                      ds["OrderId"],
                    );
                  }
                },
                child: Text(
                  "Update Status",
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  getonthelaod() async {
    OrderStream = await DatabaseMethodes().getAdminOrders();
    setState(() {});
  }

  @override
  void initState() {
    getonthelaod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: AppColors.surface,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Manage Orders",
                          style: AppTextStyles.heading.copyWith(
                            fontSize: 28,
                            color: AppColors.surface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 48), // Balance the back button
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
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 30,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.inventory_2_rounded,
                              color: AppColors.primary,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Order Management",
                              style: AppTextStyles.heading.copyWith(
                                fontSize: 24,
                                color: AppColors.onSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: allOrder()),
                    ],
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
