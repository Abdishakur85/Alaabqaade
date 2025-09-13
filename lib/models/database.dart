import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethodes {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .set(userInfoMap);
  }

  Future addUserOrder(
    Map<String, dynamic> userInfoMap,
    String id,
    String orderId,
  ) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .collection("Order")
        .doc(orderId)
        .set(userInfoMap);
  }

  Future addAdminOrder(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Order")
        .doc(id)
        .set(userInfoMap);
  }

  // it reads all the orders from the database
  Future<Stream<QuerySnapshot>> getAdminOrders() async {
    return await FirebaseFirestore.instance.collection("Order").snapshots();
  }

  Future updateAdminTracker(String id, int updatedtracker) async {
    return await FirebaseFirestore.instance.collection("Order").doc(id).update({
      "Tracker": updatedtracker,
    });
  }

  Future updateUserTracker(
    String id,
    int updatedtracker,
    String orderid,
  ) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .collection("Order")
        .doc(orderid)
        .update({"Tracker": updatedtracker});
  }

  // get users orders(in the current) - only active orders (not completed)
  Future<Stream<QuerySnapshot>> getUserOrder(String id) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .collection("Order")
        .where("Tracker", isLessThan: 3)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllUsers() async {
    return await FirebaseFirestore.instance.collection("user").snapshots();
  }

  // get user pastorders
  Future<Stream<QuerySnapshot>> getUserPastOrders(String id) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .collection("Order")
        .where("Tracker", isEqualTo: 3)
        .snapshots();
  }

  Future deleteUser(String id) async {
    try {
      // First, delete all user orders
      var ordersSnapshot = await FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .collection("Order")
          .get();
      
      // Delete each order document
      for (var orderDoc in ordersSnapshot.docs) {
        await orderDoc.reference.delete();
      }
      
      // Then delete the user document
      return await FirebaseFirestore.instance.collection("user").doc(id).delete();
    } catch (e) {
      print("Error deleting user: $e");
      rethrow;
    }
  }

  // Update user image in database
  Future updateUserImage(String userId, String imagePath) async {
    try {
      return await FirebaseFirestore.instance
          .collection("user")
          .doc(userId)
          .update({"image": imagePath});
    } catch (e) {
      print("Error updating user image: $e");
      rethrow;
    }
  }
}
