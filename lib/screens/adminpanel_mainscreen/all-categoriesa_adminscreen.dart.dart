import 'package:admin_panel/models/category_model.dart';
import 'package:admin_panel/screens/adminpanel_mainscreen/add_categories_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/categorydropdowncontroller.dart';
import '../../controllers/edit_category_controller.dart';
import '../../utils/app_constants.dart';
import 'edit_category_screen.dart';

class AdminCategoriesScreen extends StatelessWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: AppConstant.AppMainColor,
      title: Text(' All Categories'),
         actions: [
          InkWell(
            onTap: () => Get.to(() => const AddCategoriesScreen()),
            child:  Padding(
              padding: EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () => Get.to(() => const AddCategoriesScreen()),
                child: Icon(Icons.add)),
            ),
          ),
        ],
    ),
    body:StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('categories')
           // .orderBy('createdAt', descending: true)
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
              child: Text('No Categories found'),
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
             CategoriesModel categoriesModel=CategoriesModel(
              categoryId:Data['categoryId'] ,
               categoryImg:Data['categoryImg'],
                categoryName:Data['categoryName'],
                 createdAt:Data['createdAt'],
                  updatedAt: Data['updatedAt'],
                  );
                    return SwipeActionCell(
      key: ObjectKey(categoriesModel.categoryId), /// this key is necessary
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
                 EditCategoryController editCategoryController =
                                  Get.put(EditCategoryController(
                                      categoriesModel: categoriesModel));

                              await editCategoryController
                                  .deleteImagesFromStorage(
                                      categoriesModel.categoryImg);

                              await editCategoryController
                                  .deleteWholeCategoryFromFireStore(
                                      categoriesModel.categoryId);
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
                          // Get.to(()=>AdminSingleProductDetailScreen(productModel:productModel));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppConstant.AppMainColor,
                            backgroundImage:
                                CachedNetworkImageProvider(categoriesModel.categoryImg.toString(),
                                errorListener: () {
                                  print("error loading image");
                                  Icon(Icons.error);
                                },
                                ),
                          ),
                          title: Text(categoriesModel.categoryName),
                          subtitle: Text(categoriesModel.categoryId),
                          trailing: GestureDetector(
                             onTap: ()  => Get.to(
                                () => EditCategoryScreen(
                                    categoriesModel: categoriesModel),
                              ),
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
        }) ,
    );
  }
}