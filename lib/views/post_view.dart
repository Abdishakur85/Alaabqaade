import 'package:alaabqaade/constants/razorapi.dart';
import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/models/database.dart';
import 'package:alaabqaade/models/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final TextEditingController pickupAddress = TextEditingController();
  final TextEditingController pickupusername = TextEditingController();
  final TextEditingController pickupnumber = TextEditingController();
  final TextEditingController dropoffaddress = TextEditingController();
  final TextEditingController dropoffusername = TextEditingController();
  final TextEditingController dropoffnumber = TextEditingController();
  String? email, id;

  gettheSharedPref() async {
    email = await SharedPref().getUserEmail();
    id = await SharedPref().getUserId();
    setState(() {});
  }

  ontheload() async {
    await gettheSharedPref();
    setState(() {});
  }

  late Razorpay _razorpay;
  int total = 0;

  @override
  void dispose() {
    _razorpay.clear(); // clear the razorpay instances
    super.dispose();
  }

  // ✅ Razorpay: USD version
  void openCheckout(String amount, String email) {
    int amountInCents = (double.parse(amount) * 100)
        .toInt(); // Convert dollars to cents
    var options = {
      'key': razorpayKey,
      'amount': amountInCents.toString(), // amount in cents (smallest unit)
      'currency': 'USD', // ✅ use USD
      'name': 'Alaab Qaade',
      'description': 'Pay \$$amount for package delivery',
      'prefill': {'email': email},
      'external': {
        'wallet': ['paytm'],
      },
      'theme': {'color': "#007BFF"},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error$e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String tracknumber = randomAlphaNumeric(10);
    String orderId = randomAlphaNumeric(10);
    Map<String, dynamic> userOrderMap = {
      "PickUpaddress": pickupAddress.text,
      "PickUpUsername": pickupusername.text,
      "pickUpNumber": pickupnumber.text,
      "DropeOffAddress": dropoffaddress.text,
      "DropeOffUsername": dropoffusername.text,
      "DropeOffNumber": dropoffnumber.text,
      "OrderId": orderId,
      "Track": tracknumber,
      "Tracker": -1,
      "UserId": id,
    };
    await DatabaseMethodes().addUserOrder(userOrderMap, id!, orderId);
    await DatabaseMethodes().addAdminOrder(userOrderMap, orderId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Order Placed Successfully", style: AppTextStyles.body),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failure: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
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
                          "assets/notebook.png",
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
                                    controller: pickupAddress,
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
                                    controller: pickupusername,
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
                                    controller: pickupnumber,
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
                                    controller: dropoffaddress,
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
                                    controller: dropoffusername,
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
                                    controller: dropoffnumber,
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
                                  "\$55",
                                  style: AppTextStyles.subHeading.copyWith(
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50),
                            GestureDetector(
                              onTap: () {
                                if (pickupAddress.text != "" &&
                                    pickupusername.text != "" &&
                                    pickupnumber.text != "") {
                                  openCheckout("550", email!);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        "Compulited all form fildies",
                                        style: AppTextStyles.body,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
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
