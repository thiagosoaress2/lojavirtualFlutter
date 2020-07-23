import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile( //parte que aparece antes de expandir o card
        title: Text("Calcular frete",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700]
          ),),
        leading: Icon(Icons.location_on), //icone do lado esquerdo
        children: <Widget>[  //o que aparece apos expandir
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite seu CEP"
              ),
              initialValue: "",
              onFieldSubmitted: (text){
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("Sentimos muito. O sistema de calculo do frete ainda não está funcionando."),
                      backgroundColor: Colors.redAccent,)
                );
              },
            ),
          ),

        ],//icone do lado direito
      ),
    );
  }
}
