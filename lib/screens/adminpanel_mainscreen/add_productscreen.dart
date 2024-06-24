import 'dart:io';
import 'package:admin_panel/models/product_model.dart';
import 'package:admin_panel/services/generate_product_id.dart';
import 'package:admin_panel/utils/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../controllers/categorydropdowncontroller.dart';
import '../../controllers/is_sale_controller.dart';
import '../../controllers/productimages_controller.dart';
import '../../widgets/dropdown_categorywidget.dart';


class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});
  final ProductImagesController productImagesController = Get.put(ProductImagesController());
  final CategoryDropDownController categoryDropDownController = Get.put(CategoryDropDownController());
final isSaleController issaleController = Get.put( isSaleController());
  TextEditingController productNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select images'),
                    ElevatedButton(
                      onPressed: () {
                        productImagesController.showImagesPickerDialog();
                      },
                      child: Text("Select images"),
                    ),
                  ],
                ),
              ),
              GetBuilder<ProductImagesController>(
                init: ProductImagesController(),
                builder: (productimagecontroller) {
                  return productimagecontroller.selectedimages.length > 0
                      ? Container(
                          width: Get.width - 20,
                          height: Get.height / 3.0,
                          child: GridView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: productImagesController.selectedimages.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Image.file(
                                    File(productimagecontroller.selectedimages[index].path),
                                    fit: BoxFit.cover,
                                    height: Get.height / 4,
                                    width: Get.width / 2,
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        productImagesController.removeimages(index);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: AppConstant.AppSecondaryColor,
                                        child: Icon(
                                          Icons.close,
                                          color: AppConstant.TextColor,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        )
                      : SizedBox.shrink();
                },
              ),
              // show categories drop down
              DropDownCategoriesWiidget(),
      
              //is sale 
              GetBuilder<isSaleController>(
                init: isSaleController(),
                builder: (issalecontroller){
      return Card(
        child:   Padding(
        
          padding: const EdgeInsets.all(8.0),
        
          child:   Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text("Is sale "),
        
        Switch(
          activeColor: AppConstant.AppMainColor,
          value: issalecontroller.isSale.value, onChanged: (value){
      issaleController.toggleIsSale(value);
        })
          ],),
        
        ),
      );
      
              }),
                 //form
                SizedBox(height: 10.0),
                Container(
                  height: 65,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    cursorColor: AppConstant.AppMainColor,
                    textInputAction: TextInputAction.next,
                    controller: productNameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      hintText: "Product Name",
                      hintStyle: TextStyle(fontSize: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
      
                Obx(() {
                  return issaleController.isSale.value
                      ? Container(
                          height: 65,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextFormField(
                            cursorColor: AppConstant.AppMainColor,
                            textInputAction: TextInputAction.next,
                            controller: salePriceController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              hintText: "Sale Price",
                              hintStyle: TextStyle(fontSize: 12.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink();
                }),
      
                SizedBox(height: 10.0),
                Container(
                  height: 65,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    cursorColor: AppConstant.AppMainColor,
                    textInputAction: TextInputAction.next,
                    controller: fullPriceController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      hintText: "Full Price",
                      hintStyle: TextStyle(fontSize: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
      
                SizedBox(height: 10.0),
                Container(
                  height: 65,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    cursorColor: AppConstant.AppMainColor,
                    textInputAction: TextInputAction.next,
                    controller: deliveryTimeController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      hintText: "Delivery Time",
                      hintStyle: TextStyle(fontSize: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
      
                SizedBox(height: 10.0),
                Container(
                  height: 65,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    cursorColor: AppConstant.AppMainColor,
                    textInputAction: TextInputAction.next,
                    controller: productDescriptionController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      hintText: "Product Desc",
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
    try {
      EasyLoading.show();
      await productImagesController.uploadFunction(productImagesController.selectedimages);
      print("Uploaded image URLs: ${productImagesController.arrimagesurl}");
      String productId=await GenerateIds().generateProductId();
      ProductModel productModel=ProductModel(
        categoryId: categoryDropDownController.selectedCategoryId.toString(), 
        categoryName:categoryDropDownController.selectedCategoryName.toString(),
         productName: productNameController.text.trim(), 
         salePrice: salePriceController!=""?salePriceController.text.trim():"", 
         deliveryTime: deliveryTimeController.text.trim(),
          fullPrice: fullPriceController.text.trim(),
           productDescription: productDescriptionController.text.trim(),
            productImages: productImagesController.arrimagesurl, 
            productId: productId,
             isSale: issaleController.isSale.value, 
             createdAt: DateTime.now(),
              updatedAt: DateTime.now()
              );
              await FirebaseFirestore.instance.collection("products").doc(productId).set(productModel.toMap());
      EasyLoading.dismiss();
    } catch (e) {
      
      print("Error during image upload: $e");
    }
  },
  child: Text("Update"),
),
      
            ],
          ),
        ),
      ),
    );
  }
}
