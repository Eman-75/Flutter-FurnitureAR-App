import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  Future<int> getTotalProducts() async {
    final snapshot = await FirebaseFirestore.instance.collection('PRODUCTS').get();
    return snapshot.docs.length;
  }

  Future<int> getTotalOrders() async {
    final snapshot = await FirebaseFirestore.instance.collection('ORDERS').get();
    return snapshot.docs.length;
  }

  Future<double> getTotalSales() async {
    final snapshot = await FirebaseFirestore.instance.collection('ORDERS').get();
    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc['TOTAL_PRICE'] ?? 0).toDouble();
    }
    return total;
  }
}