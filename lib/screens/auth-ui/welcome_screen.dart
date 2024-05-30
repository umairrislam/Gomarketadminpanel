import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';



import '../../controllers/googlesignin_controller.dart';
import '../../utils/app_constants.dart';
import 'signin_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppConstant.AppMainColor,
        title: Text(
          "Welcome to my app",
          style: TextStyle(color: AppConstant.TextColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: AppConstant.AppMainColor,
                child: Image.asset("assets/images/Ecommerce.png"),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Text(
                    "Happy Shopping",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: Get.height / 12,
              ),
              Material(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppConstant.AppMainColor,
                      borderRadius: BorderRadius.circular(20)),
                  width: Get.width / 1.2,
                  height: Get.height / 12,
                  child: TextButton.icon(
                    icon: Image.network(
                        "https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png"),
                    label: Text(
                      "Sign in with Google",
                      style: TextStyle(
                          color:
                              AppConstant.TextColor), // Set text color to white
                    ),
                    onPressed: () {
                      _googleSignInController.signInwithGoogle();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: Get.height / 50,
              ),
              Material(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppConstant.AppMainColor,
                      borderRadius: BorderRadius.circular(20)),
                  width: Get.width / 1.2,
                  height: Get.height / 12,
                  child: TextButton.icon(
                    icon: Icon(
                      Icons.email,
                      color: AppConstant.TextColor,
                    ),
                    label: Text(
                      "Sign in with Email",
                      style: TextStyle(
                          color:
                              AppConstant.TextColor), // Set text color to white
                    ),
                    onPressed: () {
                      Get.to(() => SigninScreen());
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
