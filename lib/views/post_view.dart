import 'package:alaabqaade/constants/theme_data.dart';
import 'package:flutter/material.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        margin: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Center(
              child: Text(
                "Packages Posting Form",
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10),

                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/package-truck.png",
                          height: 180,
                          width: 180,
                        ),
                      ),

                      SizedBox(height: 50.0),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.onSurface,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pick up Information",
                              style: AppTextStyles.subHeading,
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                  size: 30.0,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Enter Pick up Address",
                                      hintStyle: AppTextStyles.body.copyWith(
                                        fontSize: 16,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.onSecondary
                                              .withAlpha(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: 30.0,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Enter your full name",
                                      hintStyle: AppTextStyles.body.copyWith(
                                        fontSize: 16,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.onSecondary
                                              .withAlpha(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: AppColors.primary,
                                  size: 30.0,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Enter your phone",
                                      hintStyle: AppTextStyles.body.copyWith(
                                        fontSize: 16,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.onSecondary
                                              .withAlpha(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.0),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.onSurface,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Drop off details",
                              style: AppTextStyles.subHeading,
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                  size: 30.0,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Enter drop off Address",
                                      hintStyle: AppTextStyles.body.copyWith(
                                        fontSize: 16,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.onSecondary
                                              .withAlpha(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: 30.0,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Enter your full name",
                                      hintStyle: AppTextStyles.body.copyWith(
                                        fontSize: 16,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.onSecondary
                                              .withAlpha(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: AppColors.primary,
                                  size: 30.0,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Enter your phone",
                                      hintStyle: AppTextStyles.body.copyWith(
                                        fontSize: 16,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.onSecondary
                                              .withAlpha(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),

                      Container(
                        padding: EdgeInsets.only(
                          left: 30,
                          right: 10,
                          top: 10,
                          bottom: 10.0,
                        ),
                        margin: EdgeInsets.only(right: 20.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.onSurface,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Total Price",
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "\$80",
                                  style: AppTextStyles.subHeading.copyWith(
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              height: 60,
                              width: 200,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Center(
                                child: Text(
                                  "Place Order",
                                  style: AppTextStyles.button.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
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
