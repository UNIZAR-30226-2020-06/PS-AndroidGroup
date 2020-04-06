import 'dart:convert';
import 'dart:developer';
import 'dart:io';


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
  Future<Album> datosRegistro;
  Future<Album> _futureAlbum;
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
                          Align(
                          child: Image.asset("assets/espotify.png")),
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
                                _futureAlbum = createAlbum(usernameController.text);
                              });
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                    return AlertDialog(
                                    // Retrieve the text the that user has entered by using the
                                    // TextEditingController.
                                      content: Text(usernameController.text),

                                    );
                                    },
                                );


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
                          SizedBox(height: 50,
                          child: FutureBuilder<Album>(
                            future: datosRegistro,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data.title);
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              // By default, show a loading spinner.
                              return CircularProgressIndicator();
                            },
                          ),
                          ),

                          SizedBox(height: 40,child: FutureBuilder<Album>(
                            future: _futureAlbum,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data.title);
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              return CircularProgressIndicator();
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

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
  int getUserId(){
    return userId;
  }
}

Future<Album> fetchAlbum() async {
  final response = await http.get('http://34.69.44.48:8080/Espotify/android_testing');

  if (response.statusCode == 500) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Fallo al cargar login');
  }
}

Future<Album> createAlbum(String title) async {
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/android_testing',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}