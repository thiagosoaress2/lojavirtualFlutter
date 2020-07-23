import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  final _formKey = GlobalKey<FormState>();  //key do form para validação e contato com o botão de login

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text("Criar conta", style: TextStyle(fontSize: 15.0),),
            textColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context)=>SignUpScreen()),
              );
            },
          )
        ],
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
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: "E-mail"
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) { //validação dos dados
                      if (text.isEmpty || !text.contains("@")) {
                        return "E-mail inválido";
                      }
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField( //campo senha
                    controller: _passController,
                    decoration: InputDecoration(
                        hintText: "Senha"
                    ), obscureText: true,
                    validator: (text) {
                      if (text.isEmpty) {
                        return "Informe a senha";
                      } else if (text.length < 8) {
                        return "Senha inválida";
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        if(_emailController.text.isEmpty){
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("Insira seu e-mail para enviarmos nova senha"), backgroundColor: Colors.red, duration: Duration(seconds: 3),)
                          );
                        } else {
                          model.recoverPass(_emailController.text);
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("Verifique seu e-mail."), backgroundColor: Colors.red, duration: Duration(seconds: 3),)
                          );
                        }
                      },
                      child: Text(
                        "Esqueci a senha", textAlign: TextAlign.right,),

                    ),
                  ),
                  SizedBox(height: 16.0,),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text("Entrar",
                          style: TextStyle(fontSize: 18.0,)),
                      textColor: Colors.white,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      onPressed: () {
                        if (_formKey.currentState
                            .validate()) { // validação do formulário
                          //Se chegou aqui a validação estava ok. fazer login
                          model.signIn(_emailController.text, _passController.text, () {_onSucess(); }, () {_onFailure(); });
                        }

                      },
                    ),
                  )

                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _onSucess(){

    Navigator.of(context).pop();
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Você está logado"), backgroundColor: Theme.of(context).primaryColor, duration: Duration(seconds: 3),)
    );

  }

  void _onFailure(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Ops, algo deu errado"), backgroundColor: Colors.red, duration: Duration(seconds: 5),)
    );

  }
}


