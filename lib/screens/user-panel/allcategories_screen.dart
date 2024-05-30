import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:image_card/image_card.dart';

import '../../models/category_model.dart';
import '../../utils/app_constants.dart';
import 'single_category_productscreen.dart';

class ALLCategoriesScreen extends StatefulWidget {
  const ALLCategoriesScreen({super.key});

  @override
  State<ALLCategoriesScreen> createState() => _CategoriesState();
}

class _CategoriesState extends State<ALLCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:AppBar(
      backgroundColor: AppConstant.AppMainColor,
      title: Text('ALL Categories screen'),
    ) ,
    body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
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
              child: Text('No category found'),
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
                    CategoriesModel categoriesModel = CategoriesModel(
                        categoryId: snapshot.data!.docs[index]['categoryId'],
                        categoryImg: snapshot.data!.docs[index]['categoryImg'],
                        categoryName: snapshot.data!.docs[index]
                            ['categoryName'],
                        createdAt: snapshot.data!.docs[index]['createdAt'],
                        updatedAt: snapshot.data!.docs[index]['updatedAt']);
                    return Row(
                      children: [
                        GestureDetector(
                            onTap: () =>Get.to(()=>SingleCategoryProductScreen(categoryId:categoriesModel.categoryId)),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: FillImageCard(
                              color: Colors.grey.shade200,
                              borderRadius: 20.0,
                              width: Get.width/2.4,
                              heightImage: Get.height/10,
                              imageProvider: CachedNetworkImageProvider(
                                  categoriesModel.categoryImg),
                              title: Center(child: Text(categoriesModel.categoryName)),
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