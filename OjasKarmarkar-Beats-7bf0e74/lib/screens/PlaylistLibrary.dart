import 'dart:convert';
import 'dart:developer';

import 'package:beats/Animations/transitions.dart';
import 'package:beats/models/PlaylistRepo.dart';
import 'package:beats/models/PodcastRepo.dart';
import 'package:beats/models/SongsModel.dart';
import 'package:beats/models/ThemeModel.dart';
import 'package:beats/models/Username.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:beats/models/CapPodcastsModel.dart';
import '../custom_icons.dart';
import 'package:provider/provider.dart';
import 'Player.dart';
import 'package:http/http.dart' as http;

import 'PlaylistsNoEditable.dart';
import 'Podcasts.dart';
import 'PodcastsNoEditable.dart';

double height, width;

class PlaylistLibrary extends StatefulWidget {
  @override
  _PlaylistLibraryState createState() => _PlaylistLibraryState();
}
// ignore: must_be_immutable
class _PlaylistLibraryState extends State<PlaylistLibrary> {
  TextEditingController editingController;

  ThemeChanger themeChanger;

  TextEditingController txt = TextEditingController();

  bool error = false;

  List<String> playlists;
  PlaylistRepo playlistRepo;
  Username user;

  @override
  void initState() {
    super.initState();

  }
  @override
  void didChangeDependencies() {
    user = Provider.of<Username>(context);
    height = MediaQuery.of(context).size.height;
    playlistRepo = Provider.of<PlaylistRepo>(context);


    anyadePlaylists(playlistRepo);


    width = MediaQuery.of(context).size.width;
    themeChanger = Provider.of<ThemeChanger>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).backgroundColor,
          body: (playlistRepo.playlist == null)
              ? Center(
            child: Text(
              "No hay playlists",
              style: Theme.of(context).textTheme.display1,
            ),
          )
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
                                    "Playlists",
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
              body: getLoading(playlistRepo))),
      onWillPop: () {},
    );
  }

  getLoading(PlaylistRepo model) {
    if (model.playlist.length == 0) {
      return Flexible(
          child: Center(
            child: Text("No hay playlists..."),
          ));
    } else {
      return Padding(
          padding: EdgeInsets.only(top: height * 0.04),
          child: SizedBox(
            height: height * 0.6,
            child: Consumer<PlaylistRepo>(
              builder: (context, pos, _) => ListView.builder(
                itemCount: playlistRepo.playlist.length,
                itemBuilder: (context, pos) {
                  return Card(
                    margin: EdgeInsets.only(left: 0.4, right: 5.0),
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: GestureDetector(
                      onDoubleTap: () async{
                        await Like(user.email, playlistRepo.playlist[pos], "playlist");
                        await likeado(user.email, playlistRepo.playlist[pos]);
                      },
                      onTap: () {
                        playlistRepo.selected = pos;
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => new PLayListNoEditableScreen()));
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: width * 0.4,
                            height: height *0.1,
                            decoration: (playlistRepo.imagenes[pos] == "" || playlistRepo.imagenes[pos] == null)
                                ?BoxDecoration(
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
                            ) : BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(playlistRepo.imagenes[pos]),
                                  fit: BoxFit.cover,
                                )
                            ),
                            child: Stack(children: <Widget>[

                              Center(
                                child: Padding(padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 23.0, bottom: 13.0),
                                  child: Column(children: <Widget>[
                                    Flexible(child: Text(playlistRepo.playlist[pos],
                                        textAlign: TextAlign.center,
                                        style:
                                        TextStyle(color: Colors.white),
                                        textScaleFactor: 1.3),),
                                    Flexible(child: Text(playlistRepo.descripciones[pos],
                                        style:
                                        TextStyle(color: Colors.white)),),


                                  ]),),
                              ),]),
                          )),
                    ),
                  );

                },
                scrollDirection: Axis.vertical,
              ),
            ),
          ));
    }
  }

  push(context) {
    Navigator.push(context, SlideRightRoute(page: PlayBackPage()));
  }

  void anyadePlaylists(PlaylistRepo playlistRepo) async{
    Playlists p = await obtenerPlaylists();

    List<String> listaNombres = p.playlists.split('|');
    List<String> listaDescripciones = p.descripciones.split('|');
    List<String> listaImagenes = p.imagenes.split('|');
    log('playlists: $listaNombres');
    log('urls: $listaImagenes');

    setState(() {
      playlistRepo.generateInitialPlayListImage(listaNombres, listaDescripciones, listaImagenes);
    });
  }

  Future<Playlists> obtenerPlaylists() async {
    Map data = {
    };
    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/todas_listas_android',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),

    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Playlists.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Fallo al enviar petición');
    }
  }

  void Like(String email, String titulo, String tipo) async {
    Map data = {
      'email' : email,
      'titulo' : titulo,
      'tipo' : tipo,
      'url' : "",
    };

    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/like_android',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      log("se ha cambiado de como estaba");
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Fallo al enviar petición');
    }
  }

  void likeado(String email, String playlist) async {
    Map data = {
      'email' : email,
      'titulo' : playlist,
      'tipo' : "playlist",
      'url' : "",
    };

    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/tiene_like_android',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),

    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      respuesta r = respuesta.fromJson(json.decode(response.body));
      String s = r.getlikeado();
      log("likeado: $s");
      if(r.getlikeado() == "false") {
        log("estoy aqui");
        Fluttertoast.showToast(
          msg: "Le has quitado el like",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else if (r.getlikeado() == "true") {
        log("estoy alla");
        Fluttertoast.showToast(
          msg: "¡Le has dado a like!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        ); ;
      }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Fallo al enviar petición');
    }
  }
}

//OTRA CLASE DISTINTA **********************************************************

class Search extends SearchDelegate<Song> {
  PlaylistRepo model;
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
    Username user = Provider.of<Username>(context);
    model = Provider.of<PlaylistRepo>(context);
    List<String> dummy = <String>[];
    List<String> recents = <String>[];
    for (int i = 0; i < model.playlist.length; i++) {
      dummy.add(model.playlist[i]);
    }
    var suggestion = query.isEmpty
        ? recents
        : dummy
        .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    // hint when searches
    return ListView.builder(
      itemCount: suggestion.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            trailing: IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  size: 17,
                  color: Colors.black54,
                ),
                onPressed: () async {
                  Like(user.email, model.playlist[index], "playlist");
                  likeado(user.email, model.playlist[index]);
                }
            ),
            onTap: () {
                model.selected = model.devuelveIndexPlaylist(suggestion[index]);
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new PLayListNoEditableScreen()));

            },
            title: Text.rich(
              TextSpan(
                  text: suggestion[index] + "\n",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                  ),
                  children: <TextSpan>[
                    new TextSpan(
                        text: suggestion[index],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w100))
                  ]),
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            leading: CircleAvatar(backgroundColor: Colors.purple,child: Icon(Icons.headset, color: Colors.white,)),
          ),
        );
      },
    );

  }

  void Like(String email, String titulo, String tipo) async {
    Map data = {
      'email' : email,
      'titulo' : titulo,
      'tipo' : tipo,
      'url' : "",
    };

    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/like_android',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      log("se ha cambiado de como estaba");
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Fallo al enviar petición');
    }
  }

  void likeado(String email, String playlist) async {
    Map data = {
      'email' : email,
      'titulo' : playlist,
      'tipo' : "playlist",
      'url' : "",
    };

    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/tiene_like_android',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),

    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      respuesta r = respuesta.fromJson(json.decode(response.body));
      String s = r.getlikeado();
      log("likeado: $s");
      if(r.getlikeado() == "false") {
        log("estoy aqui");
        Fluttertoast.showToast(
          msg: "Le has quitado el like",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else if (r.getlikeado() == "true") {
        log("estoy alla");
        Fluttertoast.showToast(
          msg: "¡Le has dado a like!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        ); ;
      }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Fallo al enviar petición');
    }
  }

}

class Playlists {
  final String playlists;
  final String descripciones;
  final String imagenes;

  Playlists({this.playlists, this.descripciones, this.imagenes});

  factory Playlists.fromJson(Map<String, dynamic> json) {
    return Playlists(
      playlists: json['lista'],
      descripciones: json['listaDescripcion'],
      imagenes: json['listaImagen'],
    );

  }
  String getUserId(){
    return playlists;
  }
  String getDescripciones(){
    return descripciones;
  }
  String getImagenes(){
    return imagenes;
  }
}


