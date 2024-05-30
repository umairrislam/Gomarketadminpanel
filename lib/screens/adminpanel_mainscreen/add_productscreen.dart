import 'dart:io';

import 'package:admin_panel/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/productimages_controller.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});
  final ProductImagesController productImagesController = Get.put(ProductImagesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Container(
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
              init:ProductImagesController() ,
              builder: (productimagecontroller) {
                return productimagecontroller.selectedimages.length>0
                    ?Container(
                      width: Get.width-20,
                      height: Get.height/3.0,
                      
                      child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: productImagesController.selectedimages.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 20,crossAxisSpacing: 10), itemBuilder: (BuildContext context, int index) {
                          return Stack(children: [Image.file(File(productimagecontroller.selectedimages[index].path),fit: BoxFit.cover,height: Get.height/4,width: Get.width/2,
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
                              child: Icon(Icons.close,color: AppConstant.TextColor,),),
                            ))
                          ],
                          );
                        },),
                    )
                    : SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
