import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../controllers/categorydropdowncontroller.dart';
import '../../controllers/edit_product_controller.dart';
import '../../controllers/is_sale_controller.dart';
import '../../models/product_model.dart';
import '../../utils/app_constants.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel productModel;
  EditProductScreen({super.key, required this.productModel});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final isSaleController issaleController = Get.put(isSaleController());
  final CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();
  final TextEditingController fullPriceController = TextEditingController();
  final TextEditingController deliveryTimeController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productNameController.text = widget.productModel.productName;
    salePriceController.text = widget.productModel.salePrice;
    fullPriceController.text = widget.productModel.fullPrice;
    deliveryTimeController.text = widget.productModel.deliveryTime;
    productDescriptionController.text = widget.productModel.productDescription;
  }

  @override
  void dispose() {
    productNameController.dispose();
    salePriceController.dispose();
    fullPriceController.dispose();
    deliveryTimeController.dispose();
    productDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProductController>(
      init: EditProductController(productModel: widget.productModel),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.AppMainColor,
            title: Text("Edit Product ${widget.productModel.productName}"),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: Get.height / 4.0,
                    child: GridView.builder(
                      itemCount: controller.images.length,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: controller.images[index],
                              fit: BoxFit.contain,
                              height: Get.height / 5.5,
                              width: Get.width / 2,
                              placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            Positioned(
                              right: 10,
                              top: 0,
                              child: InkWell(
                                onTap: () async {
                                  EasyLoading.show();
                                  await controller.deleteImagesFromStorage(controller.images[index]);
                                  await controller.deleteImageFromFireStore(controller.images[index], widget.productModel.productId);
                                  EasyLoading.dismiss();
                                },
                                child: CircleAvatar(
                                  backgroundColor: AppConstant.AppSecondaryColor,
                                  child: Icon(
                                    Icons.close,
                                    color: AppConstant.TextColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  
                  // Drop down
                  GetBuilder<CategoryDropDownController>(
                    init: CategoryDropDownController(),
                    builder: (categoriesDropDownController) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  value: categoriesDropDownController.selectedCategoryId?.value,
                                  items: categoriesDropDownController.categories.map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category['categoryId'],
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(category['categoryImg'].toString()),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(category['categoryName']),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? selectedValue) async {
                                    categoriesDropDownController.setSelectedCategory(selectedValue);
                                    String? categoryName = await categoriesDropDownController.getCategoryName(selectedValue);
                                    categoriesDropDownController.setSelectedCategoryName(categoryName);
                                  },
                                  hint: const Text('Select a category'),
                                  isExpanded: true,
                                  elevation: 10,
                                  underline: const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  // IsSale Switch
                  GetBuilder<isSaleController>(
                    init: isSaleController(),
                    builder: (isSaleController) {
                      return Card(
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Is Sale"),
                              Switch(
                                value: isSaleController.isSale.value,
                                activeColor: AppConstant.AppMainColor,
                                onChanged: (value) {
                                  isSaleController.toggleIsSale(value);
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Product Name
                  SizedBox(height: 10.0),
                  Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      cursorColor: AppConstant.AppMainColor,
                      textInputAction: TextInputAction.next,
                      controller: productNameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintText: "Product Name",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),

                  // Sale Price
                  GetBuilder<isSaleController>(
                    init: isSaleController(),
                    builder: (isSaleController) {
                      return isSaleController.isSale.value
                          ? Container(
                              height: 65,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                cursorColor: AppConstant.AppMainColor,
                                textInputAction: TextInputAction.next,
                                controller: salePriceController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                                  hintText: "Sale Price",
                                  hintStyle: TextStyle(fontSize: 12.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink();
                    },
                  ),

                  // Full Price
                  SizedBox(height: 10.0),
                  Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      cursorColor: AppConstant.AppMainColor,
                      textInputAction: TextInputAction.next,
                      controller: fullPriceController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintText: "Full Price",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),

                  // Delivery Time
                  SizedBox(height: 10.0),
                  Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      cursorColor: AppConstant.AppMainColor,
                      textInputAction: TextInputAction.next,
                      controller: deliveryTimeController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintText: "Delivery Time",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),

                  // Product Description
                  SizedBox(height: 10.0),
                  Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      cursorColor: AppConstant.AppMainColor,
                      textInputAction: TextInputAction.next,
                      controller: productDescriptionController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintText: "Product Desc",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),

                  // Update Button
                  ElevatedButton(
                    onPressed: () async {
                      EasyLoading.show();
                      ProductModel newProductModel = ProductModel(
                        productId: widget.productModel.productId,
                        categoryId: categoryDropDownController.selectedCategoryId.toString(),
                        productName: productNameController.text.trim(),
                        categoryName: categoryDropDownController.selectedCategoryName.toString(),
                        salePrice: salePriceController.text.trim(),
                        fullPrice: fullPriceController.text.trim(),
                        productImages: widget.productModel.productImages,
                        deliveryTime: deliveryTimeController.text.trim(),
                        isSale: issaleController.isSale.value,
                        productDescription: productDescriptionController.text.trim(),
                        createdAt: widget.productModel.createdAt,
                        updatedAt: DateTime.now(),
                      );

                      await FirebaseFirestore.instance
                          .collection('products')
                          .doc(widget.productModel.productId)
                          .update(newProductModel.toMap());

                      EasyLoading.dismiss();
                    },
                    child: Text("Update"),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
