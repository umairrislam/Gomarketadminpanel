import 'package:flutter/material.dart';

class keyBoardUtils{
  static void  hideKeyBoard(BuildContext context){

    FocusScopeNode currentFocus=FocusScope.of(context);
    if(!currentFocus.hasPrimaryFocus){
      currentFocus.unfocus();
    }
  }
}