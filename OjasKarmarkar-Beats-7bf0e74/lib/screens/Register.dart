import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:beats/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
    )
);

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  Future<Registro> _futureRespuesta;
  TextEditingController controllerNickname;

  @override
  void initState() {
    super.initState();
   // datosRegistro = fetchAlbum();
    //+log(datosRegistro.toString());
  }

  String id;
  String nickName;
  String photoUrl;

  SharedPreferences prefs;

  bool isLoading = false;
  File avatarImageFile;

  final usernameController = TextEditingController();
  final descriptionController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final securePasswordController = TextEditingController();




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
                  Text("Registro", style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(height: 10,),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset("assets/espotify.png"))



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
                                    controller: usernameController,
                                    style: TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                        hintText: "Nombre de usuario*",
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
                                    controller: descriptionController,
                                    style: TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                        hintText: "Descripción",
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
                                    controller: emailController,
                                    style: TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                        hintText: "Correo*",
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
                                    style: TextStyle(fontSize: 16),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: "Contraseña*",
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
                                    controller: securePasswordController,
                                    obscureText: true,
                                    style: TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                        hintText: "Repite la contraseña*",
                                        hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40,),
                          Text("Campos obligatorios*", style: TextStyle(color: Colors.red),),
                          SizedBox(height: 40,),
                          InkWell(
                              onTap: (){ setState(() {
                                _futureRespuesta = esperaRegistro(context, usernameController.text, passwordController.text,
                                securePasswordController.text, descriptionController.text, emailController.text);
                              });
                                  //Navigator.pop(context);
                              },
                              child: new Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.orange[900]
                            ),
                            child: Center(
                              child: Text("Crear cuenta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

                            ),

                            ),
                            ),
                            GestureDetector(
                              onTap: () { Navigator.pop(context); },
                              child: Text("¿Ya tienes cuenta? Inicia sesión"),
                            ),

                          SizedBox(height: 40,child: FutureBuilder<Registro>(
                            future: _futureRespuesta,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text("error en el nuevo usuario");
                              }

                              return Text("");
                            },
                          ),)

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

class Registro {
  final String respuesta;

  Registro({this.respuesta});

  factory Registro.fromJson(Map<String, dynamic> json) {
    return Registro(
      respuesta: json['respuesta'],
    );
  }
  String getUserId(){
    return respuesta;
  }
}

Future<Registro> registrarUsuario(String nombreUsuario, String contrasenya, String repiteContrasenya,
  String descripcion, String correo) async {
  Map data = {
    'nombreUsuario': nombreUsuario,
    'contrasenya': contrasenya,
    'repiteContrasenya': repiteContrasenya,
    'descripcion': descripcion,
    'correo': correo,
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/registro_android',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),

    //body: jsonEncode(<String, String>{
    //  'nombreUsuario': nombreUsuario,
    //}),
  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Registro.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo al enviar petición');
  }
}

Future<Registro> esperaRegistro(BuildContext context, String nombreUsuario, String contrasenya, String repiteContrasenya,
String descripcion, String correo) async {
  Registro l = await registrarUsuario(nombreUsuario, contrasenya, repiteContrasenya,
      descripcion, correo);
  if(l.respuesta!= "error"){
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  return l;
}