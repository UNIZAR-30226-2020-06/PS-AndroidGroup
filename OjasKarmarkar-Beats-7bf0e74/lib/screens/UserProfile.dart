import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beats/Animations/AnimatedButton.dart';
import 'package:beats/icono_personalizado.dart';
import 'package:beats/models/DifferentUsername.dart';
import 'package:beats/models/MisCancionesModel.dart';
import 'package:beats/models/PlayListHelper.dart';
import 'package:beats/models/PlaylistRepo.dart';
import 'package:beats/models/PodcastRepo.dart';
import 'package:beats/models/SongsModel.dart';
import 'package:beats/models/Username.dart';
import 'package:beats/models/const.dart';
import 'package:beats/screens/MisCancionesOtroUsuario.dart';
import 'package:beats/screens/PlayList.dart';
import 'package:beats/screens/PlaylistsNoEditable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'MusicLibrary.dart';
import 'package:http/http.dart' as http;
import 'PodcastsNoEditable.dart';
import 'login.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  TextEditingController txt = TextEditingController();
  bool error = false;
  bool seguido = false;
  SongsModel model;
  Username username;
  DifferentUsername differentUsername;
  File _profileImage;
  File _playlistImage;
  File _podcastImage;
  String numeroSeguidores = "Seguidores: ";
  String usernameController = "";
  String descriptionController = "";
  String emailController = "";
  String passwordController = "";
  String imagenPerfil;

  PlaylistRepo playlistRepo = new PlaylistRepo();
  PodcastRepo podcastRepo = new PodcastRepo();
  MisCancionesModel misCanciones = new MisCancionesModel();

  @override
  void initState() {
    super.initState();

  }
  @override
  void didChangeDependencies() {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    username = Provider.of<Username>(context);
    differentUsername = Provider.of<DifferentUsername>(context);
    playlistRepo = Provider.of<PlaylistRepo>(context);
    podcastRepo = Provider.of<PodcastRepo>(context);
    misCanciones = Provider.of<MisCancionesModel>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    setState(() {
      comprobarFollow();
      recibirDatos();

    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<SongsModel>(context);
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

                      ),
                    ],
                    backgroundColor: Colors.white,
                  ),
                  new Container(
                    height: 180.0,
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
                          ]),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    height: 50.0,
                    color: Colors.white,
                    child: (seguido)
                    ? Padding(padding: EdgeInsets.only(left: 75.0, right: 75.0),
    child: OutlineButton(onPressed: seguir,color: Colors.white,
                      borderSide: BorderSide(color: Colors.orangeAccent),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,children: <Widget> [Icon(Icons.check, color: Colors.orangeAccent, size: 35.0,),
                            Text("     Seguido", style: TextStyle(color: Colors.orangeAccent, fontSize: 22.0),),]),))
                    : new AnimatedButton(
                      onTap: () {
                        seguir();
                      },
                      animationDuration: const Duration(milliseconds: 2000),
                      initialText: "Seguir",
                      finalText: "Seguido",
                      iconData: Icons.check,
                      iconSize: 32.0,
                      buttonStyle: ButtonStyle(
                        primaryColor: Colors.orange,
                        secondaryColor: Colors.white,
                        elevation: 20.0,
                        initialTextStyle: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                        ),
                        finalTextStyle: TextStyle(
                          fontSize: 22.0,
                          color: Colors.orangeAccent,
                        ),
                        borderRadius: 10.0,
                      ),
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
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        usernameController,
                                        style: TextStyle(
                                            fontSize: 16.0,),
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
                                  left: 25.0, right: 0.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Container (
                                        padding: const EdgeInsets.all(16.0),
                                        width: MediaQuery.of(context).size.width*0.8,
                                        child: Text(
                                        descriptionController,
                                        style: TextStyle(
                                          fontSize: 16.0,),
                                      ),),
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
                                        'Seguidores',
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
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        numeroSeguidores,
                                        style: TextStyle(
                                          fontSize: 16.0,),
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
                                        'Playlists',
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
                                child: Consumer<PlaylistRepo>(
                                  builder: (context, playlistRepo, _) => (playlistRepo.playlist[0] != "")
                                    ?ListView.builder(

                                    itemCount: (playlistRepo.playlist[0] != "") ? playlistRepo.playlist.length : 0,
                                    itemBuilder: (context, pos) {
                                      var padd = (pos == 0) ? width * 0.08 : 5.0;
                                      return Card(
                                          margin: EdgeInsets.only(left: padd, right: 5.0),
                                          elevation: 20,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          child: GestureDetector(
                                            onTap: () {
                                              playlistRepo.selected = pos;
                                              Navigator.of(context).push(new MaterialPageRoute(
                                                  builder: (context) => new PLayListNoEditableScreen()));
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
                                                  child:
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

                                                )),
                                          ),
                                        );
                                    },
                                    scrollDirection: Axis.horizontal,
                                  )
                                    : Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                "No hay playlists",
                                                style: TextStyle(
                                                  fontSize: 16.0,),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
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
                                        'Podcasts',
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
                                child: Consumer<PodcastRepo>(
                                  builder: (context, podcastRepo, _) => (podcastRepo.podcast[0] != "")
                                      ?ListView.builder(

                                    itemCount: (podcastRepo.podcast[0] != "") ? podcastRepo.podcast.length : 0,
                                    itemBuilder: (context, pos) {
                                      var padd = (pos == 0) ? width * 0.08 : 5.0;
                                        return Card(
                                          margin: EdgeInsets.only(left: padd, right: 5.0),
                                          elevation: 20,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          child: GestureDetector(
                                            onTap: () {
                                              podcastRepo.selected = pos;
                                              Navigator.of(context).push(new MaterialPageRoute(
                                                  builder: (context) => new PodcastNoEditableScreen()));
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
                                                      : BoxDecoration(
                                                  image: DecorationImage(
                                                  image: NetworkImage(podcastRepo.imagenes[pos]),
                                                  fit: BoxFit.cover,
                                                  )
                                                  ),
                                                  child:
                                                    Center(
                                                      child: Padding(padding: EdgeInsets.only(
                                                          left: 25.0, right: 25.0, top: 50.0, bottom: 13.0),
                                                        child: Column(children: <Widget>[
                                                          Text(podcastRepo.podcast[pos],
                                                              textAlign: TextAlign.center,
                                                              style:
                                                              TextStyle(color: Colors.white),
                                                              textScaleFactor: 1.3),
                                                          Text(podcastRepo.descripciones[pos],
                                                              style:
                                                              TextStyle(color: Colors.white)),
                                                        ]),),
                                                    ),
                                                  ),
                                          ),
                                        ));

                                    },
                                    scrollDirection: Axis.horizontal,
                                  ): Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                "No hay podcasts",
                                                style: TextStyle(
                                                  fontSize: 16.0,),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),

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
                                        'Canciones',
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
                                child: Consumer<PodcastRepo>(
                                  builder: (context, podcastRepo, _) => ListView.builder(

                                    itemCount: 1,
                                    itemBuilder: (context, pos) {
                                      var padd = (pos == 0) ? width * 0.08 : 5.0;
                                      return Card(
                                          margin: EdgeInsets.only(left: padd, right: 5.0),
                                          elevation: 20,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(new MaterialPageRoute(
                                                  builder: (context) => new MisCancionesOtroUsuario()));
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: Container(
                                                width: width * 0.4,
                                                decoration:
                                                     BoxDecoration(
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
                                                    child: Padding(padding: EdgeInsets.only(
                                                        left: 25.0, right: 25.0, top: 50.0, bottom: 13.0),
                                                      child: Column(children: <Widget>[
                                                        Text("Canciones de " +differentUsername.name,
                                                            textAlign: TextAlign.center,
                                                            style:
                                                            TextStyle(color: Colors.white),
                                                            textScaleFactor: 1.3),
                                                      ]),),
                                                  ),
                                                ]),),
                                            ),
                                          ));

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
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  void validate(context, repo) {
    setState(() {
      txt.text.toString().isEmpty ? error = true : error = false;
    });
    if (txt.text.toString().isNotEmpty) {
      repo.add(txt.text);
      txt.clear();
      Navigator.of(context).pop();
    }
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
  comprobarFollow() async{
    Respuesta r = await sigoAEseUsuario(username.email, differentUsername.name);
    setState(() {
      seguido = r.getUserId();
    });

    log("seguido: $seguido");
  }

  seguir() async{
    Respuesta r = await seguirUsuario(username.email, differentUsername.name);
    setState(() {
      if(seguido){
        seguido = false;
      }else{
        seguido = true;
      }
      recibirDatos();
    });

  }


  void recibirDatos() async{
    Perfil p = await obtenerPerfil(differentUsername.name);
    if(p.nombreUsuario != null){
      imagenPerfil = p.imagen;
      usernameController = p.nombreUsuario;
      descriptionController = p.descripcion;
      emailController = p.email;
      passwordController = p.contrasenya;
      numeroSeguidores = "Seguidores:  " +p.numSeguidores.toString();
      anyadeDatosUsuario(differentUsername.email, playlistRepo, podcastRepo);
      //Uint8List bd = base64.decode(p.imagen);
      //final buffer = bd.buffer;
      //_profileImage.writeAsBytes(
      //    buffer.asUint8List(bd.offsetInBytes, bd.lengthInBytes));
    }

  }


  anyadeDatosUsuario(String email, PlaylistRepo playlistRepo, PodcastRepo podcastRepo) async {
    Perfil p = await obtenerPerfil(differentUsername.name);
    String u = p.nombreUsuario;
    log("user: $u");
    if (p.nombreUsuario != null) {
      var playlistss = p.playlists.split('|');
      var descripciones = p.descripcionesPlay.split('|');
      var podcastss = p.podcasts.split('|');
      var descripcionesPodcasts = p.descripcionesPod.split('|');
      var imagenesPlaylists = p.imagenesPlaylists.split('|');
      var imagenesPodcasts = p.imagenesPodcasts.split('|');
      var canciones = p.canciones.split('|');
      log('playlists: $playlistss');
      log('podcasts: $podcastss');
      log('descripsiones: $descripciones');
      log('canciones: $canciones');

      imageCache.clear();
      playlistRepo.generateInitialPlayListImage(playlistss, descripciones, imagenesPlaylists);
      podcastRepo.generateInitialPodcastImage(podcastss, descripcionesPodcasts, imagenesPodcasts);

      setState(() {
        if(p.canciones == null || p.urls == null || p.listaIds == null){

        }else{
          differentUsername.setCanciones(p.canciones);
          differentUsername.setCancionesUrl(p.urls);
          differentUsername.setIdsCanciones(p.listaIds);
        }

      });
    }

  }
}

class Respuesta {
  final bool respuesta;
  Respuesta({this.respuesta});

  factory Respuesta.fromJson(Map<String, dynamic> json) {
    return Respuesta(
      respuesta: json['siguiendo'],
    );

  }
  bool getUserId(){
    return respuesta;
  }
}
Future<Respuesta> sigoAEseUsuario(String email, String nombreUsuario) async {
  Map data = {
    'email': email,
    'usuario': nombreUsuario,
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/siguiendo_usuario_servlet',
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
  final String listaIds;

  Perfil({this.respuesta, this.nombreUsuario, this.descripcion, this.email,
    this.contrasenya, this.repetirContraseya, this.playlists, this.descripcionesPlay,
    this.canciones, this.urls, this.podcasts,this.descripcionesPod,this.imagen,
    this.numSeguidores, this.imagenesPlaylists, this.imagenesPodcasts, this.listaIds});

  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
      nombreUsuario: json['nombreUsuario'],
      descripcion: json['descripcion'],
      imagen: json['imagenUsuario'],
      playlists: json['lista'],
      descripcionesPlay: json['listaDescripcion'],
      podcasts: json['podcasts'],
      descripcionesPod: json['podcastsDescripcion'],
      canciones: json['audiosTitulo'],  //todo check, canciones está null
      urls: json['audiosUrl'],
      numSeguidores: json['numSeguidores'],
      imagenesPlaylists: json['imagenesPlaylists'],
      imagenesPodcasts: json['imagenesPodcasts'],
      listaIds: json['idsAudio'],
    );

  }
  String getUserId(){
    return respuesta;
  }
}
Future<Perfil> obtenerPerfil(String nombreUsuario) async {
  log("wassa: $nombreUsuario");
  Map data = {
    'nombreUsuario': nombreUsuario,
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/otros_perfil_android',
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

Future<Respuesta> seguirUsuario(String email, String nombreUsuario) async {
  Map data = {
    'email': email,
    'nombreUsuario': nombreUsuario,
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/follow_usuario_android',
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