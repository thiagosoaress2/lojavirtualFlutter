import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/login_screen.dart';

import 'cart_screen.dart';

class ProductInfoScreen extends StatefulWidget {

  final ProductData product;
  ProductInfoScreen(this.product);

  @override
  _ProductInfoScreenState createState() => _ProductInfoScreenState(product);
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {

  final ProductData product;
  _ProductInfoScreenState(this.product);

  String selectedSize;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map((url){  //precisa ser um array de imagens. Então pegamos nossos dados em formato url e convertemos em imagens antes de passar
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,  //tamanho do pontinho que mostra em qual parte está (cada imagem será um pontinho)
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: Theme.of(context).primaryColor,
              autoplay: false,   //troca imagens automaticamente
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                  Text(product.title, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500), maxLines: 3,),
                Text("R\$ ${product.price.toStringAsFixed(2)}", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
                SizedBox(height: 16.0,),
                Text("Tamanho", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),),
                SizedBox(height: 34.0,
                child: GridView(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.5,
                  ),
                  children: product.sizes.map(
                      (sizes) {
                          return GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                border: Border.all(
                                  color: sizes == selectedSize ? Theme.of(context).primaryColor : Colors.grey[500],
                                  width: 3.0
                                )
                              ),
                              width: 50.0,
                              alignment: Alignment.center,
                              child: Text(sizes),
                            ),
                            onTap: (){
                              setState(() {
                                selectedSize = sizes;
                              });
                            }
                          );
                      }
                  ).toList(),
                ),
                ),
                SizedBox(height: 16.0,),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: selectedSize != null ? () {
                      if(UserModel.of(context).isLoggedIn()){
                        //adicionar ao carrinho
                        CartProduct cartProduct = CartProduct();
                        cartProduct.size = selectedSize;
                        cartProduct.quantity = 1;
                        cartProduct.productId = product.id;
                        cartProduct.ccategory = product.category;

                        cartProduct.productData = product;

                        CartModel.of(context).addCartItem(cartProduct);

                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>CartScreen())
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>LoginScreen())
                        );
                      }
                    } : null,
                    child: Text(UserModel.of(context).isLoggedIn() ? "Adicionar ao carrinho" : "Fazer login para comprar", style: TextStyle(fontSize: 18.0),),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0,),
                Text("Descrição", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),),
                Text(product.description, style: TextStyle(fontSize: 16.0),)

              ],
            ),
          )
        ],
      ),
    );
  }
}

