import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';



import '../../controllers/signup_controller.dart';
import '../../utils/app_constants.dart';
import 'signin_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignUpController signUpController = Get.put(SignUpController());
  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppConstant.AppMainColor,
          title: Text("Sign up"),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height / 40,
                ),
                Container(
                    alignment: Alignment.center,
                    //margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Welcome To My App",
                      style: TextStyle(
                          color: AppConstant.AppMainColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: Get.height / 20,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: userName,
                        cursorColor: AppConstant.AppSecondaryColor,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: "Name",
                            prefixIcon: Icon(Icons.person,color: AppConstant.AppSecondaryColor),
                            focusedBorder: OutlineInputBorder(
                               borderSide: BorderSide(color: AppConstant.AppSecondaryColor),
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    )),
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
                            )),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: userPhone,
                        cursorColor: AppConstant.AppSecondaryColor,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            hintText: "Phone",
                            prefixIcon: Icon(Icons.phone,color: AppConstant.AppSecondaryColor),
                            focusedBorder: OutlineInputBorder(
                               borderSide: BorderSide(color: AppConstant.AppSecondaryColor),
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: userCity,
                        cursorColor: AppConstant.AppSecondaryColor,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                            hintText: "Location",
                            prefixIcon: Icon(Icons.location_pin,color: AppConstant.AppSecondaryColor),
                             focusedBorder: OutlineInputBorder(
                               borderSide: BorderSide(color: AppConstant.AppSecondaryColor),
                              
                              borderRadius: BorderRadius.circular(10),
                            )),
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
                                signUpController.isPasswordVisible.value,
                            cursorColor: AppConstant.AppSecondaryColor,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      signUpController.isPasswordVisible
                                          .toggle();
                                    },
                                    child:
                                        signUpController.isPasswordVisible.value
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
                        "Sign up",
                        style: TextStyle(
                            color: AppConstant
                                .TextColor), // Set text color to white
                      ),
                      onPressed: () async {
                        String name = userName.text.trim();
                        String email = userEmail.text.trim();
                        String city = userCity.text.trim();
                        String phone = userPhone.text.trim();
                        String password = userPassword.text.trim();
                        String userDeviceToken = '';
                        if (name.isEmpty ||
                            email.isEmpty ||
                            city.isEmpty ||
                            phone.isEmpty ||
                            password.isEmpty) {
                          Get.snackbar(
                            "Error ",
                            'Please enter all details',
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: AppConstant.TextColor,
                            backgroundColor: AppConstant.AppSecondaryColor,
                          );
                        } else {
                          UserCredential? userCredential =
                              await signUpController.signUpMethod(name, email,
                                  phone, city, password, userDeviceToken);
                          if (userCredential != null) {
                            Get.snackbar(
                              "Verification email sent",
                              'Please check your email',
                              snackPosition: SnackPosition.BOTTOM,
                              colorText: AppConstant.TextColor,
                              backgroundColor: AppConstant.AppSecondaryColor,
                            );
                            FirebaseAuth.instance.signOut();
                            Get.offAll(() => SigninScreen());
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
                      "Already have an account?",
                      style: TextStyle(
                          color: AppConstant.AppMainColor, fontSize: 14),
                    ),
                    GestureDetector(
                        onTap: () => Get.offAll(() => SigninScreen()),
                        child: Text(
                          "Sign in",
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
