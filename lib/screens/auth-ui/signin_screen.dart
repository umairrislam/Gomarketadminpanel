import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';


import '../../controllers/getuserdatacontroller.dart';
import '../../controllers/signin_controller.dart';
import '../../utils/app_constants.dart';
import '../adminpanel_mainscreen/adminpanelmainscreen.dart';
import '../user-panel/mainscreeen.dart';
import 'forgetpassword_screen.dart';
import 'signup_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final SignInController signInController = Get.put(SignInController());
  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppConstant.AppMainColor,
          title: Text("Sign In"),
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
                            prefixIcon: Icon(Icons.email,color: AppConstant.AppSecondaryColor),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppConstant.AppSecondaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            
                            ),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: Get.width,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Obx(
                          () => TextFormField(
                            controller: userPassword,
                            obscureText:
                                signInController.isPasswordVisible.value,
                            cursorColor: AppConstant.AppSecondaryColor,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      signInController.isPasswordVisible
                                          .toggle();
                                    },
                                    child:
                                        signInController.isPasswordVisible.value
                                            ? Icon(Icons.visibility_off,color: AppConstant.AppSecondaryColor)
                                            : Icon(Icons.visibility,color: AppConstant.AppSecondaryColor)),
                                hintText: "Password",
                                prefixIcon: Icon(Icons.password,color: AppConstant.AppSecondaryColor),
                                focusedBorder: OutlineInputBorder(
                                   borderSide: BorderSide(color: AppConstant.AppSecondaryColor),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ))),
                GestureDetector(
                  onTap: () => Get.to(() => ForgetPasswordScreen()),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forget Pasword?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppConstant.AppMainColor),
                    ),
                  ),
                ),
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
                        "Sign in",
                        style: TextStyle(
                            color: AppConstant
                                .TextColor), // Set text color to white
                      ),
                      onPressed: () async {
                        String email = userEmail.text.trim();
                        String password = userPassword.text.trim();
                        if (email.isEmpty || password.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'PLease enter all details',
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: AppConstant.TextColor,
                            backgroundColor: AppConstant.AppSecondaryColor,
                          );
                        } else {
                          UserCredential? userCredential =
                              await signInController.signInMethod(
                                  email, password);
                          var userData = await getUserDataController
                              .getUserData(userCredential!.user!.uid);
                          if (userCredential != null) {
                            if (userCredential.user!.emailVerified) {
                              if (userData[0]['isAdmin'] == true) {
                                Get.offAll(()=>AdminMainScreen());
                                Get.snackbar(
                                "Success Admin Login",
                                'Login successfully',
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: AppConstant.TextColor,
                                backgroundColor: AppConstant.AppSecondaryColor,
                              );
                              } else {
 Get.offAll(()=>AdminMainScreen());
  Get.snackbar(
                                "Success User Login",
                                'Login successfully',
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: AppConstant.TextColor,
                                backgroundColor: AppConstant.AppSecondaryColor,
                              );
                              }

                              Get.snackbar(
                                "Success",
                                'Login successfully',
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: AppConstant.TextColor,
                                backgroundColor: AppConstant.AppSecondaryColor,
                              );
                              Get.offAll(() => MainScreen());
                            } else {
                              Get.snackbar(
                                "Error",
                                'Please verify your email before login',
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: AppConstant.TextColor,
                                backgroundColor: AppConstant.AppSecondaryColor,
                              );
                            }
                          } else {
                            Get.snackbar(
                              "",
                              'Please verify your email before login',
                              snackPosition: SnackPosition.BOTTOM,
                              colorText: AppConstant.TextColor,
                              backgroundColor: AppConstant.AppSecondaryColor,
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height / 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dont have an account?",
                      style: TextStyle(
                          color: AppConstant.AppMainColor, fontSize: 14),
                    ),
                    GestureDetector(
                        onTap: () => Get.offAll(() => SignupScreen()),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              color: AppConstant.AppMainColor,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
