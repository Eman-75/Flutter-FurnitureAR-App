import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  Future InsertService(Map<String, dynamic> Pmap, String ID) async {
    await FirebaseFirestore.instance.collection('PRODUCTS').doc(ID).set(Pmap);
  }

  Stream<QuerySnapshot> GetService() {
    return FirebaseFirestore.instance.collection('PRODUCTS').snapshots();
  }

  Future InsertOrder({
    required Map<String, dynamic> userDetails,
    required String orderId,
    required List<dynamic> cartItems,
    required double totalPrice,
    required String paymentMethod,
  }) async {
    await FirebaseFirestore.instance.collection('ORDERS').doc(orderId).set({
      'ORDER_ID': orderId,
      'USER_DETAILS': userDetails,
      'CART_ITEMS': cartItems
          .map((item) => {
                'PRODUCT_ID': item.productId,
                'PRODUCT_NAME': item.productName,
                'PRODUCT_IMAGE': item.productThumbnail,
                'QUANTITY': item.quantity,
                'UNIT_PRICE': item.unitPrice,
                'TOTAL_PRICE': item.unitPrice * item.quantity,
              })
          .toList(),
      'TOTAL_PRICE': totalPrice,
      'CREATED_AT': FieldValue.serverTimestamp(),
      'PAYMENT_METHOD' : paymentMethod
    });
  }

  Stream<QuerySnapshot> GetOrders() {
    return FirebaseFirestore.instance.collection('ORDERS').snapshots();
  }

  Future DeleteProduct(String ID)async{
    await FirebaseFirestore.instance.collection('PRODUCTS').doc(ID).delete();
  }

  Future DeleteOrder(String ID)async{
    await FirebaseFirestore.instance.collection('ORDERS').doc(ID).delete();
  }

  Future EditProduct(Map<String,dynamic> Pmap, String ID)async{
    await FirebaseFirestore.instance.collection('PRODUCTS').doc(ID).update(Pmap);
  }
}
