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
                    height: 230.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: new ExactAssetImage(
                                            'assets/prof.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child: new Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),
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
                                  left: 25.0, right: 25.0, top: 25.0),
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
                                        'Título*',
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
                                        'Descripción',
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
                                      style: TextStyle(fontSize: 16),
                                      decoration: const InputDecoration(
                                          hintText: "Eduarding la vida loca",
                                          hintStyle: TextStyle(fontSize: 15.0)),
                                      enabled: !_status,
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
                                        'Álbum',
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
                                      style: TextStyle(fontSize: 16),
                                      decoration: const InputDecoration(
                                          hintText: "Grandes éxitos de Eduardo",
                                          hintStyle: TextStyle(fontSize: 15.0)),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),

                          !_status ? _getActionButtons() : new Container(),
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


  Widget _getActionButtons() {
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
  upload(String filename, String savedDir) async{
    final taskId = await uploader.enqueue(
        url: "https://34.69.44.48:8080/Espotify/cancion_subir_android", //required: url to upload to
        files: [FileItem(filename: filename, savedDir: savedDir, fieldname:"file")], // required: list of files that you want to upload
        method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
        headers: {"tambien": "tambien", "tmb": "tmb"},
        data: {"name": "cualquier cosa"}, // any data you want to send in upload request
        showNotification: false, // send local notification (android only) for upload status
        tag: "upload 1"); // unique tag for upload task
  }

}

