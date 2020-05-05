import 'dart:developer';
import 'dart:io';

import 'package:beats/screens/ProfileEdit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_uploader/flutter_uploader.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';



class UploadPodcastDataState extends StatelessWidget   {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  final String archivo;
  final uploader = FlutterUploader();

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  List<String> generos; // Option 2
  String genero;
  String email;
  String nombrePodcast;


  UploadPodcastDataState({Key key, @required this.archivo, this.email, this.generos, this.nombrePodcast}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    log("gnerasos: $generos");
    return new Scaffold(
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[

                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 200.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Información de el podcast',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Título',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: titleController,
                                      style: TextStyle(fontSize: 16),
                                      decoration: const InputDecoration(
                                          hintText: "Ejemplo123",
                                          hintStyle: TextStyle(fontSize: 15.0)
                                      ),
                                      enabled: !_status,
                                      autofocus: !_status,

                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Género',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: DropdownButton(
                              hint: Text('Elige un género',style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold)), // Not necessary for Option 1
                              value: genero,
                              onChanged: (newValue) {
                                genero = newValue;
                              },
                              items: generos.map((location) {
                                return DropdownMenuItem(
                                  child: new Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),
                          ),


                          !_status ? _getActionButtons(context) : new Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }


  Widget _getActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Guardar"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () async {
                      if(titleController.text != ""){
                        Respuesta r = await uploadSong(email, titleController.text, genero);
                        if(r.getUserId() == "fail"){
                          mostrarError("No se ha podido subir el podcast.", context);
                        }else{
                          mostrarError("podcast subido con éxito.", context);
                        }
                      }
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Cancelar"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Future<Respuesta> uploadSong(String email, String nombreCapitulo, String genero) async {
    File songFile = new File(archivo);
    List<int> songBytes = songFile.readAsBytesSync();
    String base64Song = base64.encode(songBytes);
    Map data = {
      'email': email,
      'nombrePodcast': nombrePodcast,
      'nombreCapitulo': nombreCapitulo,
      'generoCapitulo': genero,
      'capitulo': base64Song,
    };
    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/subir_capitulo_android',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),

    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Respuesta.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Fallo al enviar petición');
    }
  }
  void mostrarError(String textoError, BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AlertDialog(
            backgroundColor:
            Theme.of(context).backgroundColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(),
              borderRadius: BorderRadius.all(
                  Radius.circular(30.0)),
            ),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 50.0,
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Subir podcast",
                        style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Sans'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          top: 30.0,
                          bottom: 30.0),
                      child: Text(textoError)
                  ),
                  InkWell(
                    onTap: () {
                      if(textoError == "No se ha podido subir el podcast."){
                        Navigator.pop(context);
                      }else{
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }

                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                            bottomLeft:
                            Radius.circular(32.0),
                            bottomRight:
                            Radius.circular(32.0)),
                      ),
                      child: Text(
                        "Aceptar",
                        style: TextStyle(
                            fontFamily: 'Sans',
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class Respuesta {
  final String creado;

  Respuesta({this.creado});

  factory Respuesta.fromJson(Map<String, dynamic> json) {
    return Respuesta(
      creado: json['estado'],

    );

  }
  String getUserId(){
    return creado;
  }
}



