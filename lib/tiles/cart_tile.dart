import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/models/cart_model.dart';


class CartTile extends StatelessWidget {

  final CartProduct cartProduct;

  //BuildContext context;

  CartTile(this.cartProduct);

  Widget _buildContent(BuildContext context) {

    CartModel.of(context).updatePrices();

    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          width: 120.0,
          child: Image.network(
            cartProduct.productData.images[0],
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  cartProduct.productData.title,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                Text(
                  "Tamanho ${cartProduct.size}",
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                ),
                Text("R\$ ${cartProduct.productData.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 16.0, color: Colors.blueGrey)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      color: Colors.blueGrey,
                      onPressed: cartProduct.quantity > 1
                          ? () {
                        CartModel.of(context).decProduct(cartProduct);
                      }
                          : null,
                    ),
                    Text(cartProduct.quantity.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        CartModel.of(context).incProduct(cartProduct);
                      },
                    ),
                    FlatButton(
                      child: Text("Remover"),
                      textColor: Colors.grey[500],
                      onPressed: () {
                        CartModel.of(context).removeCartItem(cartProduct);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: cartProduct.productData == null
            ? FutureBuilder<DocumentSnapshot>(
                //se aidna não tem os dados do produto, vamos busca-lo e em seguda construir o widget card com informações (_buildContent)
                future: Firestore.instance
                    .collection("products")
                    .document(cartProduct.ccategory)
                    .collection("itens")
                    .document(cartProduct.productId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    cartProduct.productData =
                        ProductData.fromDocument(snapshot.data);
                    return _buildContent(context);
                  } else {
                    return Container(
                      height: 70.0,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  }
                },
              )
            : _buildContent(context) //Caso já tenha os dados, construir o card
        );
  }

}



