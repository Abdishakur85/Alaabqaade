// ... [IMPORTS REMAIN UNCHANGED]
import 'package:alaabqaade/constants/theme_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timelines_plus/timelines_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? id;
  bool search = false;
  String? matchedAddress;
  int? matchedTrackerId;
  TextEditingController searchcontroller = new TextEditingController();
  String currentAddress = "Fetching Location";

  Future<String?> getMatchingField(String userTrackerId) async {
    try {
      var userCollection = await FirebaseFirestore.instance
          .collection('user')
          .get();

      for (var userDoc in userCollection.docs) {
        var ordersSnapshot = await userDoc.reference
            .collection('Order')
            .where('Track', isEqualTo: userTrackerId.trim())
            .get();

        if (ordersSnapshot.docs.isNotEmpty) {
          var data = ordersSnapshot.docs.first.data();
          matchedAddress = data['DropeOffAddress'] ?? 'No Address Found';
          matchedTrackerId = data['Tracker'];
          return 'Track';
        }
      }
      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width / 4.6),
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 35,
                          ),
                          Text(
                            "Current Location",
                            style: AppTextStyles.subHeading.apply(
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Garowe,Nugaal,Somalia",
                        style: AppTextStyles.subHeading,
                      ),
                    ],
                  ),
                  Spacer(),
                  Image.asset(
                    "assets/avator.png",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20.0, right: 20),
                height: MediaQuery.of(context).size.height / 2.2,
                decoration: BoxDecoration(
                  color: AppColors.onePrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      "Track your Shipments",
                      style: AppTextStyles.heading.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      "Please enter your tracking number to get started",
                      style: AppTextStyles.description.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      height: 50,
                      margin: EdgeInsets.only(left: 20.0, right: 20),
                      decoration: BoxDecoration(
                        color: AppColors.onPrimary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: searchcontroller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your tracking number",
                          prefixIcon: Icon(
                            Icons.track_changes_outlined,
                            color: AppColors.primary,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              String? result = await getMatchingField(
                                searchcontroller.text,
                              );
                              if (result != null &&
                                  matchedAddress != null &&
                                  matchedTrackerId != null) {
                                setState(() {
                                  search = true;
                                });
                              } else {
                                setState(() {
                                  search = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Tracking number not found."),
                                  ),
                                );
                              }
                              print(matchedAddress);
                              print(matchedTrackerId);
                            },
                            child: Icon(Icons.search),
                          ),
                        ),
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.onSecondary,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Spacer(),
                    Image.asset("assets/only.png", height: 255),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              search
                  ? Container(
                      margin: EdgeInsets.only(left: 10, right: 25.0),
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
                                    matchedAddress ?? "No address",
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
                                        contentsAlign:
                                            ContentsAlign.alternating,
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
                                              style: AppTextStyles.body
                                                  .copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        },
                                        indicatorBuilder: (_, index) {
                                          if (index <=
                                              (matchedTrackerId ?? -1)) {
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
                                              color:
                                                  index <
                                                      (matchedTrackerId ?? 0)
                                                  ? AppColors.onSecondary
                                                  : AppColors.nav,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20.0, right: 20),
                          child: Material(
                            elevation: 3.5,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: AppColors.onPrimary,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColors.onSecondary.withAlpha(128),
                                  width: 2.0,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/car.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                  SizedBox(width: 10.0),
                                  Column(
                                    children: [
                                      Text(
                                        "Order a delivery",
                                        style: AppTextStyles.heading.copyWith(
                                          color: AppColors.onSecondary,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5.0),
                                        width:
                                            MediaQuery.of(context).size.width /
                                            2.0,
                                        child: Text(
                                          "Order a delivery service to get your items delivered to your doorstep.",
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.body.copyWith(
                                            color: AppColors.onSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          margin: EdgeInsets.only(left: 20.0, right: 20),
                          child: Material(
                            elevation: 3.5,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: AppColors.onPrimary,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColors.onSecondary.withAlpha(128),
                                  width: 2.0,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/box2.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                  SizedBox(width: 10.0),
                                  Column(
                                    children: [
                                      Text(
                                        "Track your packages",
                                        style: AppTextStyles.heading.copyWith(
                                          color: AppColors.onSecondary,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5.0),
                                        width:
                                            MediaQuery.of(context).size.width /
                                            2.0,
                                        child: Text(
                                          "Track your packages in real-time to know their status and location.",
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.body.copyWith(
                                            color: AppColors.onSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          margin: EdgeInsets.only(left: 20.0, right: 20),
                          child: Material(
                            elevation: 3.5,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 10.0,
                                top: 10.0,
                                bottom: 10.0,
                                right: 5,
                              ),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: AppColors.onPrimary,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColors.onSecondary.withAlpha(128),
                                  width: 2.0,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/updatedelivery-bike.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                  SizedBox(width: 10.0),
                                  Column(
                                    children: [
                                      Text(
                                        "check delivery status",
                                        style: AppTextStyles.heading.copyWith(
                                          color: AppColors.onSecondary,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5.0),
                                        width:
                                            MediaQuery.of(context).size.width /
                                            2.0,
                                        child: Text(
                                          "Check the status of your delivery to ensure it arrives on time and in good condition.",
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.body.copyWith(
                                            color: AppColors.onSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: 30.0),
            ],
          ),
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
