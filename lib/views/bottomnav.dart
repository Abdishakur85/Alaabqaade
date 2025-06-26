import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/home.dart';
import 'package:alaabqaade/views/order_view.dart';
import 'package:alaabqaade/views/post_view.dart';
import 'package:alaabqaade/views/profile_view.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> views;
  late Home homeView;
  late Order order;
  late Profile profileView;
  late PostView postPage;
  int currentIndex = 0;

  @override
  void initState() {
    homeView = Home();
    order = Order();
    profileView = Profile();
    postPage = PostView();
    views = [homeView, postPage, order, profileView];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 70,
        backgroundColor: AppColors.navbackground,
        color: AppColors.secondary,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          Icon(Icons.home, color: AppColors.navbackground, size: 34),
          Icon(Icons.post_add, color: AppColors.navbackground, size: 34),
          Icon(Icons.shopping_bag, color: AppColors.navbackground, size: 34),
          Icon(Icons.person, color: AppColors.navbackground, size: 34),
        ],
      ),
      body: views[currentIndex],
    );
  }
}
