import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';

class DiscountCard extends StatelessWidget {

  String coupomCode;
  int descountPercent = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile( //parte que aparece antes de expandir o card
        title: Text("Cupom de desconto",
        textAlign: TextAlign.start,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey[700]
        ),),
        leading: Icon(Icons.card_giftcard), //icone do lado esquerdo
        trailing: Icon(Icons.add),
        children: <Widget>[  //o que aparece apos expandir
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom"
              ),
              initialValue: CartModel.of(context).couponCode ?? "",
              onFieldSubmitted: (text){
                Firestore.instance.collection("coupons").document(text).get().then((docSnap){
                  if(docSnap.data != null){
                    CartModel.of(context).setCoupom(text, docSnap.data["percent"]);
                   Scaffold.of(context).showSnackBar(
                       SnackBar(content: Text("Desconto de ${docSnap.data["percent"]} % aplicado."),
                       backgroundColor: Theme.of(context).primaryColor,)
                   );
                  } else {
                    CartModel.of(context).setCoupom(null, 0);
                    SnackBar(content: Text("Cupom inválido."),
                      backgroundColor: Colors.redAccent,);
                  }

                });
              },
            ),
          ),

        ],//icone do lado direito
      ),
    );
  }
}
