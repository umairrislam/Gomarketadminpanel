class ProductModel{
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
ProductModel({ required this.categoryId,required this.categoryName, required this.productName,required this.salePrice,required this.deliveryTime,required this.fullPrice,required this.productDescription,required this.productImages,required this.productId,required this.isSale,required this.createdAt,required this.updatedAt});

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
    'createdAT':createdAt,
    'updatedAt':updatedAt,
    

  };
}
factory ProductModel.fromMap(Map<String,dynamic>json){

  return  ProductModel(

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
   

  );
}

}