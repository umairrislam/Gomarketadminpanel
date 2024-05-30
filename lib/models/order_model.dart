class OrderModel{
final String productId;
final String categoryId;
final String productName;
final String categoryName;
final String salePrice;
final String fullPrice;
final List productImages;
final String deliveryTime;
final bool isSale;
final String productDescription;
final dynamic createdAt;
final dynamic updatedAt;
final int productQuantity;
final double productTotalPrice;
final String customerId;
final bool status;
final String customerName;
final String customerPhone;
final String customerAddress;
final String customerDeviceToken;

OrderModel({ required this.categoryId,required this.categoryName, required this.productName,required this.salePrice,required this.deliveryTime,required this.fullPrice,required this.productDescription,required this.productImages,required this.productId,required this.isSale,required this.createdAt,required this.updatedAt,required this.productQuantity,required this.productTotalPrice, required this.customerId,required this.customerName,required this.customerAddress,required this.customerDeviceToken,required this.customerPhone,required this.status});

 Map<String,dynamic> toMap(){
  return {
    'categoryId':categoryId,
   'productId':productId,
   'productName':productName,
   'salePrice':salePrice,
   'fullPrice':fullPrice,
   'productImages':productImages,
   'deliveryTime':deliveryTime,
   'isSale':isSale,
   'productDescription':productDescription,
    'categoryName':categoryName,
    'createdAt':createdAt,
    'updatedAt':updatedAt,
    'customerId':customerId,
    'productQuantity':productQuantity,
    'productTotalPrice':productTotalPrice,
    'status':status,
    'customerName':customerName,
    'customerPhone':customerPhone,
    'customerAddress':customerAddress,
    'customerDeviceToken':customerDeviceToken,


  };
}
factory OrderModel.fromMap(Map<String,dynamic>json){

  return  OrderModel(

    categoryId: json['categoryId'],
    productId: json['productId'],
    productName: json['productName'],
    productImages: json[' productImages'],
     productDescription: json['productDescription'],
     isSale: json['isSale'],
     salePrice: json['salePrice'],
     fullPrice: json['fullPrice'],
     deliveryTime: json['deliveryTime'],
    categoryName: json['categoryName'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
    productQuantity: json['productQuantity'],
    productTotalPrice: json['productTotaLPrice'],
    customerId: json['customerId'],
    status: json['status'],
    customerName: json['customerName'],
    customerPhone: json['customerPhone'],
    customerAddress: json['customerAddress'],
    customerDeviceToken: json['customerDeviceToken'],
   

  );
}

}