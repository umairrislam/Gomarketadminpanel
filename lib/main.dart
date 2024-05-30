import 'package:admin_panel/screens/adminpanel_mainscreen/adminpanelmainscreen.dart';
import 'package:admin_panel/screens/auth-ui/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';


import 'firebase_options.dart';







void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp( GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminMainScreen(),
    builder: EasyLoading.init(),
  ));
}

