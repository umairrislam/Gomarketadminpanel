import 'package:admin_panel/screens/adminpanel_mainscreen/check_single_orderscreen.dart';
import 'package:admin_panel/utils/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../models/order_model.dart';

class SpecificCustomerOrderScreen extends StatelessWidget {
  String docId;
  String  customerName;
   SpecificCustomerOrderScreen( {super.key, required this.docId , required  this.customerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.AppMainColor,
      title: Text(customerName),
    ),
     body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('orders').doc(docId).collection('confirmOrders')
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
              child: Text('No Orders found'),
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
              final orderDocId=Data.id;
              OrderModel orderModel= OrderModel(
                categoryId:Data["categoryId"],
                 categoryName:Data["categoryName"],
                  productName:Data["productName"],
                   salePrice: Data["salePrice"], 
                   deliveryTime:Data["deliveryTime"],
                    fullPrice:Data["fullPrice"],
                     productDescription: Data["productDescription"], 
                     productImages: Data["productImages"],
                      productId: Data["productId"],
                       isSale: Data["isSale"],
                       createdAt:Data["createdAt"], 
                       updatedAt: Data["updatedAt"],
                        productQuantity: Data["productQuantity"],
                         productTotalPrice: Data["productTotalPrice"], 
                         customerId: Data["customerId"],
                          customerName: Data["customerName"], 
                         customerAddress:  Data["customerAddress"], 
                         customerDeviceToken: Data["customerDeviceToken"],
                          customerPhone: Data["customerPhone"], 
                          status:Data["status"],
                          );
                
                    return Card(
                      elevation: 5,
                      color: AppConstant.TextColor,
                      child: GestureDetector(
                          onTap: () => Get.to(()=>CheckSingleOrderScreen(
                        docId  :snapshot.data!.docs[index].id,
                        orderModel:orderModel
                //customerName :  snapshot.data!.docs[index]['customerName'],
                          )),
                        child: ListTile(
                          leading: GestureDetector(
                          
                            child: CircleAvatar(
                              backgroundColor: AppConstant.AppMainColor,
                            child: Text(orderModel.customerName[0]),
                            ),
                          ),
                          title: Text(Data['customerName']),
                          subtitle: Text(orderModel.productName),
                          trailing: InkWell(
                            onTap: () {
                              showBottomSheet(
                                userDocId:docId,
                                orderModel:orderModel,
                                orderDocId:orderDocId
                              );
                            },
                            child: Icon(Icons.more_vert)),
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
  void showBottomSheet({required String userDocId, required OrderModel orderModel, required String orderDocId}){
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: ()async {
               await     FirebaseFirestore.instance.collection('orders').doc(userDocId).collection('confirmOrders').doc(orderDocId).update({
                      'status':false
                    });
                  
                }, child: Text('Pending')),
              ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ElevatedButton(onPressed: ()async {
                  await     FirebaseFirestore.instance.collection('orders').doc(userDocId).collection('confirmOrders').doc(orderDocId).update({
                      'status':true
                    });
                             }, child: Text('Delivered')),
               ),
            ],
          )
        ],
      ) ,
    ));

  }
}