import 'package:alaabqaade/constants/theme_data.dart';

import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  bool curretOrder = true;
  bool pastOrder = false;
  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Center(child: Text("Orders", style: AppTextStyles.heading)),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        curretOrder
                            ? Material(
                                elevation: 5.0,
                                color: AppColors.navbackground,
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.nav,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/notebook.png",
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Current\nOrders",
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.body.copyWith(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  curretOrder = true;
                                  pastOrder = false;
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.nav,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/notebook.png",
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Current\nOrders",
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.body.copyWith(
                                          fontSize: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        pastOrder
                            ? Material(
                                elevation: 5.0,
                                color: AppColors.navbackground,
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.nav,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/notebook.png",
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Past\nOrders",
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.body.copyWith(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  pastOrder = true;
                                  curretOrder = false;
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.nav,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/notebook.png",
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Past\nOrders",
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.body.copyWith(
                                          fontSize: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,

                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppColors.primary,
                                size: 30,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                'Sodonka opposite Java cofee',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),

                          Row(
                            children: [
                              Image.asset(
                                "assets/box2.png",
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: FixedTimeline.tileBuilder(
                                  builder: TimelineTileBuilder.connected(
                                    contentsAlign: ContentsAlign.alternating,
                                    connectionDirection:
                                        ConnectionDirection.before,
                                    itemCount: 4,

                                    contentsBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 60.0,
                                        ),
                                        child: Text(
                                          _getStatusText(index),
                                          style: AppTextStyles.body.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                    indicatorBuilder: (_, index) {
                                      if (index <= currentStep) {
                                        return DotIndicator(
                                          color: AppColors.primary,
                                          child: Icon(
                                            Icons.check,
                                            color: AppColors.surface,
                                            size: 24.0,
                                          ),
                                        );
                                      } else {
                                        return OutlinedDotIndicator(
                                          borderWidth: 3.0,
                                          size: 25.0,
                                        );
                                      }
                                    },
                                    connectorBuilder: (_, index, ___) =>
                                        SolidLineConnector(
                                          color: index < currentStep
                                              ? AppColors.onSecondary
                                              : AppColors.nav,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(int index) {
    switch (index) {
      case 0:
        return "Order Placed";
      case 1:
        return "Preparing";
      case 2:
        return "On the way";
      case 3:
        return "Delivered";
      default:
        return "";
    }
  }
}
