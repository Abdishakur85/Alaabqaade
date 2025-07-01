import 'package:alaabqaade/models/onboarding_model.dart';

class OnboardingItems {
  List<OnboardingInfo> items = [
    OnboardingInfo(
      title: "Track Your Packages",
      description:
          "Easily monitor the status of your deliveries in real time.Get instant updates from pickup to doorstep.Never lose sight of your package again.",
      image: 'assets/notebookbox.png',
    ),
    OnboardingInfo(
      title: "Real-Time Delivery Updates",
      description:
          "Know where your package is every step of the way.Track live status from pickup to delivery.Stay informed, stay stress-free.",
      image: 'assets/track.png',
    ),
    OnboardingInfo(
      title: "Track Anytime, Anywhere",

      description:
          "Access tracking details on the go.Mobile-friendly and easy to use.Your delivery info, always in your pocket.",

      image: 'assets/box.png',
    ),
  ];
  String _getStatusText(int index) {
    switch (index) {
      case 0:
        return "Order Placed";
      case 1:
        return "Preparing";
      case 2:
        return "On the way";
      case 3:
        return "Delivered";
      default:
        return "";
    }
  }
}
