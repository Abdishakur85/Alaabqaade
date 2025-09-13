import 'package:alaabqaade/constants/razorapi.dart';
import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/models/database.dart';
import 'package:alaabqaade/models/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:ui';

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
    _clearForm();
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

  String? _validateAddress(String value) {
    if (value.isEmpty) {
      return "Address is required";
    }
    if (!RegExp(r'^[a-zA-Z]').hasMatch(value)) {
      return "Address must start with a letter";
    }
    return null;
  }

  String? _validateName(String value) {
    if (value.isEmpty) {
      return "Name is required";
    }
    if (!RegExp(r'^[a-zA-Z]').hasMatch(value)) {
      return "Name must start with a letter";
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return "Name can only contain letters and spaces";
    }
    return null;
  }

  String? _validatePhone(String value) {
    if (value.isEmpty) {
      return "Phone number is required";
    }
    
    // Remove any whitespace
    String cleanValue = value.trim();
    
    // Check if it starts with + (optional international format)
    if (cleanValue.startsWith('+')) {
      // For international format: +[country code][number]
      String numberPart = cleanValue.substring(1);
      if (!RegExp(r'^[0-9]+$').hasMatch(numberPart)) {
        return "Phone number can only contain + and numbers";
      }
      if (numberPart.length < 10) {
        return "Phone number must be at least 10 digits after country code";
      }
    } else {
      // For local format: just numbers
      if (!RegExp(r'^[0-9]+$').hasMatch(cleanValue)) {
        return "Phone number can only contain numbers (or + for international)";
      }
      if (cleanValue.length < 10) {
        return "Phone number must be at least 10 digits";
      }
    }
    
    return null;
  }

  bool _validateForm() {
    List<String> errors = [];

    // Validate pickup address
    String? pickupAddressError = _validateAddress(pickupAddress.text.trim());
    if (pickupAddressError != null) errors.add("Pickup: $pickupAddressError");

    // Validate pickup name
    String? pickupNameError = _validateName(pickupusername.text.trim());
    if (pickupNameError != null) errors.add("Pickup: $pickupNameError");

    // Validate pickup phone
    String? pickupPhoneError = _validatePhone(pickupnumber.text.trim());
    if (pickupPhoneError != null) errors.add("Pickup: $pickupPhoneError");

    // Validate dropoff address
    String? dropoffAddressError = _validateAddress(dropoffaddress.text.trim());
    if (dropoffAddressError != null)
      errors.add("Dropoff: $dropoffAddressError");

    // Validate dropoff name
    String? dropoffNameError = _validateName(dropoffusername.text.trim());
    if (dropoffNameError != null) errors.add("Dropoff: $dropoffNameError");

    // Validate dropoff phone
    String? dropoffPhoneError = _validatePhone(dropoffnumber.text.trim());
    if (dropoffPhoneError != null) errors.add("Dropoff: $dropoffPhoneError");

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please fix the following errors:",
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              ...errors.map(
                (error) => Text(
                  "• $error",
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          duration: Duration(seconds: 5),
        ),
      );
      return false;
    }
    return true;
  }

  void _clearForm() {
    pickupAddress.clear();
    pickupusername.clear();
    pickupnumber.clear();
    dropoffaddress.clear();
    dropoffusername.clear();
    dropoffnumber.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          ),
        ),
        child: Column(
          children: [
            // Custom AppBar with gradient
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(
                  "Packages Posting Form",
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Main Content with rounded top corners
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(height: 16),

                      // Header Image
                      Container(
                        width: 120,
                        height: 120,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(
                          "assets/notebook.png",
                          fit: BoxFit.contain,
                        ),
                      ),

                      SizedBox(height: 32),

                      // Pickup Information Card
                      _buildModernFormCard(
                        title: "Pick up Information",
                        icon: Icons.location_on,
                        color: AppColors.primary,
                        children: [
                          _buildModernTextField(
                            controller: pickupAddress,
                            hint: "Enter Pick up Address",
                            icon: Icons.location_on,
                            iconColor: AppColors.primary,
                          ),
                          SizedBox(height: 16),
                          _buildModernTextField(
                            controller: pickupusername,
                            hint: "Enter your full name",
                            icon: Icons.person,
                            iconColor: AppColors.primary,
                          ),
                          SizedBox(height: 16),
                          _buildModernTextField(
                            controller: pickupnumber,
                            hint: "Enter your phone",
                            icon: Icons.phone,
                            iconColor: AppColors.primary,
                          ),
                        ],
                      ),

                      SizedBox(height: 24),

                      // Drop off Information Card
                      _buildModernFormCard(
                        title: "Drop off details",
                        icon: Icons.local_shipping,
                        color: AppColors.primary,
                        children: [
                          _buildModernTextField(
                            controller: dropoffaddress,
                            hint: "Enter drop off Address",
                            icon: Icons.location_on,
                            iconColor: AppColors.primary,
                          ),
                          SizedBox(height: 16),
                          _buildModernTextField(
                            controller: dropoffusername,
                            hint: "Enter your full name",
                            icon: Icons.person,
                            iconColor: AppColors.primary,
                          ),
                          SizedBox(height: 16),
                          _buildModernTextField(
                            controller: dropoffnumber,
                            hint: "Enter your phone",
                            icon: Icons.phone,
                            iconColor: AppColors.primary,
                          ),
                        ],
                      ),

                      SizedBox(height: 32),

                      // Total Price and Place Order
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total Price",
                                        style: AppTextStyles.body.copyWith(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "\$2",
                                        style: AppTextStyles.heading.copyWith(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            // Full width button
                            _buildModernButton(),
                          ],
                        ),
                      ),

                      SizedBox(height: 32),
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

  Widget _buildModernFormCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.body.copyWith(
          fontSize: 16,
          color: Colors.grey[800],
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.body.copyWith(
            fontSize: 16,
            color: Colors.grey[500],
          ),
          prefixIcon: Icon(icon, color: iconColor, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildModernButton() {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          if (_validateForm()) {
            openCheckout("3", email!);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "Place Order",
              style: AppTextStyles.button.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
