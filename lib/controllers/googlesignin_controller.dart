import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import '../screens/user-panel/mainscreeen.dart';
import 'getdevicetoken_controller.dart';

class GoogleSignInController extends GetxController{

  final GoogleSignIn googleSignIN=GoogleSignIn();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  Future<void> signInwithGoogle()  async{
final GetDevicetokenController getDevicetokenController=Get.put(GetDevicetokenController());
    try {
    final GoogleSignInAccount?googleSignInAccount=
    await googleSignIN.signIn();

    if(googleSignInAccount!=null){
EasyLoading.show(status: "Please wait..");
      final GoogleSignInAuthentication googleSignInAuthentication=  await googleSignInAccount.authentication;
      final AuthCredential credential=GoogleAuthProvider.credential(
accessToken:  googleSignInAuthentication.accessToken,
idToken:  googleSignInAuthentication.idToken,

      );
      final UserCredential userCredential= await  _auth.signInWithCredential(credential);
      final User? user =userCredential.user;
      if(user!=null){
         UserModel userModel=UserModel(
          username: user.displayName.toString(),
          userImg: user.photoURL.toString(), 
          userDeviceToken: getDevicetokenController.deviceToken.toString(),
           userAddress: '',
           city: '',
            country: '', 
            email: user.email.toString(),
             phone: user.phoneNumber.toString(), 
             isActive: true, 
             street: '',
              isAdmin: false,
               uId: user.uid, 
               createdOn: DateTime.now());

             await  FirebaseFirestore.instance.collection('users').doc(user.uid).set(userModel.toMap());
             EasyLoading.dismiss();
              Get.offAll(() =>MainScreen());
      }
      
    }

    }catch(e){
EasyLoading.dismiss();
      print("error$e");
    }
  }
}