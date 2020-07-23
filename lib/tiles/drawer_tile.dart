import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  //esta classe desenha o widget que vai ser uma linha do menu (icone e nome)

  final IconData icon; //icone escolhido
  final String text; //texto
  final PageController pageController;  //controler para puder mudar pagina
  final int page; //qual pagina ele representa
  final Color color;

  DrawerTile(this.icon, this.text, this.pageController, this.page, this.color); //construtor

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          pageController.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon, size: 32.0,
                color: pageController.page.round() == page ?
                //Theme.of(context).primaryColor : Colors.grey[700],
                color : Colors.grey[700],
              ),
              SizedBox(width: 32.0,),
              Text(
                text, style: TextStyle(fontSize: 16.0,
                color: pageController.page.round() == page ?
                color : Colors.grey[700],),
              )
            ],
          ),
        ),
      ),
    );
  }
}
