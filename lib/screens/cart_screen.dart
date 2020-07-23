import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/login_screen.dart';
import 'package:lojavirtual/screens/order_screen.dart';
import 'package:lojavirtual/tiles/cart_tile.dart';
import 'package:lojavirtual/widget/cart_price.dart';
import 'package:lojavirtual/widget/discount_card.dart';
import 'package:lojavirtual/widget/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {

  int items=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu carrinho", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                return Text(CartModel.of(context).products.length==null ? "0 itens" : "${CartModel.of(context).products.length} Itens", style: TextStyle(color: Colors.white, fontSize: 17.0),);
              },
            )
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model){
          //existem 4 situações nesta tela.
          //Carrinho vazio, usuario precisa fazer login, mostrar itens ou se itens estão carregando
          //primeiro carregando item
          if(model.isLoading && UserModel.of(context).isLoggedIn()){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if(!UserModel.of(context).isLoggedIn()){//segundo caso: usuario nao está logado
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart, size: 80.0, color: Theme.of(context).primaryColor,),
                  SizedBox(height: 16.0,),
                  Text("Faça o login para acessar seu carrinho.", style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
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
          } else if (model.products == null || model.products.length==0){  //condição de produto vazio
            return Center(
              child: Text("Nenhum produto no carrinho", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor), textAlign: TextAlign.center,),
            );
          } else { //exibir os produtos
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map(
                      (product){
                        return CartTile(product);
                      }
                  ).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(() async {
                  //este método já envia uma função para o botão da próxima tela e passamos ele aqui
                  String orderId = await model.finishOrder();
                  if (orderId!=null){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context)=>OrderScreen(orderId)
                      )
                    );
                  }
                })
              ],
            );
          }
        },
      ),
    );
  }


  
}
