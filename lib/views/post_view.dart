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
                    SizedBox(height: 20.0),
                    Text(
                      "Add your package details",
                      style: AppTextStyles.heading.copyWith(),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Pick Up",
                      style: AppTextStyles.body.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: AppColors.form,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter pick up location",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Drop Off",
                      style: AppTextStyles.body.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: AppColors.form,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter drop off  location",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.9,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Submit Location",
                            style: AppTextStyles.button.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onPrimary,
                            ),
                          ),
                        ),
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
