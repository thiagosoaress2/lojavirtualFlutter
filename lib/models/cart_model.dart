import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  UserModel user;

  String couponCode;
  int discountPercentage = 0;

  List<CartProduct> products = [];

  bool isLoading = false;

  CartModel(this.user){
    if(user.isLoggedIn()){
      _loadCartItens();
    }
  }


  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").add(cartProduct.toMap()).then((doc) {
      cartProduct.cid = doc.documentID; //pegando o id que o firebase gerou e incluindo no carrinho
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
      Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).delete();

      products.remove(cartProduct);
      notifyListeners();
  }

  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.productId).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.productId).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void updatePrices(){
    notifyListeners();
  }

  double getProductPrice(){
    double price = 0.0;
    for (CartProduct c in products){
      if(c.productData != null){
        price += c.quantity*c.productData.price;
      }
    }
    return price;
  }

  double getDiscount(){
    return getProductPrice()* discountPercentage / 100;
  }

  double getShipPrice(){
    return 10.00;
  }


  void _loadCartItens() async {

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();

    products = query.documents.map((doc) =>
      CartProduct.fromDocument(doc)
    ).toList();

    notifyListeners();
  }

  void setCoupom(String coupomCode, int percentage){
    this.couponCode = coupomCode;
    this.discountPercentage = percentage;
  }

  Future<String> finishOrder() async {

    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners(); //para aparecer o loading

    double productsPrice = getProductPrice();
    double shipPrice = getShipPrice();
    double discountPrice = getDiscount();
    
    //registrando o pedido no bd dos pedidos
    DocumentReference refOrder = await Firestore.instance.collection("orders").add({
      "clientId" : user.firebaseUser.uid,
      "products" : products.map((cartProduct)=>cartProduct.toMap()).toList(),
      "shipPrice" : shipPrice,
      "productsPrice" :productsPrice,
       "discountPrice": discountPrice,
    "totalPrice": (productsPrice-discountPrice)+shipPrice,
    "status" : 1

    });

    //criando uma entrada no bd do user com o mesmo id do pedido para facilitar busca no futuro
    await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("orders").document(refOrder.documentID).setData({
      "orderId": refOrder.documentID.toString()
    });

    //vamos pegar os dados do carrinho pra apagar
    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();
    couponCode = null;
    discountPercentage= 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }

}