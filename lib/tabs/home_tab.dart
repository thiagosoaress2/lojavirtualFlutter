import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget _buildBodyBack() => Container( //retorna um container com gradiente
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 211, 118, 130), //cor inicial
            Color.fromARGB(255, 253, 181, 168), //cor final
          ],
              begin: Alignment.topLeft, //inicio
          end: Alignment.bottomRight, //final
        )
      ),
    );

    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true, //fica acima dos elementos
              snap: true, //some conforme role e volta depois se subir
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>( //loading
              future: Firestore.instance.collection("home").orderBy("pos").getDocuments(),  //query
              builder: (context, snapshot) {
                if (!snapshot.hasData){ //se o snapshot for vazio vamos manter o loading na tela
                  return SliverToBoxAdapter(  //adaptador para usar um loading no sliver
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                } else {
                  return SliverStaggeredGrid.count(  //inicia a exibição do tipo grid
                      crossAxisCount: 2, //numero de colunas (mesmo que uma imagem grande vá ocupar as duas
                  mainAxisSpacing: 1.0, //espaçamento vertical
                  crossAxisSpacing: 1.0,  //espaçamento horizontal
                  staggeredTiles: snapshot.data.documents.map( //para passar os X e y que temos no banco de dados, vamos mapear os dados
                      (doc) {
                        return StaggeredTile.count(doc.data["x"], doc.data["y"]);
                      }
                  ).toList(),  //ele armazena todos os x e y em lista
                    children: snapshot.data.documents.map(  //agora um mapa com as imagens
                        (doc){
                          return FadeInImage.memoryNetwork(  //define a aparição suave
                              placeholder: kTransparentImage, //coloca sobre um placeholder transparente
                              image: doc.data["image"],  //armazena a imagem
                          fit: BoxFit.cover,); //define para ocupar todo espaço possível
                        }
                    ).toList(),
                  );
                }
              },
            )
          ],
        ),
      ],
    );
  }
}
