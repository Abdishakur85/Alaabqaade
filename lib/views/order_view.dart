import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/models/database.dart';
import 'package:alaabqaade/models/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id;
  bool curretOrder = true;
  bool pastOrder = false;
  int currentStep = 0;
  Stream? OrderStream;

  getontheload() async {
    id = await SharedPref().getUserId();
    OrderStream = await DatabaseMethodes().getUserOrder(id!);
    setState(() {});
    print(id);
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Widget allOrder() {
    return StreamBuilder(
      stream: OrderStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  currentStep = ds["Tracker"];

                  return Container(
                    margin: EdgeInsets.only(left: 10, right: 25),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.onePrimary,
                                  size: 30,
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  ds["DropeOffAddress"],
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/box2.png",
                                  height: 120,
                                  width: 120,
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
                                            top: 40.0,
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
                            SizedBox(height: 25.0),

                            // ❌ Removed: Container(child: allOrder()),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container();
      },
    );
  }

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
                                onTap: () async {
                                  curretOrder = true;
                                  pastOrder = false;
                                  OrderStream = await DatabaseMethodes()
                                      .getUserOrder(id!);
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
                                onTap: () async {
                                  pastOrder = true;
                                  curretOrder = false;
                                  OrderStream = await DatabaseMethodes()
                                      .getUserPastOrders(id!);
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
                    Container(
                      height: MediaQuery.of(context).size.height / 2.3,
                      child: allOrder(),
                    ),
                    SizedBox(height: 20.0),
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
        return "Order Placed ";
      case 1:
        return "Preparing Order";
      case 2:
        return "On the way to drop-off";
      case 3:
        return " Parcel delivered";
      default:
        return "";
    }
  }
}
