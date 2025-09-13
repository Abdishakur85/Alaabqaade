import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/models/database.dart';
import 'package:alaabqaade/models/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id;
  bool currentOrder = true;
  bool pastOrder = false;
  int currentStep = 0;
  bool showCompletionDialog = false;
  Set<String> completedOrderIds =
      {}; // Track which orders have shown completion dialog
  String? lastCompletedOrderId;
  Map<String, int> orderTrackerStates = {}; // Track previous tracker states
  bool isNavigating = false; // Flag to prevent dialog during navigation

  getOnTheLoad() async {
    try {
      id = await SharedPref().getUserId();
      if (id != null) {
        OrderStream = await DatabaseMethodes().getUserOrder(id!);
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print('Error loading orders: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading orders: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  Stream? OrderStream;

  Widget allOrder() {
    return StreamBuilder(
      stream: OrderStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  currentStep = ds["Tracker"];
                  String orderId = ds.id;

                  // Check if order just completed (tracker changed from < 3 to 3)
                  int previousTracker = orderTrackerStates[orderId] ?? 0;
                  orderTrackerStates[orderId] = currentStep;

                  if (currentStep == 3 &&
                      previousTracker < 3 &&
                      !completedOrderIds.contains(orderId)) {
                    completedOrderIds.add(orderId);
                    lastCompletedOrderId = orderId;

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted && ds.exists) {
                        // Ensure we're showing the correct order that just completed
                        _showOrderCompletionDialog(context, ds);
                      }
                    });
                  }

                  return _buildModernOrderCard(ds, currentStep);
                },
              )
            : Center(
                child: Text(
                  "No orders found",
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              );
      },
    );
  }

  Widget _buildModernOrderCard(DocumentSnapshot ds, int currentStep) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with location and status
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_shipping,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery Address",
                      style: AppTextStyles.body.copyWith(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      ds["DropeOffAddress"],
                      style: AppTextStyles.body.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(currentStep),
            ],
          ),

          SizedBox(height: 24),

          // Progress Timeline
          _buildSimpleTimeline(currentStep),

          // Show completion message if order is completed
          if (currentStep == 3 && currentOrder) ...[
            SizedBox(height: 20),
            _buildCompletionBanner(context),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(int step) {
    String status;
    Color color;

    switch (step) {
      case 0:
        status = "Placed";
        color = Colors.orange;
        break;
      case 1:
        status = "Preparing";
        color = Colors.blue;
        break;
      case 2:
        status = "In Transit";
        color = Colors.purple;
        break;
      case 3:
        status = "Delivered";
        color = Colors.green;
        break;
      default:
        status = "Unknown";
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: AppTextStyles.body.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSimpleTimeline(int currentStep) {
    List<String> steps = [
      "Order Placed",
      "Preparing Order",
      "On the way",
      "Delivered",
    ];

    return Column(
      children: [
        Row(
          children: List.generate(4, (index) {
            bool isCompleted = index <= currentStep;
            bool isActive = index == currentStep;

            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.primary : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isCompleted
                        ? Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                  if (index < 3)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted && index < currentStep
                            ? AppColors.primary
                            : Colors.grey[300],
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: 8),
        Row(
          children: List.generate(4, (index) {
            bool isActive = index == currentStep;
            return Expanded(
              child: Text(
                steps[index],
                style: AppTextStyles.body.copyWith(
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive ? AppColors.primary : Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                  "Orders",
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Tab Container with elevated styling
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      "Current Orders",
                      currentOrder,
                      () async {
                        if (currentOrder) return;

                        try {
                          isNavigating = true;
                          currentOrder = true;
                          pastOrder = false;

                          completedOrderIds.clear();
                          lastCompletedOrderId = null;
                          orderTrackerStates.clear();

                          if (id != null) {
                            OrderStream = await DatabaseMethodes().getUserOrder(
                              id!,
                            );
                            if (mounted) {
                              setState(() {});
                            }
                          }

                          Future.delayed(Duration(seconds: 2), () {
                            isNavigating = false;
                          });
                        } catch (e) {
                          print('Error loading current orders: $e');
                          isNavigating = false;
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildTabButton("Past Orders", pastOrder, () async {
                      if (pastOrder) return;

                      try {
                        isNavigating = true;
                        pastOrder = true;
                        currentOrder = false;

                        if (id != null) {
                          OrderStream = await DatabaseMethodes()
                              .getUserPastOrders(id!);
                          if (mounted) {
                            setState(() {});
                          }
                        }

                        Future.delayed(Duration(milliseconds: 100), () {
                          isNavigating = false;
                        });

                        Future.delayed(Duration(milliseconds: 500), () async {
                          if (mounted) {
                            _showRecentCompletionDialog();
                          }
                        });
                      } catch (e) {
                        print('Error loading past orders: $e');
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red[400],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              content: Text('Error loading past orders'),
                            ),
                          );
                        }
                        isNavigating = false;
                      }
                    }),
                  ),
                ],
              ),
            ),

            // Orders List with rounded top corners
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
                  child: StreamBuilder(
                    stream: OrderStream,
                    builder: (context, AsyncSnapshot snapshot) {
                      return snapshot.hasData
                          ? ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds = snapshot.data.docs[index];
                                currentStep = ds["Tracker"];
                                String orderId = ds.id;

                                // Check if order just completed (tracker changed from < 3 to 3)
                                int previousTracker =
                                    orderTrackerStates[orderId] ?? 0;
                                orderTrackerStates[orderId] = currentStep;

                                if (currentStep == 3 &&
                                    previousTracker < 3 &&
                                    !completedOrderIds.contains(orderId)) {
                                  completedOrderIds.add(orderId);
                                  lastCompletedOrderId = orderId;

                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (mounted && ds.exists) {
                                      // Ensure we're showing the correct order that just completed
                                      _showOrderCompletionDialog(context, ds);
                                    }
                                  });
                                }

                                return _buildModernOrderCard(ds, currentStep);
                              },
                            )
                          : Center(
                              child: Text(
                                "No orders found",
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppColors.primary : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionBanner(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.check_circle,
              color: AppColors.onPrimary,
              size: 30,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🎉 Order Delivered!",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Your order has reached its destination",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.onPrimary.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderCompletionDialog(
    BuildContext context,
    DocumentSnapshot order,
  ) {
    if (showCompletionDialog || !mounted) return; // Prevent multiple dialogs
    showCompletionDialog = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [AppColors.surface, AppColors.form],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.local_shipping,
                    color: AppColors.onPrimary,
                    size: 40,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "🎉 Delivery Complete!",
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 24,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Your Order Progress Reached Destination",
                        style: AppTextStyles.subHeading.copyWith(
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Delivered to: ${order["DropeOffAddress"] ?? "Unknown Address"}",
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14,
                          color: AppColors.onSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (mounted) {
                            Navigator.of(context).pop();
                            showCompletionDialog = false;
                            // Refresh current orders to remove completed order
                            _refreshCurrentOrders();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.nav.withOpacity(0.1),
                          foregroundColor: AppColors.nav,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Close",
                          style: AppTextStyles.button.copyWith(
                            fontSize: 16,
                            color: AppColors.nav,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (mounted) {
                            Navigator.of(context).pop();
                            showCompletionDialog = false;
                            // Switch to past orders view
                            pastOrder = true;
                            currentOrder = false;
                            try {
                              if (id != null) {
                                OrderStream = await DatabaseMethodes()
                                    .getUserPastOrders(id!);
                                if (mounted) {
                                  setState(() {});
                                }
                              }
                              // Refresh current orders to remove completed order
                              _refreshCurrentOrders();
                            } catch (e) {
                              print('Error switching to past orders: $e');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "View Past Orders",
                          style: AppTextStyles.button.copyWith(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    // Auto-dismiss dialog after 24 hours
    Future.delayed(Duration(hours: 24), () {
      if (mounted && showCompletionDialog && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
        showCompletionDialog = false;
      }
    });
  }

  void _showRecentCompletionDialog() async {
    if (showCompletionDialog || isNavigating || !mounted || id == null) return;

    try {
      // Get the most recent completed order
      var pastOrdersSnapshot = await FirebaseFirestore.instance
          .collection("user")
          .doc(id!)
          .collection("Order")
          .where("Tracker", isEqualTo: 3)
          .orderBy(FieldPath.documentId, descending: true)
          .limit(1)
          .get();

      if (pastOrdersSnapshot.docs.isNotEmpty && mounted) {
        DocumentSnapshot recentOrder = pastOrdersSnapshot.docs.first;
        _showOrderCompletionDialog(context, recentOrder);
      }
    } catch (e) {
      print('Error showing recent completion dialog: $e');
    }
  }

  void _refreshCurrentOrders() async {
    if (currentOrder && id != null) {
      try {
        OrderStream = await DatabaseMethodes().getUserOrder(id!);
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        print('Error refreshing current orders: $e');
      }
    }
  }
}
