import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/screens/product_info_screen.dart';

class ProductsTile extends StatelessWidget {

  final String type;
  final ProductData product;

  ProductsTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>ProductInfoScreen(product))
        );
      },
      child: Card(
        child: type == "grid" ?  //se for tipo grid, exibe coluna
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.8,
              child: Image.network(product.images[0], fit: BoxFit.cover,),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(product.title, style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      child: Text("R\$ ${product.price.toStringAsFixed(2)}", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 17.0, fontWeight: FontWeight.bold), ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ) :
        Row(   //senao será uma row
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Image.network(product.images[0], fit: BoxFit.cover, height: 250.0,),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(product.title, style: TextStyle(fontWeight: FontWeight.w500),),
                    Text("R\$ ${product.price.toStringAsFixed(2)}", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 17.0, fontWeight: FontWeight.bold), ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

