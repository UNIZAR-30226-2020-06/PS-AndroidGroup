import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beats/icono_personalizado.dart';
import 'package:beats/models/MisCancionesModel.dart';
import 'package:beats/models/PlayListHelper.dart';
import 'package:beats/models/PlaylistRepo.dart';
import 'package:beats/models/SongsModel.dart';
import 'package:beats/models/Username.dart';
import 'package:beats/models/const.dart';
import 'package:beats/screens/PlayList.dart';
import 'package:beats/screens/UploadSong.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'MusicLibrary.dart';
import 'package:http/http.dart' as http;

import 'login.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  TextEditingController txt = TextEditingController();
  bool error = false;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController securePasswordController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController playlistController = new TextEditingController();
  Future<Perfil> _futureRespuesta;
  List<String> playlists;
  PlaylistRepo playlistRepo = new PlaylistRepo();
  MisCancionesModel misCanciones = new MisCancionesModel();

  TextEditingController textFieldController = TextEditingController();

  SongsModel model;
  Username username;

  @override
  void initState() {
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    model = Provider.of<SongsModel>(context);
    username = Provider.of<Username>(context);
    playlistRepo = Provider.of<PlaylistRepo>(context);
    misCanciones = Provider.of<MisCancionesModel>(context);
    _futureRespuesta = obtenerPerfil(username.email);
    recibirDatos(username.email, usernameController,
        descriptionController, emailController);

    anyadePlaylists(username.email, playlistRepo, misCanciones);
    return new Scaffold(
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AppBar(
                    actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * 0.003, left: width * 0.85),

                      child: IconButton(
                        iconSize: 35.0,

                        icon: Icon(
                          MyFlutterApp.logout,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          _displayDialog(context);
                        },
                      ),
                    ),
                    ],
                    backgroundColor: Colors.white,
                  ),
                  new Container(
                    height: 250.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
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
                                        'Información personal',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status ? _getEditIcon() : new Container(),
                                    ],
                                  )
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
                                        'Nombre de usuario',
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
                              child:  Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[

                                   Flexible(
                                    child: TextField(

                                      controller: usernameController,
                                      style: TextStyle(fontSize: 16),
                                      decoration: const InputDecoration(
                                        hintText: "Ejemplo123",
                                        hintStyle: TextStyle(fontSize: 15.0)
                                      ),
                                      enabled: _status,
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
                                        'Descripción personal',
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

                                      controller: descriptionController,
                                      style: TextStyle(fontSize: 16),
                                      decoration: const InputDecoration(
                                          hintText: "Eduardo el próximo sucesor de Queen",
                                          hintStyle: TextStyle(fontSize: 15.0)),
                                      enabled: _status,
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
                                        'Email',
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
                                      controller: emailController,
                                      style: TextStyle(fontSize: 16),
                                      decoration: const InputDecoration(
                                          hintText: "ejemplo123@gmail.com",
                                          hintStyle: TextStyle(fontSize: 15.0)),
                                      enabled: _status,
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
                                        'Contraseña',
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
                                      obscureText: true,
                                      style: TextStyle(fontSize: 16),
                                      decoration: const InputDecoration(
                                          hintText: "contraseña123!Ejemplo",
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
                                        'Repetir contraseña',
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
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          hintText: "contraseña123!Ejemplo",
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
                                        'Mis playlists',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),

                          !_status ? _getActionButtons() : new Container(),
                          Padding(
                              padding: EdgeInsets.only(top: height * 0.04),
                              child: SizedBox(
                                height: height * 0.23,
                                child: Consumer<PlaylistRepo>(
                                  builder: (context, playlistRepo, _) => ListView.builder(

                                    itemCount: playlistRepo.playlist.length + 1,
                                    itemBuilder: (context, pos) {



                                      var padd = (pos == 0) ? width * 0.08 : 5.0;
                                      if (pos == (playlistRepo.playlist.length)) {
                                        return GestureDetector(
                                          onTap: () {
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
                                                                "Nueva Playlist",
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
                                                            child: TextFormField(
                                                              controller: txt,
                                                              decoration: InputDecoration(
                                                                  disabledBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Colors
                                                                              .orange)),
                                                                  enabledBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Colors
                                                                              .orange)),
                                                                  errorText: error
                                                                      ? "El nombre no puede ser nulo"
                                                                      : null,
                                                                  errorStyle: Theme.of(context)
                                                                      .textTheme
                                                                      .display2,
                                                                  labelText: "Introduce un nombre",
                                                                  labelStyle: Theme.of(context)
                                                                      .textTheme
                                                                      .display2,
                                                                  border: OutlineInputBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          4))),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              validate(context, playlistRepo);

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
                                                                "¡Crear!",
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
                                          },
                                          child: Card(
                                            margin: EdgeInsets.only(left: padd, right: 5.0),
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(color: Colors.orangeAccent),
                                                borderRadius: BorderRadius.circular(20)),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Container(
                                                    width: width * 0.4,
                                                    child: Center(
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 25,
                                                        )))),
                                          ),
                                        );
                                      } else {
                                        return Card(
                                          margin: EdgeInsets.only(left: padd, right: 5.0),
                                          elevation: 20,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          child: GestureDetector(
                                            onTap: () {
                                              misCanciones.selected = null;
                                              playlistRepo.selected = null;
                                              playlistRepo.selected = pos;
                                              Navigator.of(context).push(new MaterialPageRoute(
                                                  builder: (context) => new PLayListScreen()));
                                            },
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Container(
                                                  width: width * 0.4,
                                                  decoration: BoxDecoration(
                                                    // Box decoration takes a gradient
                                                    gradient: LinearGradient(
                                                      // Where the linear gradient begins and ends
                                                      begin: Alignment.topRight,
                                                      end: Alignment.bottomLeft,
                                                      // Add one stop for each color. Stops should increase from 0 to 1
                                                      stops: [0.1, 0.5, 0.7, 0.9],
                                                      colors: pos % 2 == 0
                                                          ? [
                                                        Colors.orangeAccent,
                                                        Colors.orange,
                                                        Colors.deepOrange,
                                                        Colors.orange,
                                                      ]
                                                          : [
                                                        Colors.pinkAccent,
                                                        Colors.pink,
                                                        Colors.pinkAccent,
                                                        Colors.pink,
                                                      ],
                                                    ),
                                                  ),
                                                  child: Stack(children: <Widget>[
                                                    Align(
                                                      alignment: Alignment.topRight,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.only(top: 8.0),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons.delete_outline,
                                                            size: 17,
                                                            color: Colors.white,
                                                          ),
                                                          onPressed: () async {
                                                            PlaylistHelper temp =
                                                            await PlaylistHelper(
                                                                playlistRepo.playlist[pos]);
                                                            temp.deletePlaylist();
                                                            playlistRepo.delete(
                                                                playlistRepo.playlist[pos]);
                                                            //playlistRepo.init();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.topRight,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(
                                                            right: 30.0, top: 8.0),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons.edit,
                                                            size: 17,
                                                            color: Colors.white,
                                                          ),
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return Padding(
                                                                  padding:
                                                                  const EdgeInsets.all(8.0),
                                                                  child: AlertDialog(
                                                                    backgroundColor:
                                                                    Theme.of(context)
                                                                        .backgroundColor,
                                                                    shape:
                                                                    RoundedRectangleBorder(
                                                                      side: BorderSide(),
                                                                      borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              30.0)),
                                                                    ),
                                                                    contentPadding:
                                                                    EdgeInsets.only(
                                                                        top: 10.0),
                                                                    content: Container(
                                                                      width: 200.0,
                                                                      child: Column(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                        mainAxisSize:
                                                                        MainAxisSize.min,
                                                                        children: <Widget>[
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceEvenly,
                                                                            mainAxisSize:
                                                                            MainAxisSize
                                                                                .min,
                                                                            children: <Widget>[
                                                                              Text(
                                                                                "Editar",
                                                                                style: TextStyle(
                                                                                    fontSize:
                                                                                    24.0,
                                                                                    fontFamily:
                                                                                    'Sans'),
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
                                                                            padding:
                                                                            EdgeInsets.only(
                                                                                left: 30.0,
                                                                                right: 30.0,
                                                                                top: 30.0,
                                                                                bottom:
                                                                                30.0),
                                                                            child:
                                                                            TextFormField(
                                                                              controller: txt,
                                                                              decoration: InputDecoration(
                                                                                  disabledBorder: OutlineInputBorder(
                                                                                      borderSide: BorderSide(
                                                                                          color: Colors
                                                                                              .deepOrange)),
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                      borderSide: BorderSide(
                                                                                          color: Colors
                                                                                              .deepOrange)),
                                                                                  errorText: error
                                                                                      ? "El nombre no puede ser nulo"
                                                                                      : null,
                                                                                  errorStyle: Theme.of(
                                                                                      context)
                                                                                      .textTheme
                                                                                      .display2,
                                                                                  labelText:
                                                                                  "Ponle un nombre",
                                                                                  labelStyle: Theme.of(
                                                                                      context)
                                                                                      .textTheme
                                                                                      .display2,
                                                                                  border: OutlineInputBorder(
                                                                                      borderRadius:
                                                                                      BorderRadius.circular(
                                                                                          4))),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap: () async {
                                                                              await PlaylistHelper(
                                                                                  playlistRepo
                                                                                      .playlist[
                                                                                  pos])
                                                                                  .rename(
                                                                                  txt.text);
                                                                              setState(() {
                                                                                playlistRepo.playlist[
                                                                                pos] =
                                                                                    txt.text;
                                                                                //PlaylistHelper(playlistRepo.playlist[pos]).rename(txt.text);
                                                                                playlistRepo
                                                                                    .push();
                                                                                Navigator.pop(
                                                                                    context);
                                                                              });
                                                                            },
                                                                            child: Container(
                                                                              padding: EdgeInsets
                                                                                  .only(
                                                                                  top: 10.0,
                                                                                  bottom:
                                                                                  20.0),
                                                                              decoration:
                                                                              BoxDecoration(
                                                                                color:
                                                                                Colors.blue,
                                                                                borderRadius: BorderRadius.only(
                                                                                    bottomLeft:
                                                                                    Radius.circular(
                                                                                        32.0),
                                                                                    bottomRight:
                                                                                    Radius.circular(
                                                                                        32.0)),
                                                                              ),
                                                                              child: Text(
                                                                                "Aplicar",
                                                                                style: TextStyle(
                                                                                    fontFamily:
                                                                                    'Sans',
                                                                                    color: Colors
                                                                                        .white),
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .center,
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
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                        child: Text(playlistRepo.playlist[pos],
                                                            style:
                                                            TextStyle(color: Colors.white)))
                                                  ]),
                                                )),
                                          ),
                                        );
                                      }
                                    },
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
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
                                        'Mis canciones',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),

                          Padding(
                              padding: EdgeInsets.only(top: height * 0.08),
                              child: SizedBox(
                                height: height * 0.23,
                                child: new Consumer<MisCancionesModel>(
                                  builder: (context, misCanciones, _) => ListView.builder(

                                    itemCount: 2,
                                    itemBuilder: (context, pos) {

                                      var padd = (pos == 0) ? width * 0.08 : 5.0;
                                      if (pos == (misCanciones.playlist.length + 1)) {
                                        return GestureDetector(
                                          onTap: () {
                                            misCanciones.selected = null;
                                            playlistRepo.selected = null;
                                            misCanciones.selected = pos;
                                            Navigator.of(context).push(new MaterialPageRoute(
                                                builder: (context) => new UploadSong()));
                                          },
                                          child: Card(
                                            margin: EdgeInsets.only(left: padd, right: 5.0),
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(color: Colors.orangeAccent),
                                                borderRadius: BorderRadius.circular(20)),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Container(
                                                    width: width * 0.4,
                                                    child: Center(
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 25,
                                                        )))),
                                          ),
                                        );
                                      } else {
                                        return Card(
                                          margin: EdgeInsets.only(left: padd, right: 5.0),
                                          elevation: 20,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          child: GestureDetector(
                                            onTap: () {
                                              misCanciones.selected = null;
                                              playlistRepo.selected = null;
                                              misCanciones.selected = pos;
                                              Navigator.of(context).push(new MaterialPageRoute(
                                                  builder: (context) => new PLayListScreen()));
                                            },
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Container(
                                                  width: width * 0.4,
                                                  decoration: BoxDecoration(
                                                    // Box decoration takes a gradient
                                                    gradient: LinearGradient(
                                                      // Where the linear gradient begins and ends
                                                      begin: Alignment.topRight,
                                                      end: Alignment.bottomLeft,
                                                      // Add one stop for each color. Stops should increase from 0 to 1
                                                      stops: [0.1, 0.5, 0.7, 0.9],
                                                      colors: pos % 2 == 0
                                                          ? [
                                                        Colors.orangeAccent,
                                                        Colors.orange,
                                                        Colors.deepOrange,
                                                        Colors.orange,
                                                      ]
                                                          : [
                                                        Colors.pinkAccent,
                                                        Colors.pink,
                                                        Colors.pinkAccent,
                                                        Colors.pink,
                                                      ],
                                                    ),
                                                  ),
                                                  child: Stack(children: <Widget>[

                                                    Center(
                                                        child: Text("Mis canciones",
                                                            style:
                                                            TextStyle(color: Colors.white)))
                                                  ]),
                                                )),
                                          ),
                                        );
                                      }
                                    },
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              )),

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


   anyadePlaylists(String email, PlaylistRepo playlistRepo, MisCancionesModel misCanciones) async {
     Perfil p = await obtenerPerfil(email);
     String s = p.playlists;
     if (p.nombreUsuario != null) {
       var playlistss = p.playlists.split('|');
       log('data: $playlistss');
       playlistRepo.generateInitialPlayList(playlistss);

       username.setCanciones(p.canciones);
       username.setCancionesUrl(p.urls);
       List<String> lista = new List<String>();
       lista.add("Mis canciones");
       misCanciones.generateInitialPlayList(lista);
     }
   }
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
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
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
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
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
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


  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AlertDialog(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              backgroundColor: Theme.of(context).backgroundColor,
              actions: <Widget>[
                Padding(padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () { Navigator.push(context, new MaterialPageRoute(
                      builder: (context) =>
                      new LoginPage())); },

                      child: new RaisedButton(
                        child: new Text("Cerrar sesión"),
                        textColor: Colors.black,
                        color: Colors.white,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                      ),
                ),),

                  Padding(padding: EdgeInsets.only(right: 9),
                    child: new RaisedButton(
                      child: new Text("Eliminar cuenta"),
                     textColor: Colors.red,
                      color: Colors.white,
                      onPressed: () {
                      },
                  shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
                  ),),

                  Padding(padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () { Navigator.of(context).pop(); },

                      child: new RaisedButton(
                        child: new Text("Cancelar"),
                        textColor: Colors.black,
                        color: Colors.white,
                        shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  ),
                  ),),

              ],
            ),
          );
        });
  }
  void validate(context, repo) {
    setState(() {
      txt.text.toString().isEmpty ? error = true : error = false;
    });
    if (txt.text.toString().isNotEmpty) {
      crearPlaylist2(emailController.text, txt.text, context, playlistRepo);

      }
  }
  void crearPlaylist2(String email, String nombrePlaylist,
      BuildContext context, PlaylistRepo playlistRepo)async{
    Respuesta r = await crearPlaylist(email, nombrePlaylist);
    if(r.getUserId()=="ok"){
      playlistRepo.add(nombrePlaylist);
    }
    txt.clear();
    Navigator.of(context).pop();

  }


  getLoading(SongsModel model) {
    if (model.songs.length == 0) {
      return Flexible(
          child: Center(
            child: CircularProgressIndicator(),
          ));
    } else {
      return Flexible(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: model.songs.length,
          itemBuilder: (context, pos) {
            return Consumer<PlaylistRepo>(builder: (context, repo, _) {
              return ListTile(
                onTap: () async {
                  model.player.stop();
                  model.playlist = false;
                  model.currentSong = model.songs[pos];


                  //Reset the list. So we can change to next song.
                  model.play();
                },
                leading: CircleAvatar(child: getImage(model, pos)),
                title: Text(
                  model.songs[pos].title,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Sans'),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    model.songs[pos].artist,
                    maxLines: 1,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.display1.color,
                        fontSize: 12,
                        fontFamily: 'Sans'),
                  ),
                ),
              );
            });
          },
        ),
      );
    }
  }

  getImage(model, pos) {
    if (model.songs[pos].albumArt != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child:
          Image.file(File.fromUri(Uri.parse(model.songs[pos].albumArt))));
    } else {
      return Container(
          child: IconButton(
            onPressed: null,
            icon: Icon(
              Icons.music_note,
              color: Colors.white,

            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
            // Box decoration takes a gradient
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: pos % 2 == 0
                  ? [
                Colors.orangeAccent,
                Colors.orange,
                Colors.deepOrange,
                Colors.orange,
              ]
                  : [
                Colors.pinkAccent,
                Colors.pink,
                Colors.pinkAccent,
                Colors.pink,
              ],
            ),
          ));
    }
  }

}

class Perfil {
  final String respuesta;
  final String nombreUsuario;
  final String descripcion;
  final String email;
  final String contrasenya;
  final String repetirContraseya;
  final String playlists;
  final String canciones;
  final String urls;

  Perfil({this.respuesta, this.nombreUsuario, this.descripcion, this.email,
    this.contrasenya, this.repetirContraseya, this.playlists, this.canciones, this.urls});

  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
      nombreUsuario: json['nombreUsuario'],
      descripcion: json['descripcion'],
      email: json['email'],
      playlists: json['lista'],
      canciones: json['audiosTitulo'],
      urls: json['audiosUrl']


    );

  }
  String getUserId(){
    return respuesta;
  }
}

Future<Perfil> obtenerPerfil(String email) async {
  Map data = {
    'email': email,
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/perfil_android',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),

  );


  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Perfil.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo al enviar petición');
  }
}

void recibirDatos(String email, TextEditingController usernameController,
    TextEditingController descriptionController,
    TextEditingController emailController) async{
  Perfil p = await obtenerPerfil(email);
  if(p.nombreUsuario != null){
    usernameController.text = p.nombreUsuario;
    descriptionController.text = p.descripcion;
    emailController.text = p.email;

  }

}

Future<Respuesta> crearPlaylist(String email, String nombrePlaylist) async {
  Map data = {
    'email': email,
    'nombrePlaylist': nombrePlaylist,
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/crear_lista_android',
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



class Respuesta {
  final String creado;

  Respuesta({this.creado});

  factory Respuesta.fromJson(Map<String, dynamic> json) {
    return Respuesta(
      creado: json['creado'],

    );

  }
  String getUserId(){
    return creado;
  }
}




