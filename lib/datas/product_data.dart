import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {

  String category;
  String id;    //cada detalhe do meu item
  String title;
  String description;

  double price;

  List images;
  List sizes;

  ProductData(); //permite acessar este item de qualquer lugar

  ProductData.fromDocument(DocumentSnapshot snapshot){ //recupera do Banco de dados
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
   price = snapshot.data["price"] + 0.0;
   images = snapshot.data["images"];
   sizes = snapshot.data["sizes"];
  }

  Map<String, dynamic> toResumeMap(){  //um resumo com apenas estas informações para ser acessado de fora da classe
    return {
      "title": title,
      //"description" : description,
      "price" : price

    };
  }

}