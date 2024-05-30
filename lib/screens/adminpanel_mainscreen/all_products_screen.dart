import 'package:admin_panel/models/product_model.dart';
import 'package:admin_panel/screens/adminpanel_mainscreen/add_productscreen.dart';
import 'package:admin_panel/screens/adminpanel_mainscreen/product_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/getuserlengthcontroller.dart';
import '../../models/user_model.dart';
import '../../utils/app_constants.dart';

class AdminAllProductScreen extends StatefulWidget {
  const AdminAllProductScreen({super.key, });

  @override
  State<AdminAllProductScreen> createState() => _AdminAllProductScreenState();
}

class _AdminAllProductScreenState extends State<AdminAllProductScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: AppConstant.AppMainColor,
        title:Text('All Product screen'),
        actions: [
          GestureDetector(
            onTap: ()=>Get.to(()=>AddProductScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
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
              child:  ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
             
            itemBuilder: (context, index) {
              final Data = snapshot.data!.docs[index];
               ProductModel productModel=ProductModel(
                categoryId:  Data['categoryId'], 
                categoryName: Data['categoryName'],
                 productName: Data['productName'], 
                 salePrice: Data['salePrice'], 
                 deliveryTime: Data['deliveryTime'],
                  fullPrice:Data['fullPrice'],
                   productDescription: Data['productDescription'],
                    productImages: Data['productImages'],
                     productId: Data['categoryId'], 
                     isSale: Data['isSale'],
                      createdAt:Data['createdAt'],
                       updatedAt: Data[ 'updatedAt'],
                       );
                    return Card(
                      elevation: 5,
                      color: AppConstant.TextColor,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(()=>AdminSingleProductDetailScreen(productModel:productModel));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppConstant.AppMainColor,
                            backgroundImage:
                                CachedNetworkImageProvider(productModel.productImages[0],
                                errorListener: () {
                                  print("error loading image");
                                  Icon(Icons.error);
                                },
                                ),
                          ),
                          title: Text(productModel.productName),
                          subtitle: Text(productModel.productId),
                          trailing: Icon(Icons.edit),
                        ),
                      ),
                    );
                  }
             ),
            );
          }
          return Container();
        }),
    );
  }
}