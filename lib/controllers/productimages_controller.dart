import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProductImagesController extends GetxController{
final ImagePicker _picker=ImagePicker();
RxList<XFile> selectedimages=<XFile>[].obs;
final RxList<String> arrimagesurl=<String>[].obs;
final FirebaseStorage storageRef=FirebaseStorage.instance;
Future <void> showImagesPickerDialog()async{
PermissionStatus status;
DeviceInfoPlugin deviceInfo=DeviceInfoPlugin();
AndroidDeviceInfo androidDeviceInfo=await deviceInfo.androidInfo;
if(androidDeviceInfo.version.sdkInt<=32){
  status =await Permission.storage.request();
}else{
  status=await Permission.mediaLibrary.request();
}
// 
if (status==PermissionStatus.granted){
  Get.defaultDialog(title: "Choose image",
  middleText: 'Pick an image from device or gallery',actions: [
    ElevatedButton(onPressed: () {
      selectImages("camera");
    }, child: Text("Camera")),
    ElevatedButton(onPressed: () {
      selectImages("gallery");
      
    }, child: Text("Gallery")),
  ]);

}
if(status==PermissionStatus.denied){
  print('Error Plz allow permisson for further usage');
  openAppSettings();
}
if(status==PermissionStatus.permanentlyDenied){
  print("Error Plz allow permisson for further usage");
  openAppSettings();
}
}
Future<void> selectImages(String type)async{
List<XFile>imgs=[];
if(type=='gallery'){
  try{
    imgs=await _picker.pickMultiImage(imageQuality: 80);
  }catch(e){
    print("error $e");

  }
}else{
  final img=await _picker.pickImage(source: ImageSource.camera,imageQuality: 80);
if(img!=null){
  imgs.add(img);
  update();

}
}
if(imgs.isNotEmpty){
  selectedimages.addAll(imgs);
  update();
  print(selectedimages.length);
  }}
void removeimages(int index){
  selectedimages.removeAt(index);
  update();

}
}