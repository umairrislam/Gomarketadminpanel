import 'package:admin_panel/screens/adminpanel_mainscreen/specific_customerorderscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/getuserlengthcontroller.dart';
import '../../models/user_model.dart';
import '../../utils/app_constants.dart';

class AllUsersOrdersScreen extends StatefulWidget {
  const AllUsersOrdersScreen({super.key});

  @override
  State<AllUsersOrdersScreen> createState() => _AllUsersOrdersScreenState();
}

class _AllUsersOrdersScreenState extends State<AllUsersOrdersScreen> {
  final GetUserLengthController _getUserLengthController=Get.put(GetUserLengthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.AppMainColor,
        title: Text("All Orders")
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('orders')
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
                
                    return Card(
                      elevation: 5,
                      color: AppConstant.TextColor,
                      child: GestureDetector(
                           onTap: () => Get.to(()=>SpecificCustomerOrderScreen(
                        docId  :snapshot.data!.docs[index]['uId'],
                customerName :  snapshot.data!.docs[index]['customerName'],
                          )),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppConstant.AppMainColor,
                          child: Text(Data['customerName'][0]),
                          ),
                          title: Text(Data['customerName']),
                          subtitle: Text(Data['customerPhone']),
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