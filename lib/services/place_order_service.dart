import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:admin_panel/screens/user-panel/mainscreeen.dart';
import 'package:admin_panel/utils/app_constants.dart';

import '../models/order_model.dart';
import 'generateorder_idservice.dart';

void placeOrder(
    {required BuildContext context,
    required String customername,
    required String customerphone,
    required String customeraddress,
    required String customerdevicetoken}) async {
  final user = FirebaseAuth.instance.currentUser;
  EasyLoading.show(status: "Please wait...");
  if (user != null) {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();
      List<QueryDocumentSnapshot> documents = snapshot.docs;
      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
        String orderId = generateOrderId();
        OrderModel orderModel = OrderModel(
          categoryId: data['categoryId'],
          categoryName: data['categoryName'],
          productName: data['productName'],
          salePrice: data['salePrice'],
          deliveryTime: data['deliveryTime'],
          fullPrice: data['fullPrice'],
          productDescription: data['productDescription'],
          productImages: data['productImages'],
          productId: data['productId'],
          isSale: data['isSale'],
          createdAt: DateTime.now(),
          updatedAt: data['updatedAt'],
          productQuantity: data['productQuantity'],
          productTotalPrice: double.parse(data['productTotalPrice'].toString()),
          customerId: user.uid,
          customerName: customername,
          customerPhone: customerphone,
          customerAddress: customeraddress,
          status: false,
          customerDeviceToken: customerdevicetoken,
        );
        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set({
            'uId': user.uid,
            'customerName': customername,
            'customerAddress': customeraddress,
            'customerPhone': customerphone,
            'customerDeviceToken': customerdevicetoken,
            'orderStatus': false,
            'createdAt': DateTime.now(),
          });
          //upload orders
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(orderModel.toMap());
          //delete cart products
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(orderModel.productId.toString())
              .delete()
              .then((value) {
            print('Delete cart products ${orderModel.productId.toString}');
          });
        }
      }
      print(' Order Confirm');
      Get.snackbar("Order Confirm", 'Thank you for shopping',
          backgroundColor: AppConstant.AppMainColor,
          colorText: AppConstant.TextColor,
          duration: Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM);
      EasyLoading.dismiss();
      Get.offAll(() => MainScreen());
    } catch (e) {
      print("error$e");
    }
  }
}
