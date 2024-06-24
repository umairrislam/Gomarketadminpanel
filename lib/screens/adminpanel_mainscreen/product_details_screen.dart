import 'package:admin_panel/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/app_constants.dart';

class AdminSingleProductDetailScreen extends StatelessWidget {
   ProductModel productModel;
 AdminSingleProductDetailScreen({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        backgroundColor: AppConstant.AppMainColor,
title: Text(productModel.productName),

    ),
    body: Container(
      child: Column(
        children: [
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Product Name"),
                      Container(
                        width: Get.width/2,
                        child: Text(productModel.productName,overflow: TextOverflow.ellipsis,maxLines: 3,))
                    ],
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Product price"),
                      Container(
                        width: Get.width/2,
                        child: Text(productModel.salePrice==''?productModel.fullPrice:productModel.salePrice,overflow: TextOverflow.ellipsis,maxLines: 3,))
                    ],
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Delivery time"),
                      Container(
                        width: Get.width/2,
                        child: Text(productModel.deliveryTime,overflow: TextOverflow.ellipsis,maxLines: 3,))
                    ],
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Is sale"),
                      Container(
                        width: Get.width/2,
                        child: Text(productModel.isSale?"True":"False",overflow: TextOverflow.ellipsis,maxLines: 3,))
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
    );
  }
}