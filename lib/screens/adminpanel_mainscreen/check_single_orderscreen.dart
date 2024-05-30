import 'package:admin_panel/models/order_model.dart';
import 'package:admin_panel/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckSingleOrderScreen extends StatelessWidget {
  String docId;
  OrderModel orderModel;
   CheckSingleOrderScreen({super.key, required this.docId,  required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.AppMainColor,
        title: Text("orders"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(orderModel.productName),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(orderModel.productTotalPrice.toString()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(orderModel.productQuantity.toString()),
          ),
          Row(
             mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                foregroundImage: NetworkImage(orderModel.productImages[0]),),
               CircleAvatar(
                radius: 50,
                foregroundImage: NetworkImage(orderModel.productImages[1]),)
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(orderModel.categoryName),
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(orderModel.customerPhone),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(orderModel.customerAddress),
          )

        ],
      ),
    );
  }
}