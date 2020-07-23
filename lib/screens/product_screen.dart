import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/tiles/product_tile.dart';

class ProductsScreen extends StatelessWidget {

  final DocumentSnapshot snapshot;

  ProductsScreen(this.snapshot);


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(  //vamos definir uma barra com dois botões e opções de trocar a visualizaão (lista e grid)
      length: 2, //quantidade de opções (lista e grid, apenas duas entao)
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data["title"]),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,  //cor da opção selecionada
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on),),
              Tab(icon: Icon(Icons.list),),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("products").document(snapshot.documentID).collection("itens").getDocuments(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return TabBarView(
                physics: NeverScrollableScrollPhysics(), //impede de trocar de modo de exibição arrastando pro lado
                children: <Widget>[
                    GridView.builder(  //exibindo tipo grid
                        padding: EdgeInsets.all(4.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, //quantidade de itens na horizontal
                          mainAxisSpacing: 4.0, //espaçamentos
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 0.65 //altura / largura
                        ),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index){
                          ProductData data = ProductData.fromDocument(snapshot.data.documents[index]);
                          data.category = this.snapshot.documentID;
                          return ProductsTile("grid", data);  //utilizando a classe
                        }),
                  ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index){
                        ProductData data = ProductData.fromDocument(snapshot.data.documents[index]);
                        data.category = this.snapshot.documentID;
                        return ProductsTile("list", data);  //utilizando a classe
                      }),
                ],
              );
            }
          },
        )
      ),
    );
  }
}
