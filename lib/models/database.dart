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
}
