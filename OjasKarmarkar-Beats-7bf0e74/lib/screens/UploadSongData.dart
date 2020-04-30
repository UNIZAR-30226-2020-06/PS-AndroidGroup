import 'dart:developer';
import 'dart:io';

import 'package:beats/icono_personalizado.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'MusicLibrary.dart';

import 'UploadSong.dart';
import 'login.dart';
import 'package:flutter_uploader/flutter_uploader.dart';



class UploadSongDataState extends StatelessWidget   {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  final String archivo;
  final uploader = FlutterUploader();

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  List<String> _locations = ['Rock', 'R&B', 'Pop', 'Metal']; // Option 2
  String _selectedLocation;

  UploadSongDataState({Key key, @required this.archivo}) : super(key: key);


  @override
  Widget build(BuildContext context) {
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
                                        'Información de la canción',
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
                              value: _selectedLocation,
                              onChanged: (newValue) {
                                //setState(() {
                                //_selectedLocation = newValue;
                                //});
                              },
                              items: _locations.map((location) {
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
                    onPressed: () {
                        upload(titleController.text, archivo);
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
  upload(String titulo, String savedDir) async{

    //ahora mismo savedDir contiene toda la dirección hasta la canción
    //tenemos que mantener toda la uri exceto el último elemento, que debemos
    //pasarselo a FileItem como filename y los restante como savedDir
    List<String> uriparts = savedDir.split("/");
    String filename = uriparts.removeLast();  //aquí ya tenemos el contenido.mp3
    String aux;
    savedDir = "/";

    for(int i=1; i<uriparts.length;i++)
    {
      aux = uriparts.elementAt(i);
      savedDir = savedDir + aux;
      if(i+1 != uriparts.length) {
        savedDir = savedDir + "/";
      }
    }

    int a = uriparts.length;
    log("debug $savedDir, $filename, $a");  //podemos ver ahora como el attaching file es == a la uri

    final taskId = await uploader.enqueue(
        url: "https://34.69.44.48:8080/Espotify/cancion_subir_android", //required: url to upload to
        files: [FileItem(filename: filename, savedDir: savedDir, fieldname:"file")], // required: list of files that you want to upload
        method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
        headers: {"tambien": "tambien", "tmb": "tmb"},
        data: {"name": titulo}, // any data you want to send in upload request
        showNotification: false, // send local notification (android only) for upload status
        tag: "upload 1"); // unique tag for upload task
  }

}

