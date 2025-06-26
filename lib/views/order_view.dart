import 'package:alaabqaade/constants/theme_data.dart';
import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  bool curretOrder = true;
  bool pastOrder = false;
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
                    Container(
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
}
