import 'dart:convert';
import 'dart:developer';

import 'package:beats/Animations/transitions.dart';
import 'package:beats/models/DirectosModel.dart';
import 'package:beats/models/PlayListHelper.dart';
import 'package:beats/models/PlaylistRepo.dart';
import 'package:beats/models/SongsModel.dart' as reproduccion;
import 'package:beats/models/ThemeModel.dart';
import 'package:beats/models/BookmarkModel.dart';
import 'package:beats/models/Username.dart';
import 'package:beats/models/const.dart';
import 'package:beats/screens/PlayerDirectos.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_radio/flutter_radio.dart';

import '../custom_icons.dart';
import 'Player.dart';
import 'ProfileEdit.dart';


double height, width;

class Directos extends StatefulWidget {
  @override
  _DirectosState createState() => _DirectosState();
}

class _DirectosState extends State<Directos> {
  TextEditingController editingController;

  DirectosModel modelDirectos;
  DirectosModel modelTodosDirectos;
  reproduccion.SongsModel modelSongs;

  BookmarkModel b;

  ThemeChanger themeChanger;

  TextEditingController txt = TextEditingController();
  bool isPlaying;
  bool error = false;
  List<Song> songs;
  Username username;
  @override
  void initState() {
    super.initState();
    audioStart();

  }
  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    setState(() {
      isPlaying = isP;
    });
  }
  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }
  @override
  void didChangeDependencies() {
    modelDirectos = Provider.of<DirectosModel>(context);
    b = Provider.of<BookmarkModel>(context);
    username = Provider.of<Username>(context);
    modelSongs = Provider.of<reproduccion.SongsModel>(context);
    modelTodosDirectos = Provider.of<DirectosModel>(context);

    obtenerCancionesRandom(modelDirectos);
    modelDirectos.setEmail(username.email);

    playingStatus();

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    themeChanger = Provider.of<ThemeChanger>(context);

    for(int i=0; i<modelDirectos.getSongs().length;i++){
      String s = modelDirectos.getSongs().elementAt(i).title;
      log('directos: $s');
    }

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).backgroundColor,
          body: (modelDirectos.songs == null || (modelDirectos.songs.length == 1 && modelDirectos.songs[0].title == ""))
              ? NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverOverlapAbsorber(
                    child: SliverSafeArea(
                      top: false,
                      sliver: SliverAppBar(
                        actions: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: IconButton(
                              icon: Icon(Icons.search,
                                  color: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .color),
                              onPressed: () {
                                showSearch(
                                    context: context,
                                    delegate: Search());
                              },
                            ),
                          ),
                        ],
                        backgroundColor:
                        Theme.of(context).backgroundColor,
                        expandedHeight: height * 0.11,
                        pinned: true,
                        flexibleSpace: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                            EdgeInsets.only(left: width * 0.06),
                            child: Container(
                              child: Stack(
                                children: <Widget>[
                                  Text(
                                    "Directos",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .color),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context))
              ],
              body: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[Center(
                      child: Text(
                        "No hay directos",
                        style: Theme.of(context).textTheme.display1,
                      ),
                    )],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    //child: showStatus(model, context),
                  )
                ],
              ))
              : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverOverlapAbsorber(
                    child: SliverSafeArea(
                      top: false,
                      sliver: SliverAppBar(
                        actions: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: IconButton(
                              icon: Icon(Icons.search,
                                  color: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .color),
                              onPressed: () {
                                showSearch(
                                    context: context,
                                    delegate: Search());
                              },
                            ),
                          ),
                        ],
                        backgroundColor:
                        Theme.of(context).backgroundColor,
                        expandedHeight: height * 0.11,
                        pinned: true,
                        flexibleSpace: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                            EdgeInsets.only(left: width * 0.06),
                            child: Container(
                              child: Stack(
                                children: <Widget>[
                                  Text(
                                    "Directos",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .color),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context))
              ],
              body: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[getLoading(modelDirectos)],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    //child: showStatus(model, context),
                  )
                ],
              ))),
      onWillPop: () {},

    );
  }

  obtenerCancionesRandom(DirectosModel model) async {

    ListaDirectos c = await obtenerListaDirectos();
    List<String> listaNombres = c.getNombresAudio().split('|');
    List<String> listaUrls = c.getUrlsAudio().split('|');
    List<String> usuarios = c.getUsuariosAudio().split('|');

    log("urls2: $listaUrls");
    setState(() {
      songs = new List<Song>();
      for(int i = 0; i<listaNombres.length; i++){
        songs.add(new Song(i,"", listaNombres[i], "",0,0,listaUrls[i],null, ""));   //todo ojito aquí no estaba la lista de ID
      }
      for(String s in listaNombres){
        log('initData3: $s');
      }
      model.fetchSongsManual(songs);
    });

  }

  getLoading(DirectosModel model) {
    if (model.songs.length == 0) {
      return Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ));
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: model.songs.length,
          itemBuilder: (context, pos) {
            return Consumer<DirectosModel>(builder: (context, repo, _) {
              return ListTile(
                onTap: () async {
                  /*model.player.stop();
                  model.playlist = true;
                  model.playlistSongs = songs;
                  model.currentSong = model.songs[pos];
                  username.urlDirecto = model.songs[pos].uri;*/

                  if(modelSongs.player != null) {
                    modelSongs.pause();
                  }
                  //Reset the list. So we can change to next song.
                  log("do it");
                  username.urlDirecto = model.songs[pos].uri;
                  model.playURI(model.songs[pos].uri);

                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new PlayerDirectos()));

                  playingStatus();

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
                trailing: Icon(Icons.looks, color: Colors.red,),
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
              Icons.radio,
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
                Colors.redAccent,
                Colors.red,
                Colors.redAccent,
                Colors.red,
              ]
                  : [
                Colors.black,
                Colors.black54,
                Colors.black,
                Colors.black54,
              ],
            ),
          ));
    }
  }
  Future<ListaDirectos> obtenerListaDirectos() async {
    Map data = {
    'email': username.email,
  };
    final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/transmisiones_servlet',
    headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),

    );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return ListaDirectos.fromJson(json.decode(response.body));
    } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo al enviar petición');
    }
  }


  push(context) {
    Navigator.push(context, SlideRightRoute(page: PlayerDirectos()));
  }

  showStatus(model, BuildContext context) {
    if (model.currentSong != null) {
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).textTheme.display1.color,
              ),
            )),
        height: height * 0.06,
        width: width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (context, pos) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, Scale(page: PlayerDirectos()));
              },
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        color: Theme.of(context).textTheme.display1.color,
                        icon: Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          Navigator.push(context, Scale(page: PlayerDirectos()));
                        },
                      ),
                      Container(
                        width: width * 0.75,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            model.currentSong.title,
                            style: Theme.of(context).textTheme.display2,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: IconButton(
                          icon: model.currentState == PlayerState.PLAYING
                              ? Icon(
                            CustomIcons.pause,
                            color: Theme.of(context)
                                .textTheme
                                .display1
                                .color,
                            size: 20.0,
                          )
                              : Icon(
                            CustomIcons.play,
                            color: Theme.of(context)
                                .textTheme
                                .display1
                                .color,
                            size: 20.0,
                          ),
                          onPressed: () {
                            if (model.currentState == PlayerState.PAUSED ||
                                model.currentState == PlayerState.STOPPED) {
                              username.urlDirecto = model.songs[pos].uri;
                              model.play();

                              playingStatus();

                            } else {
                              playingStatus();
                              model.pause();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    } else {}
  }

}




class Search extends SearchDelegate<Song> {
  DirectosModel model;

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(
          Icons.clear,
          color: Colors.grey,
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.grey,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    // show results
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    model = Provider.of<DirectosModel>(context);
    obtenerTodosLosDirectos(model);
    List<Song> dummy = <Song>[];
    List<Song> recents = <Song>[];
    for (int i = 0; i < model.songs.length; i++) {
      dummy.add(model.songs[i]);
    }
    //for (int i = 0; i < 4; i++) {
    // recents.add(model.songs[i].title);
    //}
    var suggestion = query.isEmpty
        ? recents
        : dummy
        .where((p) => p.title.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    // hint when searches
    return ListView.builder(
      itemCount: suggestion.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              model.player.stop();
              model.play();
              model.playlist = false;
              close(context, null);
            },
            title: Text.rich(
              TextSpan(
                  text: suggestion[index].title + "\n",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                  ),
                  children: <TextSpan>[
                    new TextSpan(
                        text: suggestion[index].artist,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w100))
                  ]),
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            leading: CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.radio, color: Colors.white,)),
            trailing: (comprobarEnVivo(suggestion[index].title, dummy))?Icon(Icons.looks, color: Colors.red,):Icon(Icons.looks, color: Colors.grey,)
          ),
        );
      },
    );
  }
  List<String> enVivo;

  bool comprobarEnVivo(String nombreDirecto, List<Song> directos){
    for(int i=0; i<directos.length; i++){
      if(nombreDirecto == directos[i].title){
        if(enVivo[i] == "true"){
          return true;
        }
      }
    }
    return false;
  }
  void obtenerTodosLosDirectos(DirectosModel dm) async{
    ListaDirectos ld = await obtenerListaCompletaDirectos();
    var listaNombres = ld.getNombresAudio().split('|');
    var listaUrls = ld.getUrlsAudio().split('|');
    var activaTransmision = ld.activaTransmision.split('|');
    log('initData3: $listaNombres $listaUrls $activaTransmision');
    List<Song> listaCanciones = new List<Song>();
    for(int i = 0; i<listaNombres.length; i++){
      if(listaNombres[i] != ""){
        listaCanciones.add(new Song(i,"", listaNombres[i], "",0,0,listaUrls[i],null, ""));
      }
    }
    for(String s in listaNombres){
      log('initData3: $s');
    }
    List<Song> songs;
    songs = listaCanciones;
    enVivo = activaTransmision;

    dm.fetchSongsManual(songs);
  }

}

class ListaDirectos {
  final String nombresAudio;
  final String urlsAudio;
  final String usuarios;
  final String activaTransmision;

  ListaDirectos({this.nombresAudio, this.urlsAudio, this.usuarios,this.activaTransmision});

  factory ListaDirectos.fromJson(Map<String, dynamic> json) {
    return ListaDirectos(
      nombresAudio: json['nombresTransmision'],
      urlsAudio: json['urlsTransmision'],
      usuarios: json['usuariosTransmision'],
      activaTransmision: json['activaTransmision'],
    );
  }
  String getNombresAudio(){
    return nombresAudio;
  }
  String getUrlsAudio(){
    return urlsAudio;
  }
  String getUsuariosAudio(){
    return usuarios;
  }
}




Future<ListaDirectos> obtenerListaCompletaDirectos() async {
  Map data = {
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/todas_transmisiones_android',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),

  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return ListaDirectos.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo al enviar petición');
  }
}