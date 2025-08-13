import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/models/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  getontheload() async {
    userStream = await DatabaseMethodes().getAllUsers();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Stream? userStream;

  Widget allUsers() {
    return StreamBuilder(
      stream: userStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];

                  return Container(
                    padding: EdgeInsets.all(5.0),
                    margin: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      bottom: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.navbackground,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/profile.jpg",
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_2_rounded,
                                  color: AppColors.onePrimary,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  ds["Name"],
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.secondary,
                                    fontSize: 20,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: [
                                Icon(Icons.mail, color: AppColors.onePrimary),
                                SizedBox(width: 5.0),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.0,
                                  child: Text(
                                    ds["Email"],
                                    style: AppTextStyles.body.copyWith(
                                      color: AppColors.secondary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            GestureDetector(
                              onTap: () async {
                                await DatabaseMethodes().deleteUser(ds.id);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Remove",
                                  style: AppTextStyles.button.copyWith(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
      backgroundColor: AppColors.onePrimary,
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            SizedBox(height: 30.0),
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
                      "Manage Users",

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
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30.0),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: allUsers(),
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
