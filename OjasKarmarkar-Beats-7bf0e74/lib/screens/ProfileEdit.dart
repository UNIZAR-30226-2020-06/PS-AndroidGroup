import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:beats/icono_personalizado.dart';
import 'package:beats/models/MisCancionesModel.dart';
import 'package:beats/models/PlayListHelper.dart';
import 'package:beats/models/PlaylistRepo.dart';
import 'package:beats/models/PodcastRepo.dart';
import 'package:beats/models/SongsModel.dart';
import 'package:beats/models/Username.dart';
import 'package:beats/models/const.dart';
import 'package:beats/screens/PlayList.dart';
import 'package:beats/screens/UploadSong.dart';
import 'package:beats/screens/uploadPodcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'MusicLibrary.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/painting.dart' as painting;
import 'Podcasts.dart';
import 'login.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool editNoPresionado = true;
  bool editPasswordNoPresionado = true;
  final FocusNode myFocusNode = FocusNode();
  TextEditingController txt = new TextEditingController();
  TextEditingController txtDescripcion = new TextEditingController();
  bool error = false;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController securePasswordController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController playlistController = new TextEditingController();
  TextEditingController controlador = new TextEditingController();
  List<String> playlists;
  PlaylistRepo playlistRepo = new PlaylistRepo();
  PodcastRepo podcastRepo = new PodcastRepo();
  MisCancionesModel misCanciones = new MisCancionesModel();

  TextEditingController textFieldController = TextEditingController();

  SongsModel model;
  Username username;

  File _profileImage;
  File _playlistImage;
  File _podcastImage;
  String numeroSeguidores = "Seguidores: ";
  String imagenPerfil;
  String imagenPlaylist;
  String imagenPodcast;

  Future getImageFromDevice(String opcionOrigen, String opcionDestino) async {
    if(opcionOrigen == "cámara"){
      if(opcionDestino == "perfil"){
        var image = await ImagePicker.pickImage(source: ImageSource.camera);
        setState(() {
          _profileImage = image;
          uploadProfilePicture(username.email);
        });
      }else{
        var image = await ImagePicker.pickImage(source: ImageSource.camera);

        setState(() {
          _playlistImage = image;
        });
      }
    }else{
      if(opcionDestino == "perfil"){
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          _profileImage = image;
          uploadProfilePicture(username.email);
        });
      }else{
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);

        setState(() {
          _playlistImage = image;
        });
      }
    }

  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies() {
    model = Provider.of<SongsModel>(context);
    username = Provider.of<Username>(context);
    playlistRepo = Provider.of<PlaylistRepo>(context);
    podcastRepo = Provider.of<PodcastRepo>(context);
    misCanciones = Provider.of<MisCancionesModel>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    recibirDatos(username.email, usernameController,
        descriptionController, emailController, passwordController);
    setState(() {
      anyadeDatosUsuario(username.email, playlistRepo, misCanciones, podcastRepo);

    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

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
                                new GestureDetector(onTap: ampliarImagen,child: CircleAvatar(
                                    radius: 75.0,
                                    backgroundImage: imagenPerfil == null
                                        ? new ExactAssetImage(
                                        'assets/prof.png')
                                        : NetworkImage(imagenPerfil),
                                    backgroundColor: Colors.transparent,
                                    )),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new GestureDetector(onTap: seleccionarImagen,child:new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child: new Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    )),

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
                                      editNoPresionado ? _getEditIcon() : new Container(),
                                    ],
                                  )
                                ],
                              )),

                          mostrarApartado("Nombre de usuario"),
                          mostrarTextfield("Ejemplo123", usernameController),
                          mostrarApartado("Descripción personal"),
                          mostrarTextfield("Eduardo el próximo sucesor de Queen", descriptionController),
                          mostrarApartado("Email"),
                          mostrarTextfield("ejemplo123@gmail.com", emailController),
                          //if(!editNoPresionado){
                          !editNoPresionado
                              ? _getActionButtons()
                              : new Container(),
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
                                      numeroSeguidores,
                                      style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],)
                            ),
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
                                        'Cambiar contraseña',
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
                                      editPasswordNoPresionado ? _getEditPasswordIcon() : new Container(),
                                    ],
                                  )
                                ],
                              )),
                          //if(!editNoPresionado)
                        //  }else
                          mostrarApartado("Mis playlists"),
                          Padding(
                              padding: EdgeInsets.only(top: height * 0.04),
                              child: SizedBox(
                                height: height * 0.23,
                                child: Consumer<PlaylistRepo>(
                                  builder: (context, playlistRepo, _) => ListView.builder(

                                    itemCount: playlistRepo.playlist.length + 1,
                                    itemBuilder: (context, pos) {
                                      var padd = (pos == 0) ? width * 0.08 : 5.0;
                                      if(playlistRepo.playlist.length == 0){
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
                                                                  left: 27.0,
                                                                  right: 27.0,
                                                                  top: 27.0,
                                                                  bottom: 27.0),
                                                              child: Column(children: <Widget>[
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
                                                                          ? "El nombre no \n puede ser nulo"
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
                                                                TextFormField(
                                                                  controller: txtDescripcion,
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
                                                                          ? "La descripción no \n puede ser nula"
                                                                          : null,
                                                                      errorStyle: Theme.of(
                                                                          context)
                                                                          .textTheme
                                                                          .display2,
                                                                      labelText:
                                                                      "Ponle una descripción",
                                                                      labelStyle: Theme.of(
                                                                          context)
                                                                          .textTheme
                                                                          .display2,
                                                                      border: OutlineInputBorder(
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              4))),
                                                                ),
                                                                new GestureDetector(onTap: seleccionarImagenPlaylist,child:new Container(
                                                                    width: 40.0,
                                                                    height: 40.0,
                                                                    decoration: new BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      image: new DecorationImage(
                                                                        image: _playlistImage == null
                                                                            ? new ExactAssetImage(
                                                                            'assets/camera.png')
                                                                            : FileImage(_playlistImage),
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ))),
                                                              ],)
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                if(txt.text != ""){
                                                                  validate(context, playlistRepo, txt.text, "create");
                                                                }

                                                              });

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
                                      }else{
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
                                                                    left: 27.0,
                                                                    right: 27.0,
                                                                    top: 27.0,
                                                                    bottom: 27.0),
                                                                child: Column(children: <Widget>[
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
                                                                            ? "El nombre no \n puede ser nulo"
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
                                                                  TextFormField(
                                                                    controller: txtDescripcion,
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
                                                                            ? "La descripción no \n puede ser nula"
                                                                            : null,
                                                                        errorStyle: Theme.of(
                                                                            context)
                                                                            .textTheme
                                                                            .display2,
                                                                        labelText:
                                                                        "Ponle una descripción",
                                                                        labelStyle: Theme.of(
                                                                            context)
                                                                            .textTheme
                                                                            .display2,
                                                                        border: OutlineInputBorder(
                                                                            borderRadius:
                                                                            BorderRadius.circular(
                                                                                4))),
                                                                  ),
                                                                  new GestureDetector(onTap: seleccionarImagenPlaylist,child:new Container(
                                                                      width: 40.0,
                                                                      height: 40.0,
                                                                      decoration: new BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        image: new DecorationImage(
                                                                          image: _playlistImage == null
                                                                              ? new ExactAssetImage(
                                                                              'assets/camera.png')
                                                                              : FileImage(_playlistImage),
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                      ))),
                                                                ],)
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  if(txt.text != ""){
                                                                    validate(context, playlistRepo, txt.text, "create");
                                                                  }

                                                                });


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
                                                    decoration: playlistRepo.imagenes[pos] == ""
                                                    ? BoxDecoration(
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
                                                    )
                                                    : BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(playlistRepo.imagenes[pos]),
                                                          fit: BoxFit.cover,
                                                        )
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
                                                              setState(() {

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
                                                                                    "Eliminar Playlist",
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
                                                                                child:Text("¿Estás seguro?"),

                                                                              ),
                                                                              InkWell(
                                                                                onTap: () async {
                                                                                  setState(() {
                                                                                    validate(context, playlistRepo, playlistRepo.playlist[pos], "Delete");
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
                                                                                    Colors.red,
                                                                                  ),
                                                                                  child: Text(
                                                                                    "Eliminar",
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
                                                                              InkWell(
                                                                                onTap: () async {

                                                                                  setState(() {
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
                                                                                    Colors.orange,
                                                                                    borderRadius: BorderRadius.only(
                                                                                        bottomLeft:
                                                                                        Radius.circular(
                                                                                            32.0),
                                                                                        bottomRight:
                                                                                        Radius.circular(
                                                                                            32.0)),
                                                                                  ),
                                                                                  child: Text(
                                                                                    "Cancelar",
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
                                                              });
                                                              //si servidor no contesta
                                                              //exceptión, en caso de que responda
                                                              //mantenemos el funcionamiento anterior
                                                              //PlaylistHelper temp =
                                                              //await PlaylistHelper(
                                                              //    playlistRepo.playlist[pos]);
                                                              //temp.deletePlaylist();
                                                              //playlistRepo.delete(
                                                              //    playlistRepo.playlist[pos]);
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
                                                              txt.text = playlistRepo.playlist[pos];
                                                              txtDescripcion.text = playlistRepo.descripciones[pos];
                                                              _playlistImage = null;
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
                                                                                    left: 27.0,
                                                                                    right: 27.0,
                                                                                    top: 27.0,
                                                                                    bottom:
                                                                                    27.0),
                                                                                child: Column(children: <Widget>[
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
                                                                                            ? "El nombre no \n puede ser nulo"
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
                                                                                  TextFormField(
                                                                                    controller: txtDescripcion,
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
                                                                                            ? "La descripción no \n puede ser nula"
                                                                                            : null,
                                                                                        errorStyle: Theme.of(
                                                                                            context)
                                                                                            .textTheme
                                                                                            .display2,
                                                                                        labelText:
                                                                                        "Ponle una descipción",
                                                                                        labelStyle: Theme.of(
                                                                                            context)
                                                                                            .textTheme
                                                                                            .display2,
                                                                                        border: OutlineInputBorder(
                                                                                            borderRadius:
                                                                                            BorderRadius.circular(
                                                                                                4))),
                                                                                  ),
                                                                                  new GestureDetector(onTap: seleccionarImagenPlaylist,child:new Container(
                                                                                      width: 40.0,
                                                                                      height: 40.0,
                                                                                      decoration: new BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        image: new DecorationImage(
                                                                                          image: _playlistImage == null
                                                                                              ? new ExactAssetImage(
                                                                                              'assets/camera.png')
                                                                                              : FileImage(_playlistImage),
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ))),
                                                                                ],)

                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                setState(() async {
                                                                                  if(txt.text != ""){
                                                                                    await actualizarPlaylist(username.email, playlistRepo.playlist[pos], txtDescripcion.text,txt.text);
                                                                                    playlistRepo.playlist[pos] = txt.text;
                                                                                    playlistRepo.descripciones[pos] = txtDescripcion.text;
                                                                                    Navigator.pop(context);
                                                                                    setState(() {
                                                                                      anyadeDatosUsuario(username.email, playlistRepo, misCanciones, podcastRepo);
                                                                                      _playlistImage = null;
                                                                                    });
                                                                                  }
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
                                                                                  Colors.purple,
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
                                                        child: Padding(padding: EdgeInsets.only(
                                                            left: 25.0, right: 25.0, top: 50.0, bottom: 13.0),
                                                          child: Column(children: <Widget>[
                                                            Text(playlistRepo.playlist[pos],
                                                                textAlign: TextAlign.center,
                                                                style:
                                                                TextStyle(color: Colors.white),
                                                                textScaleFactor: 1.3),
                                                            Text(playlistRepo.descripciones[pos],
                                                                style:
                                                                TextStyle(color: Colors.white)),
                                                          ]),),
                                                      ),
                                                    ]),
                                                  )),
                                            ),
                                          );
                                        }
                                      }

                                    },
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              )),
                          mostrarApartado("Mis podcasts"),
                          Padding(
                              padding: EdgeInsets.only(top: height * 0.04),
                              child: SizedBox(
                                height: height * 0.23,
                                child: Consumer<PodcastRepo>(
                                  builder: (context, podcastRepo, _) => ListView.builder(

                                    itemCount: podcastRepo.podcast.length + 1,
                                    itemBuilder: (context, pos) {
                                      var padd = (pos == 0) ? width * 0.08 : 5.0;
                                      if(podcastRepo.podcast.length == 0){
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
                                                                "Nuevo Podcast",
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
                                                                  left: 27.0,
                                                                  right: 27.0,
                                                                  top: 27.0,
                                                                  bottom: 27.0),
                                                              child: Column(children: <Widget>[
                                                                TextFormField(
                                                                  controller: txt,
                                                                  decoration: InputDecoration(
                                                                      disabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color: Colors
                                                                                  .deepPurple)),
                                                                      enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color: Colors
                                                                                  .deepPurple)),
                                                                      errorText: error
                                                                          ? "El nombre no \n puede ser nulo"
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
                                                                TextFormField(
                                                                  controller: txtDescripcion,
                                                                  decoration: InputDecoration(
                                                                      disabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color: Colors
                                                                                  .deepPurple)),
                                                                      enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color: Colors
                                                                                  .deepPurple)),
                                                                      errorText: error
                                                                          ? "La descripción no \n puede ser nula"
                                                                          : null,
                                                                      errorStyle: Theme.of(
                                                                          context)
                                                                          .textTheme
                                                                          .display2,
                                                                      labelText:
                                                                      "Ponle una descripción",
                                                                      labelStyle: Theme.of(
                                                                          context)
                                                                          .textTheme
                                                                          .display2,
                                                                      border: OutlineInputBorder(
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              4))),
                                                                ),
                                                                new GestureDetector(onTap: seleccionarImagenPodcast,child:new Container(
                                                                    width: 40.0,
                                                                    height: 40.0,
                                                                    decoration: new BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      image: new DecorationImage(
                                                                        image: _playlistImage == null
                                                                            ? new ExactAssetImage(
                                                                            'assets/camera.png')
                                                                            : FileImage(_playlistImage),
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ))),
                                                              ],)
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                if(txt.text != ""){
                                                                  validatePodcast(context, podcastRepo, txt.text, "create");
                                                                }

                                                              });


                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.only(
                                                                  top: 10.0, bottom: 20.0),
                                                              decoration: BoxDecoration(
                                                                color: Colors.purple,
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
                                                side: BorderSide(color: Colors.purpleAccent),
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
                                      }else{
                                        if (pos == (podcastRepo.podcast.length)) {
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
                                                                  "Nuevo Podcast",
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
                                                                    left: 27.0,
                                                                    right: 27.0,
                                                                    top: 27.0,
                                                                    bottom: 27.0),
                                                                child: Column(children: <Widget>[
                                                                  TextFormField(
                                                                    controller: txt,
                                                                    decoration: InputDecoration(
                                                                        disabledBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .deepPurple)),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .deepPurple)),
                                                                        errorText: error
                                                                            ? "El nombre no \n puede ser nulo"
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
                                                                  TextFormField(
                                                                    controller: txtDescripcion,
                                                                    decoration: InputDecoration(
                                                                        disabledBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .deepPurple)),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .deepPurple)),
                                                                        errorText: error
                                                                            ? "La descripción no \n puede ser nula"
                                                                            : null,
                                                                        errorStyle: Theme.of(
                                                                            context)
                                                                            .textTheme
                                                                            .display2,
                                                                        labelText:
                                                                        "Ponle una descripción",
                                                                        labelStyle: Theme.of(
                                                                            context)
                                                                            .textTheme
                                                                            .display2,
                                                                        border: OutlineInputBorder(
                                                                            borderRadius:
                                                                            BorderRadius.circular(
                                                                                4))),
                                                                  ),
                                                                  new GestureDetector(onTap: seleccionarImagenPodcast,child:new Container(
                                                                      width: 40.0,
                                                                      height: 40.0,
                                                                      decoration: new BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        image: new DecorationImage(
                                                                          image: _playlistImage == null
                                                                              ? new ExactAssetImage(
                                                                              'assets/camera.png')
                                                                              : FileImage(_playlistImage),
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                      ))),
                                                                ],)
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  if(txt.text != ""){
                                                                    validatePodcast(context, podcastRepo, txt.text, "create");
                                                                  }

                                                                });


                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets.only(
                                                                    top: 10.0, bottom: 20.0),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.purple,
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
                                                  side: BorderSide(color: Colors.purpleAccent),
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
                                                podcastRepo.selected = null;
                                                podcastRepo.selected = pos;
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (context) => new PodcastScreen()));
                                              },
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(20),
                                                  child: Container(
                                                    width: width * 0.4,
                                                    decoration: podcastRepo.imagenes[pos] == ""
                                                    ? BoxDecoration(
                                                      // Box decoration takes a gradient
                                                      gradient: LinearGradient(
                                                        // Where the linear gradient begins and ends
                                                        begin: Alignment.topRight,
                                                        end: Alignment.bottomLeft,
                                                        // Add one stop for each color. Stops should increase from 0 to 1
                                                        stops: [0.1, 0.5, 0.7, 0.9],
                                                        colors: pos % 2 == 0
                                                            ? [
                                                          Colors.purpleAccent,
                                                          Colors.purple,
                                                          Colors.purple,
                                                          Colors.purpleAccent,
                                                        ]
                                                            : [
                                                          Colors.lightBlueAccent,
                                                          Colors.indigoAccent,
                                                          Colors.indigoAccent,
                                                          Colors.lightBlueAccent,
                                                        ],
                                                      ),
                                                    )
                                                    :  BoxDecoration(
                                                        image: DecorationImage(
                                                        image: NetworkImage(podcastRepo.imagenes[pos]),
                                                        fit: BoxFit.cover,
                                                        )
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
                                                              setState(() {

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
                                                                                    "Eliminar Podcast",
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
                                                                                child:Text("¿Estás seguro?"),

                                                                              ),
                                                                              InkWell(
                                                                                onTap: () async {

                                                                                  setState(() {
                                                                                    validatePodcast(context, podcastRepo, podcastRepo.podcast[pos], "Delete");

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
                                                                                    Colors.red,
                                                                                  ),
                                                                                  child: Text(
                                                                                    "Eliminar",
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
                                                                              InkWell(
                                                                                onTap: () async {

                                                                                  setState(() {
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
                                                                                    Colors.orange,
                                                                                    borderRadius: BorderRadius.only(
                                                                                        bottomLeft:
                                                                                        Radius.circular(
                                                                                            32.0),
                                                                                        bottomRight:
                                                                                        Radius.circular(
                                                                                            32.0)),
                                                                                  ),
                                                                                  child: Text(
                                                                                    "Cancelar",
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
                                                              });
                                                              //si servidor no contesta
                                                              //exceptión, en caso de que responda
                                                              //mantenemos el funcionamiento anterior
                                                              //PlaylistHelper temp =
                                                              //await PlaylistHelper(
                                                              //    playlistRepo.playlist[pos]);
                                                              //temp.deletePlaylist();
                                                              //playlistRepo.delete(
                                                              //    playlistRepo.playlist[pos]);
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
                                                              txt.text = podcastRepo.podcast[pos];
                                                              txtDescripcion.text = podcastRepo.descripciones[pos];
                                                              _playlistImage = null;
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
                                                                                    left: 27.0,
                                                                                    right: 27.0,
                                                                                    top: 27.0,
                                                                                    bottom:
                                                                                    27.0),
                                                                                child: Column(children: <Widget>[
                                                                                  TextFormField(
                                                                                    controller: txt,
                                                                                    decoration: InputDecoration(
                                                                                        disabledBorder: OutlineInputBorder(
                                                                                            borderSide: BorderSide(
                                                                                                color: Colors
                                                                                                    .deepPurple)),
                                                                                        enabledBorder: OutlineInputBorder(
                                                                                            borderSide: BorderSide(
                                                                                                color: Colors
                                                                                                    .deepPurple)),
                                                                                        errorText: error
                                                                                            ? "El nombre no \n puede ser nulo"
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
                                                                                  TextFormField(
                                                                                    controller: txtDescripcion,
                                                                                    decoration: InputDecoration(
                                                                                        disabledBorder: OutlineInputBorder(
                                                                                            borderSide: BorderSide(
                                                                                                color: Colors
                                                                                                    .deepPurple)),
                                                                                        enabledBorder: OutlineInputBorder(
                                                                                            borderSide: BorderSide(
                                                                                                color: Colors
                                                                                                    .deepPurple)),
                                                                                        errorText: error
                                                                                            ? "La descripción no \n puede ser nula"
                                                                                            : null,
                                                                                        errorStyle: Theme.of(
                                                                                            context)
                                                                                            .textTheme
                                                                                            .display2,
                                                                                        labelText:
                                                                                        "Ponle una descripción",
                                                                                        labelStyle: Theme.of(
                                                                                            context)
                                                                                            .textTheme
                                                                                            .display2,
                                                                                        border: OutlineInputBorder(
                                                                                            borderRadius:
                                                                                            BorderRadius.circular(
                                                                                                4))),
                                                                                  ),
                                                                                  new GestureDetector(onTap: seleccionarImagenPodcast,child:new Container(
                                                                                      width: 40.0,
                                                                                      height: 40.0,
                                                                                      decoration: new BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        image: new DecorationImage(
                                                                                          image: _playlistImage == null
                                                                                              ? new ExactAssetImage(
                                                                                              'assets/camera.png')
                                                                                              : FileImage(_playlistImage),
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ))),
                                                                                ],)

                                                                            ),
                                                                            InkWell(
                                                                              onTap: () async {
                                                                                setState(() {
                                                                                  if(txt.text != "") {
                                                                                    actualizarPodcast(username.email, podcastRepo.podcast[pos], txtDescripcion.text,txt.text);
                                                                                    podcastRepo.podcast[pos] = txt.text;
                                                                                    podcastRepo.descripciones[pos] = txtDescripcion.text;
                                                                                    Navigator.pop(context);
                                                                                    setState(() {
                                                                                      anyadeDatosUsuario(username.email, playlistRepo, misCanciones, podcastRepo);
                                                                                      _playlistImage = null;
                                                                                    });
                                                                                  }
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
                                                                                  Colors.purple,
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
                                                      Align(
                                                        alignment: Alignment.topRight,
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.only(right: 60.0, top: 8.0),
                                                          child: IconButton(
                                                              icon: Icon(
                                                                Icons.add,
                                                                size: 17,
                                                                color: Colors.white,
                                                              ),
                                                              onPressed: () async {
                                                                podcastRepo.selected = pos;
                                                                Navigator.of(
                                                                    context).push(
                                                                    new MaterialPageRoute(
                                                                        builder: (
                                                                            context) => new uploadPodcast()));
                                                              }
                                                          ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Padding(padding: EdgeInsets.only(
                                                            left: 25.0, right: 25.0, top: 50.0, bottom: 13.0),
                                                          child: Column(children: <Widget>[
                                                            Text(podcastRepo.podcast[pos],
                                                                textAlign: TextAlign.center,
                                                                style:
                                                                TextStyle(color: Colors.white),
                                                                textScaleFactor: 1.3),
                                                            Flexible(child: Text(podcastRepo.descripciones[pos],
                                                                textAlign: TextAlign.center,
                                                                style:
                                                                TextStyle(color: Colors.white)),),
                                                          ]),),
                                                      ),
                                                    ]),
                                                  )),
                                            ),
                                          );
                                        }
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
                              padding: EdgeInsets.only(top: height * 0.04),
                              child: SizedBox(
                                height: height * 0.23,
                                child: new Consumer<MisCancionesModel>(
                                  builder: (context, misCanciones, _) => ListView.builder(


                                    itemCount: misCanciones.playlist.length+1,
                                    itemBuilder: (context, pos) {
                                      var padd = (pos == 0) ? width * 0.08 : 5.0;
                                      if (pos == (misCanciones.playlist.length)) {
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

  Future<Respuesta> actualizarPlaylist(String email, String nombrePlaylistAntiguo,
      String descripcionPlaylist,  String nombrePlaylistNuevo) async {
    String base64Image;
    if(_playlistImage != null){
      List<int> imageBytes = _playlistImage.readAsBytesSync();
      base64Image = base64.encode(imageBytes);
    }

    Map data = {
      'nombrePlaylistViejo': nombrePlaylistAntiguo,
      'descripcion': descripcionPlaylist,
      'email': email,
      'nombrePlaylistNuevo': nombrePlaylistNuevo,
      'imagen': base64Image,
    };
    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/playlist_modificar_android',
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

  Future<Respuesta> actualizarPodcast(String email, String nombrePodcastAntiguo,
      String descripcionPlaylist,  String nombrePodcastNuevo) async {
    String base64Image;
    if(_playlistImage != null){
      List<int> imageBytes = _playlistImage.readAsBytesSync();
      base64Image = base64.encode(imageBytes);
    }
    Map data = {
      'nombrePodcastViejo': nombrePodcastAntiguo,
      'descripcion': descripcionPlaylist,
      'email': email,
      'nombrePodcastNuevo': nombrePodcastNuevo,
      'imagen': base64Image,
    };
    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/modificar_podcast_android',
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
  void recibirDatos(String email, TextEditingController usernameController,
      TextEditingController descriptionController,
      TextEditingController emailController, TextEditingController passwordController) async{
    Perfil p = await obtenerPerfil(email);
    if(p.nombreUsuario != null){
      imagenPerfil = p.imagen;
      usernameController.text = p.nombreUsuario;
      descriptionController.text = p.descripcion;
      emailController.text = p.email;
      passwordController.text = p.contrasenya;
      numeroSeguidores = "Seguidores:  " +p.numSeguidores.toString();
    }

  }


   anyadeDatosUsuario(String email, PlaylistRepo playlistRepo, MisCancionesModel misCanciones, PodcastRepo podcastRepo) async {
     Perfil p = await obtenerPerfil(email);
     String u = p.nombreUsuario;
     if (p.nombreUsuario != null) {
       var playlistss = p.playlists.split('|');
       var descripciones = p.descripcionesPlay.split('|');
       var podcastss = p.podcasts.split('|');
       var descripcionesPodcasts = p.descripcionesPod.split('|');
       var imagenesPlaylists = p.imagenesPlaylists.split('|');
       var imagenesPodcasts = p.imagenesPodcasts.split('|');
       var rng = new Random();
       int counter;
       imageCache.clear();
       if (playlistss[0] != "" && descripciones[0] != "") {
         playlistRepo.generateInitialPlayListImage(playlistss, descripciones, imagenesPlaylists);
       }
       if (podcastss[0] != "" && descripcionesPodcasts[0] != "") {
         podcastRepo.generateInitialPodcastImage(podcastss, descripcionesPodcasts, imagenesPodcasts);
       }
       List<String> misCancionesTitle = new List();
       misCancionesTitle.add("Mis canciones");
       misCanciones.generateInitialPlayList(misCancionesTitle);
       setState(() {
         username.setCanciones(p.canciones);
         username.setCancionesUrl(p.urls);
       });
     }

   }

   void desampliarImagen(){
      Navigator.pop(context);
   }

  void ampliarImagen(){
    showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: AlertDialog(
            backgroundColor:
            Theme.of(context).backgroundColor,
            content: new GestureDetector(onTap: desampliarImagen,child: new Container(
                width: 400.0,
                height: 450.0,
                child: CircleAvatar(
                  radius: 75.0,
                  backgroundImage: imagenPerfil == null
                      ? new ExactAssetImage(
                      'assets/prof.png')
                      : NetworkImage(imagenPerfil),
                  backgroundColor: Colors.transparent,
                ),
                ),),

          ),
        );
      },
    );
  }

   void _modifyPassword(){
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
                       "Cambiar contraseña",
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
                   child: new Column(children: <Widget>[
                     Padding(
                         padding: EdgeInsets.only(
                             left: 25.0, right: 25.0, top: 25.0),
                         child: new Row(
                           mainAxisSize: MainAxisSize.max,
                           children: <Widget>[
                             new Column(
                               mainAxisAlignment: MainAxisAlignment
                                   .start,
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
                                 controller: passwordController,
                                 obscureText: false,
                                 style: TextStyle(fontSize: 16),
                                 decoration: const InputDecoration(
                                     hintText: "contraseña123!Ejemplo",
                                     hintStyle: TextStyle(
                                         fontSize: 15.0)),
                                 enabled: true,
                               ),
                             ),
                           ],
                         )),
                     //if(!editNoPresionado)
                     Padding(
                         padding: EdgeInsets.only(
                             left: 25.0, right: 25.0, top: 25.0),
                         child: new Row(
                           mainAxisSize: MainAxisSize.max,
                           children: <Widget>[
                             new Column(
                               mainAxisAlignment: MainAxisAlignment
                                   .start,
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
                     //if(!editNoPresionado)
                     Padding(
                         padding: EdgeInsets.only(
                             left: 25.0, right: 25.0, top: 2.0),
                         child: new Row(
                           mainAxisSize: MainAxisSize.max,
                           children: <Widget>[
                             new Flexible(
                               child: new TextField(
                                 controller: securePasswordController,
                                 style: TextStyle(fontSize: 16),
                                 obscureText: false,
                                 decoration: const InputDecoration(
                                     hintText: "contraseña123!Ejemplo",
                                     hintStyle: TextStyle(
                                         fontSize: 15.0)),
                                 enabled: true,
                               ),
                             ),
                           ],
                         )),
                   ],),
                 ),
                 InkWell(
                   onTap: () {
                     if(passwordController.text != ""){
                       if(securePasswordController.text != ""){
                         if(passwordController.text == securePasswordController.text){
                           if(passwordController.text.length >= 8){
                             enviarDatosALaBD(usernameController.text,
                                 descriptionController.text
                                 , emailController.text, passwordController.text); //conectar los datos escritos con la BD
                             editPasswordNoPresionado = true;
                             Navigator.pop(context);
                           }else{
                             mostrarError("La contraseña ha de tener mínimo 8 caracteres");
                           }
                         }else{
                           mostrarError("Las contraseñas no coinciden");
                         }
                       }else{
                         mostrarError("Repite la contraseña");
                       }
                     }else{
                       mostrarError("La contraseña no puede estar vacía");
                     }
                   },
                   child: Container(
                     padding: EdgeInsets.only(
                         top: 10.0, bottom: 20.0),
                     decoration: BoxDecoration(
                       color: Colors.orange,
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

                 InkWell(
                   onTap: () {
                     setState(() {
                       editPasswordNoPresionado = true;
                       Navigator.pop(context);
                     });
                   },
                   child: Container(
                     padding: EdgeInsets.only(
                         top: 10.0, bottom: 20.0),
                     decoration: BoxDecoration(
                       color: Colors.orangeAccent,
                       borderRadius: BorderRadius.only(
                           bottomLeft:
                           Radius.circular(32.0),
                           bottomRight:
                           Radius.circular(32.0)),
                     ),
                     child: Text(
                       "Cancelar",
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
         });

   }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child:new Row(
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
                          if(usernameController.text != ""){
                            if(emailController.text != ""){
                                    enviarDatosALaBD(usernameController.text,
                                        descriptionController.text
                                        , emailController.text, passwordController.text); //conectar los datos escritos con la BD
                                    editNoPresionado = true;
                                    FocusScope.of(context).requestFocus(new FocusNode());
                            }else{
                              mostrarError("El email no puede estar vacío");
                            }
                          }else{
                            mostrarError("El nombre de usuario no puede estar vacío");
                          }
                        });
                      FocusScope.of(context).requestFocus(new FocusNode());

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
                        editNoPresionado = true;
                        recibirDatos(username.email, usernameController,
                            descriptionController, emailController, passwordController);
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          SizedBox(height: 40,child: Text(controlador.text))  //todo hacerlo bien (como en el login)
        ],
      ),
    );
  }
  Future<Respuesta> crearPlaylist(String email, String nombrePlaylist,
      String descripcionPlaylist) async {
    String base64Image;
    if(_playlistImage != null){
      List<int> imageBytes = _playlistImage.readAsBytesSync();
      base64Image = base64.encode(imageBytes);
    }

    Map data = {
      'email': email,
      'nombrePlaylist': nombrePlaylist,
      'descripcion': descripcionPlaylist,
      'imagen': base64Image,
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

  Future<Respuesta> crearPodcast(String email, String nombrePodcast,
      String descripcionPodcast) async {

    String base64Image;
    if(_playlistImage != null){
      List<int> imageBytes = _playlistImage.readAsBytesSync();
      base64Image = base64.encode(imageBytes);
    }

    Map data = {
      'email': email,
      'nombrePodcast': nombrePodcast,
      'descripcion': descripcionPodcast,
      'imagen': base64Image,
    };
    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/crear_podcast_android',
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


  Future<Respuesta> uploadProfilePicture(String email) async {
    List<int> imageBytes = _profileImage.readAsBytesSync();
    String base64Image = base64.encode(imageBytes);
    Map data = {
      'email': email,
      'imagen': base64Image,
    };
    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/imagen_usuario_android',
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

  Widget mostrarApartado(String titulo){
    return Padding(
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
                  titulo,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ));
  }

  Widget mostrarTextfield(String hint, TextEditingController controller){
    return Padding(
        padding: EdgeInsets.only(
            left: 25.0, right: 25.0, top: 2.0),
        child:  Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

            Flexible(
              child: TextField(
                controller: controller,
                style: TextStyle(fontSize: 16),
                decoration:  InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(fontSize: 15.0)
                ),
                enabled: !editNoPresionado,
                autofocus: !editNoPresionado,

              ),
            ),
          ],
        ));
  }

  void mostrarError(String textoError){
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
                        "Error",
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
                      Navigator.pop(context);
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
  void seleccionarImagenPlaylist(){
    showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
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
                width: 70.0,
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
                          "Subir foto desde",
                          style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'Sans'),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          getImageFromDevice("cámara", "playlist");
                          Navigator.pop(context);
                        });

                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                        ),
                        child: Text(
                          "Cámara",
                          style: TextStyle(
                              fontFamily: 'Sans',
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        setState(() {
                          getImageFromDevice("galería", "playlist");
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.only(
                              bottomLeft:
                              Radius.circular(32.0),
                              bottomRight:
                              Radius.circular(32.0)),
                        ),
                        child: Text(
                          "Galería",
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
        });
  }
  void seleccionarImagenPodcast(){
    showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
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
                width: 70.0,
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
                          "Subir foto desde",
                          style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'Sans'),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          getImageFromDevice("cámara", "playlist");
                          Navigator.pop(context);

                        });

                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                        ),
                        child: Text(
                          "Cámara",
                          style: TextStyle(
                              fontFamily: 'Sans',
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        setState(() {
                          getImageFromDevice("galería", "playlist");
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.only(
                              bottomLeft:
                              Radius.circular(32.0),
                              bottomRight:
                              Radius.circular(32.0)),
                        ),
                        child: Text(
                          "Galería",
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
        });
  }


  void seleccionarImagen(){
    showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
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
                width: 70.0,
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
                          "Subir foto desde",
                          style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'Sans'),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    InkWell(
                      onTap: () {
                        getImageFromDevice("cámara", "perfil");
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                        ),
                        child: Text(
                          "Cámara",
                          style: TextStyle(
                              fontFamily: 'Sans',
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        getImageFromDevice("galería", "perfil");
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.only(
                              bottomLeft:
                              Radius.circular(32.0),
                              bottomRight:
                              Radius.circular(32.0)),
                        ),
                        child: Text(
                          "Galería",
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
        });
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
          editNoPresionado = false;
        });
      },
    );
  }

  Widget _getEditPasswordIcon() {
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
          editPasswordNoPresionado = false;
          _modifyPassword();
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
  void validate(context, repo, String nombre, String accion) {

      txt.text.toString().isEmpty ? error = true : error = false;

    if (txt.text.toString().isNotEmpty && accion == "create") {

        esperoCrearPlaylist(
            emailController.text, txt.text, txtDescripcion.text, context, playlistRepo);

      }else { //nombre ==te"
      esperoBorrarPlaylist(
          emailController.text, context, nombre);
    }
  }
  void validatePodcast(context, repo, String nombre, String accion) {

    txt.text.toString().isEmpty ? error = true : error = false;

    if (txt.text.toString().isNotEmpty && accion == "create") {
      esperoCrearPodcast(
          emailController.text, txt.text, txtDescripcion.text, context, podcastRepo);

    }else { //nombre ==te"
      esperoBorrarPodcast(emailController.text, context, nombre);
    }
  }
  void esperoCrearPlaylist(String email, String nombrePlaylist,
      String descripcionPlaylist, BuildContext context, PlaylistRepo playlistRepo)async{
    Respuesta r = await crearPlaylist(email, nombrePlaylist, descripcionPlaylist);

    if(r.getUserId()=="ok"){
      playlistRepo.add(nombrePlaylist, descripcionPlaylist);
    }else{
      mostrarError("No has seleccionado una imagen");
    }
    txt.clear();
    txtDescripcion.clear();
    Navigator.of(context).pop();
    setState(() {
      anyadeDatosUsuario(username.email, playlistRepo, misCanciones, podcastRepo);
    });
  }
  void esperoCrearPodcast(String email, String nombrePodcast,
      String descripcionPodcast, BuildContext context, PodcastRepo podcastRepo)async{
    Respuesta r = await crearPodcast(email, nombrePodcast, descripcionPodcast);

    if(r.getUserId()=="ok"){
      playlistRepo.add(nombrePodcast, descripcionPodcast);
    }else{
      mostrarError("No has seleccionado una imagen");
    }
    txt.clear();
    txtDescripcion.clear();
    Navigator.of(context).pop();
    setState(() {
      anyadeDatosUsuario(username.email, playlistRepo, misCanciones, podcastRepo);
    });
  }

  void esperoBorrarPlaylist(String email, BuildContext context, String nombrePlaylist) async
  {
    playlistRepo.delete(nombrePlaylist);
     await borrarPlaylist(email, nombrePlaylist);

     Navigator.of(context).pop();
  }
  void esperoBorrarPodcast(String email, BuildContext context, String nombrePodcast) async
  {
    await borrarPodcast(email, nombrePodcast);
    playlistRepo.delete(nombrePodcast);
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
    if (model.usuarios[pos].albumArt != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child:
          Image.file(File.fromUri(Uri.parse(model.usuarios[pos].albumArt))));
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

  void enviarDatosALaBD(String nombre, String descripcion, String email, String contra) {

      esperarActualizarUser(nombre, descripcion, email, contra);

  }

  void esperarActualizarUser(String nombre, String descripcion, String email, String contra) async {

    await actualizarUser(nombre,descripcion,email, contra);

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
  final String descripcionesPlay;
  final String podcasts;
  final String descripcionesPod;
  final String canciones;
  final String urls;
  final int numSeguidores;
  final String imagen;
  final String imagenesPlaylists;
  final String imagenesPodcasts;

  Perfil({this.respuesta, this.nombreUsuario, this.descripcion, this.email,
    this.contrasenya, this.repetirContraseya, this.playlists, this.descripcionesPlay,
    this.canciones, this.urls, this.podcasts,this.descripcionesPod,this.imagen,
    this.numSeguidores, this.imagenesPlaylists, this.imagenesPodcasts});

  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
      nombreUsuario: json['nombreUsuario'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      email: json['email'],
      playlists: json['lista'],
      descripcionesPlay: json['listaDescripcion'],
      podcasts: json['podcasts'],
      descripcionesPod: json['podcastsDescripcion'],
      canciones: json['audiosTitulo'],
      urls: json['audiosUrl'],
      numSeguidores: json['numSeguidores'],
      imagenesPlaylists: json['imagenesPlaylists'],
      imagenesPodcasts: json['imagenesPodcasts'],
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
Future<Respuesta> borrarPlaylist(String email, String nombrePlaylist) async {
  Map data = {
    'email': email,
    'nombrePlaylist': nombrePlaylist,
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/eliminar_lista_android',
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

Future<Respuesta> borrarPodcast(String email, String nombrePodcast) async {
  Map data = {
    'email': email,
    'nombrePodcast': nombrePodcast,
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/eliminar_podcast_android',
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

Future<Respuesta> actualizarUser(String nombre, String descripcion, String email, String contra) async {
  Map data = {
    'nombre': nombre,
    'descripcion': descripcion,
    'email': email,
    'contrasenya': contra,
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/modificar_usuario_android',
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



