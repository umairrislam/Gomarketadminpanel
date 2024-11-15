import 'package:admin_panel/models/product_model.dart';
import 'package:admin_panel/screens/adminpanel_mainscreen/add_productscreen.dart';

import 'package:admin_panel/screens/adminpanel_mainscreen/product_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/categorydropdowncontroller.dart';
import '../../controllers/getuserlengthcontroller.dart';
import '../../controllers/is_sale_controller.dart';
import '../../models/user_model.dart';
import '../../utils/app_constants.dart';
import 'edit_product_screen.dart';

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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
            .snapshots(),
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
              height: Get.height / 1,
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
                     productId: Data['productId'], 
                     isSale: Data['isSale'],
                      createdAt:Data['createdAt'],
                       updatedAt: Data[ 'updatedAt'],
                       );
                    return SwipeActionCell(
      key: ObjectKey(productModel.productId), /// this key is necessary
      trailingActions: <SwipeAction>[
        SwipeAction(
            title: "Delete",
            onTap: (CompletionHandler handler) async {
             await Get.defaultDialog(
              title: 'Delete Product',
              content: Text('Are you sure you want to delete this product',
              
              ),
              textCancel: "Cancel",
              textConfirm: 'Delete',
              contentPadding: EdgeInsets.all(10),confirmTextColor: Colors.white,
              onCancel: () {
                
              },
              onConfirm: ()async {
                Get.back();
                EasyLoading.show(status: 'Please wait');
                await deleteImagesFromFirebase(productModel.productImages);
                 await FirebaseFirestore.instance.collection("products").doc(productModel.productId).delete();
                 EasyLoading.dismiss();
              },
              buttonColor: Colors.red,
              cancelTextColor: Colors.black

             
             );
            },
            color: Colors.red),
      ],
      child:  Card(
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
                          trailing: GestureDetector(
                             onTap: () {
                            final editProdouctCategory =
                                Get.put(CategoryDropDownController());
                            final issaleController =
                                Get.put(isSaleController());
                            editProdouctCategory
                                .setOldValue(productModel.categoryId);

                            issaleController
                                .setIsSaleOldValue(productModel.isSale);
                            Get.to(() =>
                                EditProductScreen(productModel: productModel));
                          },
                            child: Icon(Icons.edit)),
                        ),
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
  Future deleteImagesFromFirebase(List imagesUrl)async{
    final FirebaseStorage storage=FirebaseStorage.instance;
for(String imageUrl in imagesUrl){
  try{
    Reference reference=storage.refFromURL(imageUrl);
    await reference.delete();

  }catch(e){
    print("error$e");

  }
}

  }
}