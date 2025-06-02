import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/data/onboarding_items.dart';
import 'package:alaabqaade/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();
  bool isListPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        margin: const EdgeInsets.all(15),
        child: isListPage
            ? getStarted(context)
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SKIP BUTTON
                  TextButton(
                    onPressed: () {
                      pageController.animateToPage(
                        controller.items.length - 1,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                      );
                    },
                    child: Text(
                      "Skip",
                      style: AppTextStyles.button.copyWith(
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                  // INDICATOR
                  SmoothPageIndicator(
                    controller: pageController,
                    count: controller.items.length,
                    onDotClicked: (index) => pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                    ),
                    effect: const ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Colors.purple,
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 20,
                    ),
                  ),

                  // NEXT BOTTON
                  TextButton(
                    onPressed: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                    ),
                    child: Text(
                      "Next",
                      style: AppTextStyles.button.copyWith(
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ],
              ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: PageView.builder(
          onPageChanged: (index) {
            setState(() {
              isListPage = index == controller.items.length - 1;
            });
          },
          itemCount: controller.items.length,
          controller: pageController,
          itemBuilder: (context, index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(controller.items[index].image, fit: BoxFit.cover),
              Text(
                controller.items[index].title,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                controller.items[index].description,
                textAlign: TextAlign.center,

                style: AppTextStyles.description,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget getStarted(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20.0),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(16.0),
    ),
    width: MediaQuery.of(context).size.width * 0.9,
    height: 55,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () async {
          final prefr = await SharedPreferences.getInstance();
          await prefr.setBool("Welcome To Home page", true);
          if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        },

        child: Text('Get Started', style: AppTextStyles.button),
      ),
    ),
  );
}
