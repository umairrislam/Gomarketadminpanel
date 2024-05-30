import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_constants.dart';


class HeadingWidget extends StatelessWidget {
  final String headingTitle;
 // final String headingSubTitle;
  final VoidCallback onTap;
  final String buttontext;
  const HeadingWidget({super.key, required this.buttontext,required this.headingTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
      child: Padding(padding: EdgeInsets.all(8),child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text( headingTitle,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey.shade800),)
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: AppConstant.AppSecondaryColor,
                )
          
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text( buttontext,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12.0,color: AppConstant.AppSecondaryColor),),
              )),
          )
        ],
      ),),
      
    );
  }
}