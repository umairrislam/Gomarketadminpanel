import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../utils/app_constants.dart';

class GetDevicetokenController extends GetxController{
  String? deviceToken;
  @override
  void onInit(){
    super.onInit();
    getDeviceToken();
  }
  Future<void> getDeviceToken()async{
 try{
String?token= await FirebaseMessaging.instance.getToken();
if(token!=null){
  deviceToken=token;
  print("token:$deviceToken");
  update();
}

 }catch(e){
   Get.snackbar(
        "Error ",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppConstant.TextColor,
        backgroundColor: AppConstant.AppSecondaryColor,
      );
 }
  }
}
