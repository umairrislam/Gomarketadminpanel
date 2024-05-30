import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../models/user_model.dart';
import '../utils/app_constants.dart';

class SignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // password visibility
  var isPasswordVisible = false.obs;

  Future<UserCredential?> signInMethod(
   
    String userEmail,
    String userPassword,
   
  ) async {
    try {
      EasyLoading.show(status: "Please wait");
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
              email: userEmail, password: userPassword);


     
      // add data into firebase
     
      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
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
