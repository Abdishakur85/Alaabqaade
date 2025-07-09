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

  // get users orders
  Future<Stream<QuerySnapshot>> getUserOrder(String id) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .collection("Order")
        .snapshots();
  }
}
