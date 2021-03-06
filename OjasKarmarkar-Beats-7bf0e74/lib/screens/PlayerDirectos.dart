import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:beats/models/Comentario.dart';
import 'package:beats/models/DirectosModel.dart';
import 'package:beats/models/ThemeModel.dart';
import 'package:beats/models/PlaylistRepo.dart';
import 'package:beats/models/BookmarkModel.dart';
import 'package:beats/models/PlayListHelper.dart';
import 'package:beats/models/Now_Playing.dart';
import 'package:beats/models/Username.dart';
import 'package:beats/models/const.dart';
import 'package:beats/screens/MusicLibrary.dart';
import 'package:beats/screens/ProfileEdit.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import '../custom_icons.dart';
import 'package:provider/provider.dart';
import 'package:beats/models/ProgressModel.dart';
import 'package:http/http.dart' as http;

import 'ComentariosDirectos.dart';
import 'ComentariosLibrary.dart';

class PlayerDirectos extends StatefulWidget {
  @override
  _PlayerDirectosState createState() => _PlayerDirectosState();
}

class _PlayerDirectosState extends State<PlayerDirectos> {
  DirectosModel modelDirectos;
  ThemeChanger themeChanger;
  MusicLibrary x;
  PageController pg;
  NowPlaying playScreen;
  TextEditingController comentario;
  Comentario c = new Comentario();
  Username user;
  FocusNode myFocusNode;
  int currentPage = 1;
  bool likeado = false;
  Username username;
  BookmarkModel bm;
  List<Song> songs;
  bool cargado;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    pg = PageController(
        initialPage: currentPage, keepPage: true, viewportFraction: 0.95);
  }
  @override
  void didChangeDependencies() {
    username = Provider.of<Username>(context);
    bm = Provider.of<BookmarkModel>(context);
    modelDirectos = Provider.of<DirectosModel>(context);
    String s = modelDirectos.currentSong.title;
    c.obtenerListaComentarios(modelDirectos.currentSong.title);
    cargado = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    pg.dispose();
  }

  TextEditingController txt = TextEditingController();

  bool error = false;
  List<String> playlist = new List();

  @override
  Widget build(BuildContext context) {
    user = Provider.of<Username>(context);
    modelDirectos = Provider.of<DirectosModel>(context);
    playScreen = Provider.of<NowPlaying>(context);
    themeChanger = Provider.of<ThemeChanger>(context);
    c.obtenerListaComentarios(modelDirectos.currentSong.title);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;



    if (playScreen.getScreen() == true) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: <Widget>[
            Consumer<DirectosModel>(
                builder: (context, model, _) => (cargado)?Column(children: [
                  SizedBox(
                    height: height * 0.63,
                    width: width,
                    child: (model.currentSong.albumArt != null)
                        ? Image.file(
                      File.fromUri(
                          Uri.parse(model.currentSong.albumArt)),
                      fit: BoxFit.fill,
                      width: width,
                      height: height * 0.63,
                    )
                        : Image.asset(
                      "assets/headphone.png",
                      alignment: Alignment.center,
                    ),
                  ),
                  Container(
                    height: height * 0.035,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0.1),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          model.currentSong.title,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .color,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.035,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0.02),
                      child: Center(
                        child: Text(
                          model.currentSong.artist.toString(),
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.015),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            model.repeat
                                ? model.setRepeat(false)
                                : model.setRepeat(true);
                          },
                          icon: Icon(
                            Icons.loop,
                            color:
                            model.repeat ? Colors.orange : Colors.grey,
                            size: 35.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            model.player.stop();
                            model.previous();

                            model.playURI(username.urlDirecto);
                          },
                          icon: Icon(
                            CustomIcons.step_backward,
                            color:
                            Theme.of(context).textTheme.display1.color,
                            size: 40.0,
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              if (model.currentState ==
                                  PlayerState.PAUSED ||
                                  model.currentState ==
                                      PlayerState.STOPPED) {
                                model.playURI(username.urlDirecto);
                              } else {
                                model.pause();
                              }
                            },
                            child: MaterialButton(
                              elevation: 30,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(100.0)),
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        themeChanger.accentColor,
                                        Color(0xFF996000),
                                        Color(0xFF996500),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100.0))),
                                padding: const EdgeInsets.fromLTRB(
                                    20, 10, 20, 10),
                                child: (model.currentState ==
                                    PlayerState.PAUSED ||
                                    model.currentState ==
                                        PlayerState.STOPPED)
                                    ? Icon(
                                  CustomIcons.play,
                                  color: Colors.white,
                                  size: 30.0,
                                )
                                    : Icon(CustomIcons.pause,
                                    size: 30, color: Colors.white),
                              ),
                            )),
                        IconButton(
                          onPressed: () {
                            model.player.stop();
                            model.next();
                            model.playURI(username.urlDirecto);
                          },
                          icon: Icon(
                            CustomIcons.step_forward,
                            color:
                            Theme.of(context).textTheme.display1.color,
                            size: 40.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.01),
                          child: IconButton(
                              onPressed: () {
                                model.shuffle
                                    ? model.setShuffle(false)
                                    : model.setShuffle(true);
                              },
                              icon: Icon(
                                Icons.shuffle,
                                color: model.shuffle
                                    ? Colors.orange
                                    : Colors.grey,
                                size: 35.0,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    //bloque fav y add
                    padding: EdgeInsets.only(top: height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            iconSize: 35.0,
                            icon: Icon(
                              Icons.cancel,
                              color: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .color,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Consumer<DirectosModel>(
                          builder: (context, repo, _) {
                            return IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        backgroundColor: Theme.of(context)
                                            .backgroundColor,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                            children: <Widget>[
                                              Text(
                                                "Add to Playlist",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display1,
                                              ),
                                              Container(
                                                height: 25,
                                                width: 25,
                                                child: FloatingActionButton(
                                                  backgroundColor:
                                                  Theme.of(context)
                                                      .backgroundColor,
                                                  onPressed: () {
                                                    _displayDialog(
                                                        context, repo);
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .add_circle_outline,
                                                    color:
                                                    Colors.orangeAccent,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      );
                                    });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ]) : Text("Cargando..."))
          ],
        ),
      );
    } else {
      //player, está aquí normalmente
      height = MediaQuery.of(context).size.height;
      width = MediaQuery.of(context).size.width;
      return WillPopScope(
          child: Scaffold(
          body: Stack(children: <Widget>[
            AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              leading: Padding(
                padding:
                EdgeInsets.only(top: height * 0.012, left: width * 0.03),
                child: IconButton(
                  iconSize: 35.0,
                  icon: Icon(
                    CustomIcons.arrow_circle_o_left,
                    color: Theme.of(context).textTheme.display1.color,
                  ),
                  onPressed: () {
                    modelDirectos.pause();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

            Consumer<DirectosModel>(
              builder: (context, model, _) => Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: height * 0.04),
                      child: Align(
                        alignment: Alignment.center,
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(200)),
                            elevation: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: SizedBox(
                                height: 290,
                                width: 290,
                                child: PageView.builder(
                                  controller: pg,
                                  onPageChanged: onPageChanged,
                                  itemCount: model.songs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ClipOval(
                                      child: (model.currentSong.albumArt !=
                                          null)
                                          ? Image.file(
                                        File.fromUri(Uri.parse(
                                            model.currentSong.albumArt)),
                                        width: 100,
                                        height: 100,
                                      )
                                          : Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0,
                                              vertical: 30.0),
                                          child: Image.asset(
                                              "assets/headphone.png")),
                                    );
                                  },
                                ),
                              ),
                            )),
                        //)
                      ) //;},
                    //),
                  ),
                  Container(
                    height: height * 0.09,
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Center(
                        child: Text(
                          model.currentSong.title,
                          maxLines: 1,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).textTheme.display1.color,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.04,
                    child: Padding(
                      padding: EdgeInsets.only(top: 1.0),
                      child: Center(
                        child: Text(
                          model.currentSong.artist.toString(),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding:
                    EdgeInsets.only(left: width * 0.1, top: height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            model.player.stop();
                            model.previous();
                            username.urlDirecto = model.currentSong.uri;
                            model.playURI(username.urlDirecto);
                          },
                          icon: Icon(
                            CustomIcons.step_backward,
                            color: Theme.of(context).textTheme.display1.color,
                            size: 35.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.01),
                          child: InkWell(
                              onTap: () {
                                String estado = model.currentState.toString();
                                log("el estado: $estado");
                                if (model.currentState == PlayerState.PAUSED ||
                                    model.currentState == PlayerState.STOPPED) {
                                  model.playURI(username.urlDirecto);
                                } else {

                                  model.pause();
                                }
                                String estadofinal = model.currentState.toString();
                                log("el estadofinal: $estadofinal");
                              },
                              child: MaterialButton(
                                elevation: 30,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          themeChanger.accentColor,
                                          Color(0xFF995000),
                                          Color(0xFF996000),
                                          Color(0xFF995000),
                                          Color(0xFF996000),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100.0))),
                                  padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: (model.currentState ==
                                      PlayerState.PAUSED ||
                                      model.currentState ==
                                          PlayerState.STOPPED)
                                      ? Icon(
                                    CustomIcons.play,
                                    color: Colors.white,
                                    size: 30.0,
                                  )
                                      : Icon(CustomIcons.pause,
                                      size: 30, color: Colors.white),
                                ),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: width * 0.1),
                          child: IconButton(
                            onPressed: () {
                              model.player.stop();

                              model.next();
                              username.urlDirecto = model.currentSong.uri;
                              model.playURI(username.urlDirecto);
                            },
                            icon: Icon(
                              CustomIcons.step_forward,
                              color: Theme.of(context).textTheme.display1.color,
                              size: 35.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.001, top: height * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          onPressed: () async {
                            await model.Like(user.email);
                            await model.likeado(username.email);
                            setState(() {

                            });
                          },
                          icon: Icon(
                            Icons.thumb_up,
                            color: model.currentLike ? Colors.orange : Colors.grey,
                            size: 35.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            model.player.stop();
                            Navigator.of(context).push(new MaterialPageRoute(builder: (context) =>
                            new ComentariosDirectos()));
                          },
                          icon: Icon(
                            Icons.comment,
                            color: Colors.grey,
                            size: 35.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ])
    ),
          onWillPop:(){

        modelDirectos.pause();
        Navigator.pop(context);

      });
    }

  }

  onPageChanged(int index) {
    setState(() {
      if (currentPage > index) {
        currentPage = index;
        modelDirectos.player.stop();
        modelDirectos.previous();

        modelDirectos.playURI(username.urlDirecto);
      } else if (currentPage < index) {
        currentPage = index;
        modelDirectos.player.stop();
        modelDirectos.next();

        modelDirectos.playURI(username.urlDirecto);
      }
    });
  }

  _displayDialog(BuildContext context, repo) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AlertDialog(
              shape: Border.all(color: Colors.orangeAccent),
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                'Add',
                style: Theme.of(context).textTheme.display2,
              ),
              content: TextFormField(
                controller: txt,
                decoration: InputDecoration(
                    errorText: error ? "Name cant be null" : null,
                    errorStyle: Theme.of(context).textTheme.display2,
                    labelText: "Enter Name",
                    labelStyle: Theme.of(context).textTheme.display2,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(
                    'Create',
                    style: Theme.of(context).textTheme.display2,
                  ),
                  onPressed: () {
                    validate(context, repo);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }


  void validate(context, repo) {
    setState(() {
      txt.text.isEmpty ? error = true : error = false;
    });
    if (txt.text.isNotEmpty) {
      repo.add(txt.text);
      txt.clear();
      Navigator.of(context).pop();
    } else {}
  }

}



class Canciones {
  final String respuesta;
  final String nombresAudio;
  final String urlsAudio;
  final String genero;
  final String autor;
  Canciones({this.respuesta, this.nombresAudio,this.urlsAudio, this.genero, this.autor});

  factory Canciones.fromJson(Map<String, dynamic> json) {
    return Canciones(
      nombresAudio: json['nombresAudio'],
      urlsAudio: json['urlsAudio'],
    );

  }
  String getUserId(){
    return respuesta;
  }
  String getNombresAudio(){
    return nombresAudio;
  }
  String getUrlsAudio(){
    return urlsAudio;
  }
}
Future<Canciones> obtenerFavoritos(String email) async {
  Map data = {
    'email': email,
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/obtener_favoritos_android',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),

  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Canciones.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo al enviar petición');
  }
}