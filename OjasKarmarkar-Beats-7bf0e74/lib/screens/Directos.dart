import 'dart:convert';
import 'dart:developer';

import 'package:beats/Animations/transitions.dart';
import 'package:beats/models/PlayListHelper.dart';
import 'package:beats/models/PlaylistRepo.dart';
import 'package:beats/models/ThemeModel.dart';
import 'package:beats/models/BookmarkModel.dart';
import 'package:beats/models/Username.dart';
import 'package:beats/models/const.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:beats/models/SongsModel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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

  SongsModel model;

  BookmarkModel b;

  ThemeChanger themeChanger;

  TextEditingController txt = TextEditingController();

  bool error = false;
  List<Song> songs;
  Username username;
  @override
  void didChangeDependencies() {
    model = Provider.of<SongsModel>(context);
    b = Provider.of<BookmarkModel>(context);
    username = Provider.of<Username>(context);
    obtenerCancionesRandom(model);
    model.setEmail(username.email);



    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    themeChanger = Provider.of<ThemeChanger>(context);

    for(int i=0; i<model.getSongs().length;i++){
      String s = model.getSongs().elementAt(i).title;
      log('cancion: $s');
    }

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).backgroundColor,
          body: (model.songs == null || (model.songs.length == 1 && model.songs[0].title == ""))
              ? Center(
            child: Text(
              "No hay directos",
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
                    children: <Widget>[getLoading(model)],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: showStatus(model, context),
                  )
                ],
              ))),
      onWillPop: () {},
    );
  }

  obtenerCancionesRandom(SongsModel model) async {

    ListaDirectos c = await obtenerListaDirectos();
    List<String> listaNombres = c.getNombresAudio().split('|');
    List<String> listaUrls = c.getUrlsAudio().split('|');
    List<String> usuarios = c.getUsuariosAudio().split('|');


    setState(() {
      songs = new List<Song>();
      for(int i = 0; i<listaNombres.length; i++){
        songs.add(new Song(1,"", listaNombres[i], "",0,0,listaUrls[i],null));
      }
      for(String s in listaNombres){
        log('initData2: $s');
      }
      model.fetchSongsManual(songs);
    });

  }

  getLoading(SongsModel model) {
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
            return Consumer<PlaylistRepo>(builder: (context, repo, _) {
              return ListTile(
                onTap: () async {
                  model.player.stop();
                  model.playlist = true;
                  model.playlistSongs = songs;
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
    Navigator.push(context, SlideRightRoute(page: PlayBackPage()));
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
                Navigator.push(context, Scale(page: PlayBackPage()));
              },
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        color: Theme.of(context).textTheme.display1.color,
                        icon: Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          Navigator.push(context, Scale(page: PlayBackPage()));
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
                          icon: model.currentState == PlayerState.PAUSED ||
                              model.currentState == PlayerState.STOPPED
                              ? Icon(
                            CustomIcons.play,
                            color: Theme.of(context)
                                .textTheme
                                .display1
                                .color,
                            size: 20.0,
                          )
                              : Icon(
                            CustomIcons.pause,
                            color: Theme.of(context)
                                .textTheme
                                .display1
                                .color,
                            size: 20.0,
                          ),
                          onPressed: () {
                            if (model.currentState == PlayerState.PAUSED ||
                                model.currentState == PlayerState.STOPPED) {
                              model.play();


                            } else {

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
  SongsModel model;
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
    model = Provider.of<SongsModel>(context);
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
              //model.playURI(suggestion[index].uri);
              model.playURI(suggestion[index].uri);
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
          ),
        );
      },
    );
  }

}

class ListaDirectos {
  final String nombresAudio;
  final String urlsAudio;
  final String usuarios;


  ListaDirectos({this.nombresAudio, this.urlsAudio, this.usuarios});

  factory ListaDirectos.fromJson(Map<String, dynamic> json) {
    return ListaDirectos(
      nombresAudio: json['nombresTransmision'],
      urlsAudio: json['urlsTransmision'],
      usuarios: json['usuariosTransmision'],
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


