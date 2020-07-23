import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/login_screen.dart';
import 'package:lojavirtual/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {

  //construtor. Este construtor vai possibilitar passar o pagecontroler da home_screen para aqui
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {

    Widget _buildDrawerBack() => Container( //retorna um container com gradiente para o fundo.
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 203, 236, 241), //cor inicial
              Colors.white, //cor final
            ],
            begin: Alignment.topCenter, //inicio
            end: Alignment.bottomCenter, //final
          )
      ),
    );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),  //o padding top é obrigatório pois no iphone existem elementos no alto da tela e poderiam tampar
            children: <Widget>[
              Container( //cabeçalho
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Text("Loja \nFlutter", style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(!model.isLoggedIn() ? "Olá" : "Olá, ${model.userData["name"]}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: GestureDetector(
                                    child: Text(!model.isLoggedIn() ? "Entre ou cadastre-se" : "Sair", style: TextStyle(color: Theme.of(context).primaryColor),),
                                    onTap: () {
                                      if(model.isLoggedIn()){
                                        model.signOut();
                                      } else {
                                        //entrar ou cadastrar click
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context)=>LoginScreen())
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      ) ,
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "início", pageController, 0, Theme.of(context).primaryColor), //cada comando desse desenha uma linha. Basta alterar o parametro aqui
              DrawerTile(Icons.list, "Produtos", pageController, 1, Theme.of(context).primaryColor),
              DrawerTile(Icons.location_on, "Lojas", pageController, 2, Theme.of(context).primaryColor),
              DrawerTile(Icons.playlist_add_check, "Meus pedidos", pageController, 3, Theme.of(context).primaryColor),
            ],
          )
        ],
      ),
    );
  }
}
