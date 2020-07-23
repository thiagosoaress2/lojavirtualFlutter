import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/login_screen.dart';
import 'package:lojavirtual/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    if (UserModel.of(context).isLoggedIn()){

      String uid = UserModel.of(context).firebaseUser.uid;

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("users").document(uid).collection("orders").getDocuments(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data.documents.map((doc)=>OrderTile(doc.documentID)).toList().reversed.toList()
            );
          }
        },
      );

    } else { //se nao estiver logado exibir uma tela pedindo para fazer login
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.format_list_numbered, size: 80.0, color: Theme.of(context).primaryColor,),
            SizedBox(height: 16.0,),
            Text("Faça o login para acompanhar seus pedidos.", style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            SizedBox(height: 16.0,),
            RaisedButton(
              child: Text("Entrar", style: TextStyle(color: Colors.white, fontSize: 18.0),),
              color: Theme.of(context).primaryColor,
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>LoginScreen())
                );
              },
            )
          ],
        ),
      );
    }
  }
}