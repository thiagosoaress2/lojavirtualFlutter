import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            if(model.isLoading){
              return Center(child: CircularProgressIndicator(),);
            } else {
              return Form( //inicio do formulário
                key: _formKey,
                child: ListView( //campo e-mail
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          hintText: "Nome completo"
                      ),
                      validator: (text) { //validação dos dados
                        if(text.isEmpty){
                          return "Informe o nome";
                        }
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "E-mail"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) { //validação dos dados
                        if(text.isEmpty || !text.contains("@")){
                          return "E-mail inválido";
                        }
                      },
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(  //campo senha
                      controller: _passController,
                      decoration: InputDecoration(
                          hintText: "Senha"
                      ),obscureText: true,
                      validator: (text) {
                        if(text.isEmpty){
                          return "Informe a senha";
                        } else if(text.length<8){
                          return "Senha inválida";
                        }
                      },
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                          hintText: "Endereço"
                      ),
                      validator: (text) { //validação dos dados
                        if(text.isEmpty){
                          return "Informe o Endereço";
                        }
                      },
                    ),
                    SizedBox(height: 16.0,),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text("Cadastrar",
                            style: TextStyle(fontSize: 18.0, )), textColor: Colors.white, color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if(_formKey.currentState.validate()){  // validação do formulário
                            //Se chegou aqui a validação estava ok. fazer login

                            //colocamos as informações dentro do mapa
                            Map<String, dynamic> userData = {
                              "name" : _nameController.text,
                              "email" : _emailController.text,
                              "address" : _addressController.text
                            };

                            model.signUp(userData, _passController.text, () {_onSucess();}, () {_onFailure();});
                          }
                        },
                      ),
                    )

                  ],
                ),
              );
            }
          },
        )
    );
  }

  void _onSucess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Usuário criado com sucesso!"), backgroundColor: Theme.of(context).primaryColor, duration: Duration(seconds: 3),)
    );
    Future.delayed(Duration(seconds: 3)).then((_){
      Navigator.of(context).pop();

    });
  }

  void _onFailure(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("O usuário não foi criado. Um erro ocorreu"), backgroundColor: Colors.red, duration: Duration(seconds: 5),)
    );

  }
}
