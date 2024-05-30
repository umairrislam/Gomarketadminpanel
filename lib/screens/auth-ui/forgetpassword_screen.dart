import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';


import '../../controllers/forgetpassword_controller.dart';
import '../../utils/app_constants.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final ForgetPasswordController forgetPasswordController =
      Get.put(ForgetPasswordController());
  TextEditingController userEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppConstant.AppMainColor,
          title: Text("Forget Passwrord"),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              children: [
                isKeyboardVisible
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Welcome To My App",
                          style: TextStyle(
                              color: AppConstant.AppMainColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ))
                    : Column(
                        children: [
                          Container(
                              color: AppConstant.AppMainColor,
                              child:
                                  Image.asset("assets/images/Ecommerce.png")),
                        ],
                      ),
                SizedBox(
                  height: Get.height / 20,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: userEmail,
                        cursorColor: AppConstant.AppSecondaryColor,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    )),
                SizedBox(
                  height: Get.height / 30,
                ),
                Material(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppConstant.AppMainColor,
                        borderRadius: BorderRadius.circular(20)),
                    width: Get.width / 2,
                    height: Get.height / 18,
                    child: TextButton(
                      child: Text(
                        "Forget ",
                        style: TextStyle(
                            color: AppConstant
                                .TextColor), // Set text color to white
                      ),
                      onPressed: () async {
                        String email = userEmail.text.trim();

                        if (email.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'PLease enter all details',
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: AppConstant.TextColor,
                            backgroundColor: AppConstant.AppSecondaryColor,
                          );
                        } else {
                          String email = userEmail.text.trim();
                          forgetPasswordController.forgetPasswordMethod(email);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
