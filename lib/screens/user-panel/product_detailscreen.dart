import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/cart_model.dart';
import '../../models/product_model.dart';
import '../../utils/app_constants.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen({Key? key, required this.productmodeldata}) : super(key: key);

  final ProductModel productmodeldata;

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.AppMainColor,
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => CartScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: Get.height / 60,
            ),
            CarouselSlider(
              items: widget.productmodeldata.productImages
                  .map(
                    (imageUrls) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: imageUrls,
                        fit: BoxFit.fill,
                        width: Get.width - 10,
                        placeholder: (context, url) => ColoredBox(
                          color: Colors.white,
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                aspectRatio: 2.5,
                viewportFraction: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.productmodeldata.productName),
                            Icon(Icons.favorite_outline)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: widget.productmodeldata.isSale == true && widget.productmodeldata.salePrice != ''
                            ? Text("PKR" + widget.productmodeldata.salePrice)
                            : Text("PKR" + widget.productmodeldata.fullPrice),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text("Category: " + widget.productmodeldata.categoryName),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppConstant.AppMainColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: Get.width / 3.0,
                              height: Get.height / 16,
                              child: TextButton(
                                child: Text(
                                  "WhatsApp",
                                  style: TextStyle(
                                    color: AppConstant.TextColor,
                                  ),
                                ),
                                onPressed: () {
                                  sendMessageOnWhatsapp(
                                    productModel:widget.productmodeldata,
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Material(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppConstant.AppMainColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: Get.width / 3.0,
                              height: Get.height / 16,
                              child: TextButton(
                                child: Text(
                                  "Add to cart",
                                  style: TextStyle(
                                    color: AppConstant.TextColor,
                                  ),
                                ),
                                onPressed: () async {
                                  await checkProductExistence(uId: user!.uid, context: context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
static Future<void> sendMessageOnWhatsapp({required ProductModel productModel}) async{
final num='+923139248971';
final message='Hello Gomarket  \n  i want to know about this product \n ${productModel.productName}   /n ${productModel.productId}';
final url='https://wa.me/$num?text=${Uri.encodeComponent(message)}';
// ignore: deprecated_member_use
if(await canLaunch(url)){
  // ignore: deprecated_member_use
  await launch(url);

}
else{
  throw 'Could not launch $url';
}
 }


  // check product exist r not 

  Future<void> checkProductExistence(
      {required String uId, required BuildContext context, int quantityIncrement = 1}) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productmodeldata.productId.toString());
    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(widget.productmodeldata.isSale ? widget.productmodeldata.salePrice : widget.productmodeldata.fullPrice) * updatedQuantity;
      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice,
      });
      Get.snackbar("Products exits in cart", "",
      snackPosition: SnackPosition.BOTTOM,
                            colorText: AppConstant.TextColor,
                            backgroundColor: AppConstant.AppSecondaryColor,);
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set({
        'uId': uId,
        'createdAt': DateTime.now(),
      });

      CartModel cartModel = CartModel(
        categoryId: widget.productmodeldata.categoryId,
        categoryName: widget.productmodeldata.categoryName,
        productName: widget.productmodeldata.productName,
        salePrice: widget.productmodeldata.salePrice,
        deliveryTime: widget.productmodeldata.deliveryTime,
        fullPrice: widget.productmodeldata.fullPrice,
        productDescription: widget.productmodeldata.productDescription,
        productImages: widget.productmodeldata.productImages,
        productId: widget.productmodeldata.productId,
        isSale: widget.productmodeldata.isSale,
        createdAt: widget.productmodeldata.createdAt,
        updatedAt: widget.productmodeldata.updatedAt,
        productQuantity: 1,
        productTotalPrice: double.parse(widget.productmodeldata.isSale ? widget.productmodeldata.salePrice : widget.productmodeldata.fullPrice),
      );
      await documentReference.set(cartModel.toMap());
      Get.snackbar('Successfully product added to cart', '',
      
      snackPosition: SnackPosition.BOTTOM,
                            colorText: AppConstant.TextColor,
                            backgroundColor: AppConstant.AppSecondaryColor,);
    }
  }
}
