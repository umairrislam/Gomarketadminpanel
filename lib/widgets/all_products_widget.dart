import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:image_card/image_card.dart';

import '../models/product_model.dart';
import '../screens/user-panel/product_detailscreen.dart';

class AllProductWidget extends StatefulWidget {
  const AllProductWidget({super.key});

  @override
  State<AllProductWidget> createState() => _AllProductWidgetState();
}

class _AllProductWidgetState extends State<AllProductWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: false)
            .get(),
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
              child: Text('No products found'),
            );
          }
          if (snapshot.data != null) {
            return Container(
              height: Get.height / 3,
              child:  GridView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,crossAxisSpacing: 5,mainAxisSpacing: 5,childAspectRatio: 0.8,), 
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
                ProductModel productModel = ProductModel(
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
                        updatedAt: productData['updatedAt']);
                    // CategoriesModel categoriesModel = CategoriesModel(
                    //     categoryId: snapshot.data!.docs[index]['categoryId'],
                    //     categoryImg: snapshot.data!.docs[index]['categoryImg'],
                    //     categoryName: snapshot.data!.docs[index]
                    //         ['categoryName'],
                    //     createdAt: snapshot.data!.docs[index]['createdAt'],
                    //     updatedAt: snapshot.data!.docs[index]['updatedAt']);
                    return Row(
                      children: [
                        GestureDetector(
                            onTap: () =>Get.to(()=>ProductDetailScreen(productmodeldata:productModel)),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: FillImageCard(
                              color: Colors.grey.shade200,
                              borderRadius: 20.0,
                              width: Get.width/2.4,
                              heightImage: Get.height/7,
                              imageProvider: CachedNetworkImageProvider(
                                  productModel.productImages[0]),
                              title: Center(child: Text(productModel.productName)),
                              
                             footer: Center(child: Text('Rs:${productModel.fullPrice}')),
                            ),
                          ),
                        )
                      ],
                    );
                  }
             ),
            );
          }
          return Container();
        });
  }
}
