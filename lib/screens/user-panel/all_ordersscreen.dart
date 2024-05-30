import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:image_card/image_card.dart';

import '../../controllers/cart_pricecontroller.dart';
import '../../models/order_model.dart';
import '../../utils/app_constants.dart';
import 'checkout_screen.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({super.key});

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.AppMainColor,
        title: Text('All orders Screen'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .doc(user!.uid)
              .collection('confirmOrders')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  height: Get.height / 5,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ));
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No products found'),
              );
            }
            if (snapshot.data != null) {
              return Container(
                  child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  OrderModel orderModel = OrderModel(
                      categoryId: productData['categoryId'],
                      categoryName: productData['categoryName'],
                      productName: productData['productName'],
                      salePrice: productData['salePrice'],
                      deliveryTime: productData['deliveryTime'],
                      fullPrice: productData['fullPrice'],
                      productDescription: productData['productDescription'],
                      productImages: productData['productImages'],
                      productId: productData['productId'],
                      isSale: productData['isSale'],
                      createdAt: productData['createdAt'],
                      updatedAt: productData['updatedAt'],
                      productQuantity: productData['productQuantity'],
                      productTotalPrice:double.parse(productData['productTotalPrice'].toString(), ),
                      customerId: user!.uid,
                      customerAddress: productData['customerAddress'],
                      customerName: productData['customerName'],
                      customerPhone: productData['customerPhone'],
                      status:  productData['status'],
                      customerDeviceToken: productData['customerDeviceToken']
                      );
                  productPriceController.fetchProductPrice();
                  return Card(
                      elevation: 5,
                      color: AppConstant.TextColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.AppMainColor,
                          backgroundImage:
                              NetworkImage(orderModel.productImages[0]),
                        ),
                        title: Text(orderModel.productName),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(orderModel.productTotalPrice.toString()),
                            SizedBox(width: 10,),
                            orderModel.status!=true?Text('Pending..',style: TextStyle(color: Colors.green),):Text("Delivered..",style: TextStyle(color: Colors.red))
                         
                          ],
                        ),
                      ),
                    );
                },
              ));
            }
            return Container();
          }
          ),
      
    );
  }
}
