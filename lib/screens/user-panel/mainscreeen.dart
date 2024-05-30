import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:admin_panel/screens/user-panel/all_flashsale_productscreen.dart';
import 'package:admin_panel/screens/user-panel/all_productsscreen.dart';
import 'package:admin_panel/screens/user-panel/allcategories_screen.dart';
import 'package:admin_panel/screens/user-panel/cart_screen.dart';
import 'package:admin_panel/widgets/all_products_widget.dart';
import 'package:admin_panel/widgets/flashsale_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/app_constants.dart';
import '../../widgets/banner_widget.dart';
import '../../widgets/category_widget.dart';
import '../../widgets/customdrawerwidget.dart';
import '../../widgets/heading_widget.dart';
import '../auth-ui/welcome_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppConstant.TextColor),
          backgroundColor: AppConstant.AppMainColor,
          title: Text(AppConstant.AppMainName),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () => Get.to(()=>CartScreen()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.shopping_cart),
              ),
            )
          ],
        ),
        drawer: DrawerWidget(),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height / 90.0,
                  ),
                  BannerWidget(),
                  HeadingWidget(
                    headingTitle: "Categories",
                    buttontext: "See more >",
                    onTap: () => Get.to(()=>ALLCategoriesScreen()),
                  ),
                  CategoryWidget(),
                  HeadingWidget(
                    headingTitle: "Flash Sale",
                    buttontext: "See more >",
                    onTap: ()=>Get.to(()=>AllFlashSaleProductScreen()),
                  ),
                  FlashSaleWidget(),
                   HeadingWidget(
                    headingTitle: "All Products",
                    buttontext: "See more >",
                    onTap: ()=>Get.to(()=>AllProductScreen()),
                  ),

                  AllProductWidget(),
                ],
              ),
            ),
            ));
  }
}
