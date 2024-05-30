import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/getuserlengthcontroller.dart';
import '../../models/user_model.dart';
import '../../utils/app_constants.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  final GetUserLengthController _getUserLengthController=Get.put(GetUserLengthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.AppMainColor,
        title: Obx(()  {
return Text('Users(${_getUserLengthController.usercollectionlength.toString()})');
        }),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .orderBy('createdOn', descending: true)
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
              child: Text('No users found'),
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
                UserModel userModel = UserModel(
                        uId: snapshot.data!.docs[index]['uId'],
                        username: snapshot.data!.docs[index]['username'],
                        email: snapshot.data!.docs[index]
                            ['email'],
                        userImg: snapshot.data!.docs[index]['userImg'],
                        country: snapshot.data!.docs[index]['country'],
                        userAddress: snapshot.data!.docs[index]['userAddress'],
                        street: snapshot.data!.docs[index]['street'],
                        isAdmin: snapshot.data!.docs[index]['isAdmin'],
                        isActive: snapshot.data!.docs[index]['isActive'],
                        city: snapshot.data!.docs[index]['city'],
                        createdOn: snapshot.data!.docs[index]['createdOn'],
                        phone:  snapshot.data!.docs[index]['phone'],
                        userDeviceToken:  snapshot.data!.docs[index]['userDeviceToken']
                        );
                    return Card(
                      elevation: 5,
                      color: AppConstant.TextColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.AppMainColor,
                          backgroundImage:
                              CachedNetworkImageProvider(userModel.userImg,
                              errorListener: () {
                                print("error loading image");
                                Icon(Icons.error);
                              },
                              ),
                        ),
                        title: Text(userModel.username),
                        subtitle: Text(userModel.email),
                        trailing: Icon(Icons.edit),
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