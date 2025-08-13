import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/models/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];

                  return ds["Tracker"] == 3
                      ? Container()
                      : Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(30),

                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20.0),
                                Center(
                                  child: Image.asset(
                                    "assets/box2.png",
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  "Drope-Off Information",
                                  style: AppTextStyles.heading.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Address:  " + ds["DropeOffAddress"],
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Name:  " + ds["DropeOffUsername"],
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Phone:  " + ds["DropeOffNumber"],
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  "Pickup Infomation",
                                  style: AppTextStyles.heading.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Address:  " + ds["PickUpaddress"],
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Name:  " + ds["PickUpUsername"],

                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Phone:  " + ds["pickUpNumber"],
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                ds["Tracker"] >= 0
                                    ? Material(
                                        elevation: 3.0,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 10.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.onePrimary,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.navbackground,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Icon(
                                                  Icons.done,
                                                  color: AppColors.onePrimary,
                                                ),
                                              ),
                                              SizedBox(width: 5.0),
                                              Container(
                                                padding: EdgeInsets.all(10.0),
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width /
                                                    1.5,
                                                child: Text(
                                                  "Order Placed",
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles.body
                                                      .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          if (ds["Tracker"] == -1) {
                                            int updatedtracker = ds["Tracker"];
                                            updatedtracker = updatedtracker + 1;
                                            await DatabaseMethodes()
                                                .updateAdminTracker(
                                                  ds.id,
                                                  updatedtracker,
                                                );
                                            await DatabaseMethodes()
                                                .updateUserTracker(
                                                  ds["UserId"],
                                                  updatedtracker,
                                                  ds["OrderId"],
                                                );
                                          }
                                        },
                                        child: Center(
                                          child: Container(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                1.5,
                                            padding: EdgeInsets.all(20.0),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              "Order Placed",
                                              textAlign: TextAlign.center,
                                              style: AppTextStyles.body
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(height: 20.0),
                                ds["Tracker"] >= 1
                                    ? Material(
                                        elevation: 3.0,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 10.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.onePrimary,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.navbackground,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Icon(
                                                  Icons.done,
                                                  color: AppColors.onePrimary,
                                                ),
                                              ),
                                              SizedBox(width: 5.0),
                                              Container(
                                                padding: EdgeInsets.all(10.0),
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width /
                                                    1.5,
                                                child: Text(
                                                  "Preparing Order",
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles.body
                                                      .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          if (ds["Tracker"] == 0) {
                                            int updatedtracker = ds["Tracker"];
                                            updatedtracker = updatedtracker + 1;
                                            // Update the tracker in the admin orders
                                            await DatabaseMethodes()
                                                .updateAdminTracker(
                                                  ds.id,
                                                  updatedtracker,
                                                );
                                            // Update the tracker in the user orders
                                            await DatabaseMethodes()
                                                .updateUserTracker(
                                                  ds["UserId"],
                                                  updatedtracker,
                                                  ds["OrderId"],
                                                );
                                          }
                                        },
                                        child: Center(
                                          child: Container(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                1.5,
                                            padding: EdgeInsets.all(20.0),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              "Preparing Order",
                                              textAlign: TextAlign.center,
                                              style: AppTextStyles.body
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),

                                SizedBox(height: 20.0),
                                ds["Tracker"] >= 2
                                    ? Material(
                                        elevation: 3.0,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 10.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.onePrimary,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.navbackground,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Icon(
                                                  Icons.done,
                                                  color: AppColors.onePrimary,
                                                ),
                                              ),
                                              SizedBox(width: 5.0),
                                              Container(
                                                padding: EdgeInsets.all(10.0),
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width /
                                                    1.5,
                                                child: Text(
                                                  "On the way to Drope-Off",
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles.body
                                                      .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          if (ds["Tracker"] == 1) {
                                            int updatedtracker = ds["Tracker"];
                                            updatedtracker = updatedtracker + 1;
                                            // Update the tracker in the admin orders
                                            await DatabaseMethodes()
                                                .updateAdminTracker(
                                                  ds.id,
                                                  updatedtracker,
                                                );
                                            // Update the tracker in the user orders
                                            await DatabaseMethodes()
                                                .updateUserTracker(
                                                  ds["UserId"],
                                                  updatedtracker,
                                                  ds["OrderId"],
                                                );
                                          }
                                        },
                                        child: Center(
                                          child: Container(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                1.5,
                                            padding: EdgeInsets.all(16.0),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              "On the way to Drope-Off",
                                              textAlign: TextAlign.center,
                                              style: AppTextStyles.body
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(height: 20.0),
                                SizedBox(height: 20.0),
                                ds["Tracker"] >= 3
                                    ? Material(
                                        elevation: 3.0,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 10.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.onePrimary,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.navbackground,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Icon(
                                                  Icons.done,
                                                  color: AppColors.onePrimary,
                                                ),
                                              ),
                                              SizedBox(width: 5.0),
                                              Container(
                                                padding: EdgeInsets.all(10.0),
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width /
                                                    1.5,
                                                child: Text(
                                                  "On the way to Drope-Off",
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles.body
                                                      .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          if (ds["Tracker"] == 2) {
                                            int updatedtracker = ds["Tracker"];
                                            updatedtracker = updatedtracker + 1;
                                            // Update the tracker in the admin orders
                                            await DatabaseMethodes()
                                                .updateAdminTracker(
                                                  ds.id,
                                                  updatedtracker,
                                                );
                                            // Update the tracker in the user orders
                                            await DatabaseMethodes()
                                                .updateUserTracker(
                                                  ds["UserId"],
                                                  updatedtracker,
                                                  ds["OrderId"],
                                                );
                                          }
                                        },
                                        child: Center(
                                          child: Container(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                1.5,
                                            padding: EdgeInsets.all(20.0),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              " Parcel delivered",
                                              textAlign: TextAlign.center,
                                              style: AppTextStyles.body
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),

                                SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        );
                },
              )
            : Container();
      },
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
      backgroundColor: AppColors.secondary,
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(30),
                      ),

                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.secondary,
                        size: 30.0,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 8),
                  Center(
                    child: Text(
                      "Manage Orders",

                      style: AppTextStyles.heading.copyWith(fontSize: 30),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                // child: SingleChildScrollView(
                //   child: Column(children: [SizedBox(height: 20.0), allOrder()]),
                // ),
                child: Container(height: 500, child: allOrder()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
