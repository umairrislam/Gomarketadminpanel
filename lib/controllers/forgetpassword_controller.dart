import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../models/user_model.dart';
import '../utils/app_constants.dart';

class ForgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> forgetPasswordMethod(
    String userEmail,
  ) async {
    try {
      EasyLoading.show(status: "Please wait");

      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar(
        "Request sent successfully ",
        "Please reset link sent to $userEmail",
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppConstant.TextColor,
        backgroundColor: AppConstant.AppSecondaryColor,
      );

      // add data into firebase

      EasyLoading.dismiss();
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
