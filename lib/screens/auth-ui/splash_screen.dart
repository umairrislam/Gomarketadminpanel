import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import '../../controllers/getuserdatacontroller.dart';
import '../../utils/app_constants.dart';
import '../adminpanel_mainscreen/adminpanelmainscreen.dart';
import '../user-panel/mainscreeen.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after a delay
    Timer(Duration(seconds: 3), () {
      loggedin(context);
    });
  }

  Future<void> loggedin(BuildContext context) async {
    if (user != null) {
      final GetUserDataController getUserDataController =
          Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);
      if (userData[0]['isAdmin'] == true) {
        Get.off(() => AdminMainScreen());
      } else {
        Get.off(() => MainScreen());
      }
    } else {
      Get.off(() => WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.AppSecondaryColor,
      appBar: AppBar(
        backgroundColor: AppConstant.AppSecondaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: Get.width,
              alignment: Alignment.center,
              child: Text(
                'GoMarket',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.TextColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: Get.width,
              alignment: Alignment.center,
              child: Text(
                AppConstant.AppPoweredBy,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.TextColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Next screen widget
