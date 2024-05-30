import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../models/user_model.dart';
import '../utils/app_constants.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // password visibility
  var isPasswordVisible = false.obs;

  Future<UserCredential?> signUpMethod(
    String userName,
    String userEmail,
    String userPhone,
    String userCity,
    String userPassword,
    String userDeviceToken,
  ) async {
    try {
      EasyLoading.show(status: "Please wait");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);
//send email verification
      await userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
          uId: userCredential.user!.uid,
          username: userName,
          userImg: '',
          userDeviceToken: userDeviceToken,
          userAddress: '',
          country: '',
          email: userEmail,
          phone: userPhone,
          isActive: true,
          street: '',
          isAdmin: false,
          city: userCity,
          createdOn: DateTime.now());
      // add data into firebase
      _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());
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
