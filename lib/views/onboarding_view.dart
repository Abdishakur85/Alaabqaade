import 'package:alaabqaade/auth/login_view.dart';
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

    // Safe context access for precaching
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
      MaterialPageRoute(builder: (context) => LogIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header with Skip Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isLastPage)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              pageController.animateToPage(
                                controller.items.length - 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Text(
                                "Skip",
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.surface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Content Area
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Page Content
                      Expanded(
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: controller.items.length,
                          onPageChanged: (index) {
                            setState(() {
                              isLastPage = index == controller.items.length - 1;
                            });
                          },
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 40,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Modern Image Container
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(
                                        0.05,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(
                                          0.1,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                    child: Image.asset(
                                      controller.items[index].image,
                                      fit: BoxFit.contain,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.25,
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.6,
                                    ),
                                  ),
                                  SizedBox(height: 30),

                                  // Modern Title
                                  Text(
                                    controller.items[index].title,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.heading.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 16),

                                  // Modern Description
                                  Text(
                                    controller.items[index].description,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.body.copyWith(
                                      fontSize: 15,
                                      color: AppColors.onSecondary.withOpacity(
                                        0.8,
                                      ),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Bottom Navigation Area
                      Container(
                        padding: EdgeInsets.all(25),
                        child: Column(
                          children: [
                            // Modern Page Indicator
                            SmoothPageIndicator(
                              controller: pageController,
                              count: controller.items.length,
                              onDotClicked: (index) =>
                                  pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  ),
                              effect: ExpandingDotsEffect(
                                dotColor: AppColors.primary.withOpacity(0.3),
                                activeDotColor: AppColors.primary,
                                dotHeight: 12,
                                dotWidth: 12,
                                spacing: 8,
                                expansionFactor: 3,
                              ),
                            ),
                            SizedBox(height: 30),

                            // Navigation Buttons
                            if (isLastPage)
                              _buildGetStartedButton(context)
                            else
                              _buildNextButton(),
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
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Next",
                  style: AppTextStyles.button.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onPrimary,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.onPrimary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _completeOnboarding,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.rocket_launch_rounded,
                  color: AppColors.onPrimary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "Get Started",
                  style: AppTextStyles.button.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onPrimary,
                  ),
                ),
              ],
            ),
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
