import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/data/onboarding_items.dart';
import 'package:alaabqaade/views/bottomnav.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();
  bool isLastPage = false;
  bool _imagesPreloaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ Safe context access for precaching
    if (!_imagesPreloaded) {
      for (var item in controller.items) {
        precacheImage(AssetImage(item.image), context);
      }
      _imagesPreloaded = true;
    }
  }

  void _completeOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNav()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        margin: const EdgeInsets.all(15),
        child: isLastPage
            ? getStarted(context, _completeOnboarding)
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SKIP BUTTON
                  TextButton(
                    onPressed: () {
                      pageController.animateToPage(
                        controller.items.length - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      "Skip",
                      style: AppTextStyles.button.copyWith(
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),

                  // PAGE INDICATOR
                  SmoothPageIndicator(
                    controller: pageController,
                    count: controller.items.length,
                    onDotClicked: (index) => pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    effect: const ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Colors.purple,
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 20,
                    ),
                  ),

                  // NEXT BUTTON
                  TextButton(
                    onPressed: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
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
          controller: pageController,
          itemCount: controller.items.length,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == controller.items.length - 1;
            });
          },
          itemBuilder: (context, index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                controller.items[index].image,
                fit: BoxFit.cover,
                cacheHeight: 300,
              ),
              const SizedBox(height: 30),
              Text(
                controller.items[index].title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
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

Widget getStarted(BuildContext context, VoidCallback onPressed) {
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
        onPressed: onPressed,
        child: Text('Get Started', style: AppTextStyles.button),
      ),
    ),
  );
}
