import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:admin_panel/models/cart_model.dart';
import 'package:admin_panel/utils/app_constants.dart';
import 'package:image_card/image_card.dart';

import '../../controllers/cart_pricecontroller.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.AppMainColor,
        title: Text('Cart Screen'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('cart')
              .doc(user!.uid)
              .collection('cartOrders')
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
                  CartModel cartModel = CartModel(
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
                      productTotalPrice:double.parse(productData['productTotalPrice'].toString(), ));
                  productPriceController.fetchProductPrice();
                  return SwipeActionCell(
                    key: ObjectKey(cartModel.productId),
                    trailingActions: [
                      SwipeAction(
                        title: 'Delete',
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          print('deleted');
                          await FirebaseFirestore.instance
                              .collection('cart')
                              .doc(user!.uid)
                              .collection('cartOrders')
                              .doc(cartModel.productId)
                              .delete();
                        },
                      )
                    ],
                    child: Card(
                      elevation: 5,
                      color: AppConstant.TextColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.AppMainColor,
                          backgroundImage:
                              NetworkImage(cartModel.productImages[0]),
                        ),
                        title: Text(cartModel.productName),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(cartModel.productTotalPrice.toString()),
                            SizedBox(
                              width: Get.width / 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (cartModel.productQuantity > 0) {
                                  await FirebaseFirestore.instance
                                      .collection("cart")
                                      .doc(user!.uid)
                                      .collection("cartOrders")
                                      .doc(cartModel.productId)
                                      .update({
                                    'productQuantity':
                                        cartModel.productQuantity + 1,
                                    'productTotalPrice':
                                        double.parse(cartModel.fullPrice) +
                                            double.parse(cartModel.fullPrice) *
                                                (cartModel.productQuantity - 1)
                                  });
                                }
                              },
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: AppConstant.AppMainColor,
                                child: Text('+'),
                              ),
                            ),
                            SizedBox(
                              width: Get.width / 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (cartModel.productQuantity > 1) {
                                  await FirebaseFirestore.instance
                                      .collection("cart")
                                      .doc(user!.uid)
                                      .collection("cartOrders")
                                      .doc(cartModel.productId)
                                      .update({
                                    'productQuantity':
                                        cartModel.productQuantity - 1,
                                    'productTotalPrice':
                                        (double.parse(cartModel.fullPrice) *
                                            (cartModel.productQuantity - 1))
                                  });
                                }
                              },
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: AppConstant.AppMainColor,
                                child: Text('-'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
            }
            return Container();
          }
          ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                "total:${productPriceController.totalPrice.value.toStringAsFixed(1)}:Pkr",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppConstant.AppMainColor,
                      borderRadius: BorderRadius.circular(20)),
                  width: Get.width / 2.0,
                  height: Get.height / 18,
                  child: TextButton(
                    child: Text(
                      "Checkout",
                      style: TextStyle(
                          color:
                              AppConstant.TextColor), // Set text color to white
                    ),
                    onPressed: () {
                      Get.to(() => CheckoutScreen());
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
