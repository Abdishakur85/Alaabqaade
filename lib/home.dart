import 'package:alaabqaade/constants/theme_data.dart';
import 'package:alaabqaade/models/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timelines_plus/timelines_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? id;
  bool search = false;
  String? matchedAddress;
  int? matchedTrackerId;
  TextEditingController searchcontroller = new TextEditingController();
  String currentAddress = "Fetching Location";
  Position? currentPosition;
  @override
  void initState() {
    super.initState();
    getLocation();
    ontheload();
  }

  // A Future function that returns a String (nullable), used to get a matching field from Firestore
  Future<String?> getMatchingField(String userTrackerId) async {
    try {
      // Fetch the entire 'user' collection from Firestore
      var userCollection = await FirebaseFirestore.instance
          .collection('user')
          .get();

      // Loop through each document (user) in the collection
      for (var userDoc in userCollection.docs) {
        // For each user, access their 'Order' subcollection
        // and search for an order where the 'Track' field matches the given tracker ID
        var ordersSnapshot = await userDoc.reference
            .collection('Order')
            .where(
              'Track',
              isEqualTo: userTrackerId.trim(),
            ) // remove extra spaces
            .get();

        // Check if any matching orders were found
        if (ordersSnapshot.docs.isNotEmpty) {
          // Get the data of the first matching order document
          var data = ordersSnapshot.docs.first.data();

          // Save the drop-off address to the matchedAddress variable (if available)
          matchedAddress = data['DropeOffAddress'] ?? 'No Address Found';

          // Save the tracker ID to the matchedTrackerId variable
          matchedTrackerId = data['Tracker'];

          // Return the string 'Track' to indicate a match was found
          return 'Track';
        }
      }

      // If no matching tracker ID is found, return null
      return null;
    } catch (e) {
      // Log any error that occurs during the process
      debugPrint("Error: $e");
      return null; // Return null if an error occurs
    }
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        setState(() {
          currentAddress = "Location services are disabled";
        });
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() {
            currentAddress = "Location permissions are denied";
          });
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() {
          currentAddress = "Location permissions are permanently denied";
        });
      }
      return;
    }

    // If permissions are granted, get the position
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    if (mounted) {
      setState(() {
        currentPosition = position;
      });
    }

    _getAddressFromLatLng(position); // ✅ Separated for clarity
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place =
          placemarks.first; // ✅ Changed from [0] to .first (safer)

      if (mounted) {
        setState(() {
          currentAddress = // ✅ Cleaned up formatting
              "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          currentAddress = "Unable to get address";
        });
      }
    }
  }

  Future<void> getthesharedpref() async {
    id = await SharedPref().getUserId();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> ontheload() async {
    await getthesharedpref();
  }

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              // Modern Header with Gradient Background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.onePrimary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Location Section with Modern Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.location_on_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Current Location",
                                    style: AppTextStyles.subHeading.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  currentAddress,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Track Shipments Title
                        Text(
                          "Track your Shipments",
                          style: AppTextStyles.heading.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          "Enter your tracking number to get started",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.description.copyWith(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // Modern Search Section
              Transform.translate(
                offset: Offset(0, -40),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 30,
                        offset: Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Modern Search Field
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.form,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: searchcontroller,
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16,
                            color: AppColors.onSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter your tracking number",
                            hintStyle: AppTextStyles.body.copyWith(
                              fontSize: 16,
                              color: AppColors.onSecondary.withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Container(
                              margin: EdgeInsets.all(12),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.track_changes_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            suffixIcon: Container(
                              margin: EdgeInsets.all(8),
                              child: Material(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () async {
                                    final scaffoldMessenger =
                                        ScaffoldMessenger.of(context);
                                    String? result = await getMatchingField(
                                      searchcontroller.text,
                                    );
                                    if (mounted) {
                                      if (result != null &&
                                          matchedAddress != null &&
                                          matchedTrackerId != null) {
                                        setState(() {
                                          search = true;
                                        });
                                      } else {
                                        setState(() {
                                          search = false;
                                        });
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(
                                            backgroundColor: AppColors.error,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            content: Text(
                                              "Tracking number not found.",
                                              textAlign: TextAlign.center,
                                              style: AppTextStyles.body
                                                  .copyWith(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    child: Icon(
                                      Icons.search_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Illustration
                      Container(
                        height: 180,
                        child: Image.asset(
                          "assets/only.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Results or Service Cards
              search
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          // Modern Tracking Card with Glassmorphism
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 30,
                                  offset: Offset(0, 15),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.8),
                                  blurRadius: 10,
                                  offset: Offset(0, -5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Header with delivery truck icon and address
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.local_shipping_rounded,
                                        color: AppColors.primary,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Delivery Address",
                                            style: AppTextStyles.body.copyWith(
                                              fontSize: 14,
                                              color: AppColors.onSecondary
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            matchedAddress ?? "No address",
                                            style: AppTextStyles.subHeading
                                                .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.onSecondary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                          matchedTrackerId ?? 0,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _getStatusLabel(matchedTrackerId ?? 0),
                                        style: AppTextStyles.body.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _getStatusColor(
                                            matchedTrackerId ?? 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 24),

                                // Centered Package Image
                                Container(
                                  width: 200,
                                  height: 200,
                                  padding: EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: AppColors.form,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Image.asset(
                                    "assets/box2.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Modern Service Cards
                        _buildModernServiceCard(
                          title: "Order a delivery",
                          description:
                              "Order a delivery service to get your items delivered to your doorstep.",
                          color: AppColors.primary,
                          imagePath: "assets/car.png",
                        ),

                        SizedBox(height: 20),

                        _buildModernServiceCard(
                          title: "Track your packages",
                          description:
                              "Track your packages in real-time to know their status and location.",
                          color: AppColors.onePrimary,
                          imagePath: "assets/box2.png",
                        ),

                        SizedBox(height: 20),

                        _buildModernServiceCard(
                          title: "Check delivery status",
                          description:
                              "Check the status of your delivery to ensure it arrives on time and in good condition.",
                          color: AppColors.secondary,
                          imagePath: "assets/updatedelivery-bike.png",
                        ),
                      ],
                    ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernServiceCard({
    required String title,
    required String description,
    required Color color,
    required String imagePath,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.onPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            // Icon and Image Container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      imagePath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        // color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSecondary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14,
                      color: AppColors.onSecondary,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            // Container(
            //   padding: EdgeInsets.all(8),
            //   decoration: BoxDecoration(
            //     color: AppColors.form,
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(int index) {
    switch (index) {
      case 0:
        return AppColors.primary;
      case 1:
        return AppColors.onePrimary;
      case 2:
        return AppColors.secondary;
      case 3:
        return AppColors.primary;
      default:
        return AppColors.onSecondary;
    }
  }

  String _getStatusLabel(int index) {
    switch (index) {
      case 0:
        return "Order Placed";
      case 1:
        return "Preparing Order";
      case 2:
        return "On the way";
      case 3:
        return "Delivered";
      default:
        return "";
    }
  }

  Widget _buildStatusBox(String text, int index, int trackerId) {
    bool isActive = index <= trackerId;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isActive 
            ? AppColors.primary.withOpacity(0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? AppColors.primary
              : Colors.grey.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.body.copyWith(
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          color: isActive ? AppColors.primary : Colors.grey[600],
        ),
      ),
    );
  }
}
