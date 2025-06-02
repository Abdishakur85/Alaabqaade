import 'package:alaabqaade/constants/theme_data.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // waa containerka haya Profile ka
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 55),
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
              // waa contanaier ka Buluuga
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20.0, right: 20),
                height: MediaQuery.of(context).size.height / 2.2,
                decoration: BoxDecoration(
                  color: AppColors.primary,
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your tracking number",
                          prefixIcon: Icon(
                            Icons.track_changes_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.onSecondary,
                        ),
                      ),
                    ),
                    Spacer(),
                    Image.asset("assets/only.png", height: 255),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20),
                child: Material(
                  elevation: 3.5,
                  borderRadius: BorderRadius.circular(30),

                  child: Container(
                    width: MediaQuery.of(context).size.width,

                    padding: EdgeInsets.only(
                      left: 10.0,
                      top: 10.0,
                      bottom: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.onSecondary.withValues(alpha: 0.5),
                        width: 2.0,
                      ),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("assets/car.png", width: 100, height: 100),
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
                              width: MediaQuery.of(context).size.width / 2.0,
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
                    padding: EdgeInsets.only(
                      left: 10.0,
                      top: 10.0,
                      bottom: 10.0,
                      right: 10.0,
                    ),

                    decoration: BoxDecoration(
                      color: AppColors.onPrimary,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.onSecondary.withValues(alpha: 0.5),
                        width: 2.0,
                      ),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("assets/box2.png", width: 100, height: 100),
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
                              width: MediaQuery.of(context).size.width / 2.0,
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
                        color: AppColors.onSecondary.withValues(alpha: 0.5),
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
                              width: MediaQuery.of(context).size.width / 2.0,
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
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
