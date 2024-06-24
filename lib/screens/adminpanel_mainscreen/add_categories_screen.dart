import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/productimages_controller.dart';
import '../../models/category_model.dart';
import '../../services/generate_product_id.dart';
import '../../utils/app_constants.dart';

class AddCategoriesScreen extends StatefulWidget {
  const AddCategoriesScreen({super.key});

  @override
  State<AddCategoriesScreen> createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  TextEditingController categoryNameController = TextEditingController();
ProductImagesController addProductImagesController =
      Get.put(ProductImagesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Categories"),
        backgroundColor: AppConstant.AppMainColor,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Select Images"),
                    ElevatedButton(
                      onPressed: () {
                        addProductImagesController.showImagesPickerDialog();
                      },
                      child: const Text("Select Images"),
                    )
                  ],
                ),
              ),

              //show Images
              GetBuilder<ProductImagesController>(
                init: ProductImagesController(),
                builder: (imageController) {
                  return imageController.selectedimages.length > 0
                      ? Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: Get.height / 3.0,
                          child: GridView.builder(
                            itemCount: imageController.selectedimages.length,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Image.file(
                                    File(addProductImagesController
                                        .selectedimages[index].path),
                                    fit: BoxFit.cover,
                                    height: Get.height / 4,
                                    width: Get.width / 2,
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        imageController.removeimages(index);
                                        print(imageController
                                            .selectedimages.length);
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor:
                                            AppConstant.AppSecondaryColor,
                                        child: Icon(
                                          Icons.close,
                                          color: AppConstant.TextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 40.0),
              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.AppMainColor,
                  textInputAction: TextInputAction.next,
                  controller: categoryNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Category Name",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  EasyLoading.show();
                  await addProductImagesController.uploadFunction(
                      addProductImagesController.selectedimages);
                  String categoryId = await GenerateIds().generateCategoryId();

                  CategoriesModel categoriesModel = CategoriesModel(
                    categoryId: categoryId,
                    categoryName: categoryNameController.text.trim(),
                    categoryImg:
                        addProductImagesController.arrimagesurl[0].toString(),
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  print(categoryId);

                  //
                  FirebaseFirestore.instance
                      .collection('categories')
                      .doc(categoryId)
                      .set(categoriesModel.toMap());

                  EasyLoading.dismiss();
                },
                child: Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}