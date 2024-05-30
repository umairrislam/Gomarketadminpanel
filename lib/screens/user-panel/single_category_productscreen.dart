import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:admin_panel/models/product_model.dart';
import 'package:admin_panel/screens/user-panel/product_detailscreen.dart';
import 'package:admin_panel/utils/app_constants.dart';
import 'package:image_card/image_card.dart';

import '../../models/category_model.dart';

class SingleCategoryProductScreen extends StatefulWidget {
  String categoryId;
   SingleCategoryProductScreen({super.key, required this.categoryId});

  @override
  State<SingleCategoryProductScreen> createState() => _CategoriesState();
}

class _CategoriesState extends State<SingleCategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:AppBar(
      backgroundColor: AppConstant.AppMainColor,
      title: Text('Single  Categories Product screen'),
    ) ,
    body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').where('categoryId',isEqualTo: widget.categoryId).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              child: Text('No Products found'),
            );
          }
          if (snapshot.data != null) {

            return GridView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,crossAxisSpacing: 1,mainAxisSpacing: 2,childAspectRatio: 1,), 
            itemBuilder: (context, index) {
              final productData=snapshot.data!.docs[index];
                   ProductModel productModel=ProductModel(
                    categoryId:productData['categoryId'], 
                     categoryName:productData['categoryName'] ,
                      productName: productData['productName'],
                       salePrice: productData['salePrice'], 
                       deliveryTime: productData['deliveryTime'],
                        fullPrice: productData['fullPrice'], 
                        productDescription:productData['productDescription'], 
                        productImages:productData['productImages'], 
                        productId:productData['productId'], 
                        isSale:productData['isSale'], 
                        createdAt:productData['createdAt'], 
                        updatedAt:productData['updatedAt'],
                        );
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(()=>ProductDetailScreen(productmodeldata: productModel)),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: FillImageCard(
                              color: Colors.grey.shade200,
                              borderRadius: 20.0,
                              width: Get.width/2.4,
                              heightImage: Get.height/10,
                              imageProvider: CachedNetworkImageProvider(
                                  productModel.productImages[0]),
                              title: Center(child: Text(productModel.productName)),
                             footer: Text(''),
                            ),
                          ),
                        )
                      ],
                    );
                  }
             );
           
          }
          return Container();
        }),
    );
  }
}