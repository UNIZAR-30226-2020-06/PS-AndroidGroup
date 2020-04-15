import 'dart:convert';
import 'dart:io';

import 'package:beats/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Register.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {

  var index = 1;
  var screens = [RegisterPage()];

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  TextEditingController controlador = TextEditingController();
  Future<Login> _futureRespuesta;
  @override
  void initState() {
    super.initState();
    controlador.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.orange[900],
                  Colors.orange[800],
                  Colors.orange[400]
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 25,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10,),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset("assets/espotifylogo.png"))



                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[

                        SizedBox(height: 60,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(225, 95, 27, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )]
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextField(
                                  controller: emailController,
                                  style: TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                      hintText: "Correo electrónico",
                                      hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  style: TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                      hintText: "Contraseña",
                                      hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40,),
                        Text("¿Olvidaste la contraseña?", style: TextStyle(color: Colors.blue),),
                        SizedBox(height: 40,),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            esperaLogin(context, emailController.text, passwordController.text, controlador);
                          });
                         },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.orange[900]
                          ),
                          child: Center(
                            child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                        GestureDetector(
                          onTap: () { Navigator.push(context, new MaterialPageRoute(
                              builder: (context) =>
                              new RegisterPage())); },
                          child: Text("¿No tienes cuenta? Regístrate"),
                        ),
                        SizedBox(height: 40,child: Text(controlador.text))
                          ],
                        )

                    ),
                  ),
    ),
    ),
    ],
                  ),
      ),
                );


  }

}



class Login {
  final String respuesta;

  Login({this.respuesta});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      respuesta: json['respuesta'],
    );
  }
  String getUserId(){
    return respuesta;
  }
}

Future<Login> logearUsuario(String email, String contrasenya) async {
  Map data = {
    'email': email,
    'contrasenya': contrasenya,
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/validacion_android',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),

  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Login.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo al enviar petición');
  }
}

void esperaLogin(BuildContext context, String email,String contrasenya, TextEditingController controlador) async {
  Login l = await logearUsuario(email, contrasenya);
  if(l.respuesta!= "error"){
    Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
  }else{
    controlador.text = "Login sin éxito";
  }

}