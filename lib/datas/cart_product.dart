import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/datas/product_data.dart';

class CartProduct {

  String cid; //cartId
  String ccategory;
  String productId;
  String size;

  int quantity;

  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document){
    cid = document.documentID;
    ccategory = document.data["category"];
    productId = document.data["productId"];
    quantity = document.data["quantity"];
    size = document.data["size"];
  }

  Map<String, dynamic> toMap(){
    return {
      "category" : ccategory,
      "productId" : productId,
      "quantity" : quantity,
      "size" : size,
      "product" : productData.toResumeMap()
    };
  }

}