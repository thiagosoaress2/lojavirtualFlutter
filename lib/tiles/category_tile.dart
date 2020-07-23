import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/screens/product_screen.dart';

class CategoryTile extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(  //classe para listas
      leading: CircleAvatar( //leading icone da esquerda
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ) ,
      title: Text(snapshot.data["title"]),
      trailing: Icon(Icons.keyboard_arrow_right),  //trailing é o icone que ficano final
      onTap: (){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>ProductsScreen(snapshot)
            )
        );
      },
    );
  }
}
