import 'dart:convert';
import 'dart:developer';

import 'package:beats/Animations/transitions.dart';
import 'package:beats/models/PlayListHelper.dart';
import 'package:beats/models/PlaylistRepo.dart';
import 'package:beats/models/PlaylistRepoGeneros.dart';
import 'package:beats/models/ThemeModel.dart';
import 'package:beats/models/BookmarkModel.dart';
import 'package:beats/models/Username.dart';
import 'package:beats/models/const.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:beats/models/SongsModel.dart';
import 'package:flutter_radio/flutter_radio.dart';
import '../custom_icons.dart';
import 'package:provider/provider.dart';
import 'PlayList.dart';
import 'Player.dart';
import 'package:http/http.dart' as http;

import 'PlaylistGenero.dart';
import 'ProfileEdit.dart';

double height, width;

class MusicLibrary extends StatefulWidget {
  @override
  _MusicLibraryState createState() => _MusicLibraryState();
}

class _MusicLibraryState extends State<MusicLibrary> {
  TextEditingController editingController;

  PlaylistRepoGeneros playlistRepo;
  PlaylistRepo miPlaylistRepo;
  SongsModel model;

  BookmarkModel b;

  ThemeChanger themeChanger;

  TextEditingController txt = TextEditingController();

  bool error = false;
  List<Song> songs;
  Username username;
  List<String> generos = [""];
  @override
  void initState() {
    super.initState();

  }
  @override
  void didChangeDependencies() {
    model = Provider.of<SongsModel>(context);
    b = Provider.of<BookmarkModel>(context);
    username = Provider.of<Username>(context);
    playlistRepo = Provider.of<PlaylistRepoGeneros>(context);
    miPlaylistRepo = Provider.of<PlaylistRepo>(context);
      obtenerCancionesRandom(model);
    anyadeDatosUsuario(username.email, miPlaylistRepo);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    themeChanger = Provider.of<ThemeChanger>(context);
    convertirALista();
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
                    "No hay canciones",
                    style: Theme.of(context).textTheme.display1,
                  ),
                )
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverOverlapAbsorber(
                            child: SliverSafeArea(
                              top: false,
                              sliver: SliverAppBar(
                                floating: true,
                                pinned: true,
                                snap: false,
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
                                expandedHeight: height * 0.31,
                                flexibleSpace: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.06, top: 20.9),
                                    child: Container(
                                      child: Column(children: <Widget>[
                                      Align(child: Text(
                                        "Canciones",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: Theme.of(context)
                                                .textTheme
                                                .display1
                                                .color),
                                      ),
                                      alignment: Alignment.centerLeft,),

                                            Flexible(child: SizedBox(
                                              height: height * 0.16,
                                              child: Consumer<PlaylistRepoGeneros>(
                                                builder: (context, playlistRepo, _) => ListView.builder(

                                                  itemCount: (playlistRepo.playlist.length != null)
                                                      ?playlistRepo.playlist.length : 0,
                                                  itemBuilder: (context, pos) {
                                                    var padd = (pos == 0) ? width * 0.08 : 5.0;
                                                      return Card(
                                                        margin: EdgeInsets.only(left: padd, right: 5.0, top: 15.0),
                                                        elevation: 5,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20)),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            playlistRepo.selected = pos;
                                                            Navigator.push(context, Scale(page: PlaylistGenero()));
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
                                                                    child: Padding(padding: EdgeInsets.only(
                                                                        left: 25.0, right: 25.0, top: 50.0, bottom: 13.0),
                                                                      child: Column(children: <Widget>[
                                                                        Flexible(child: Text(playlistRepo.playlist[pos],
                                                                            textAlign: TextAlign.center,
                                                                            style:
                                                                            TextStyle(color: Colors.white),
                                                                            textScaleFactor: 1.3),),

                                                                      ]),),
                                                                  ),
                                                                ]),
                                                              )),
                                                        ),
                                                      );

                                                  },
                                                  scrollDirection: Axis.horizontal,
                                                ),
                                              ),
                                            ),)

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ),
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context)),

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
  anyadeDatosUsuario(String email, PlaylistRepo playlistRepo) async {
    PerfilPlaylist p = await obtenerPerfilPlaylists(email);
    String u = p.nombreUsuario;
    if (p.nombreUsuario != null) {
      var playlistss = p.playlists.split('|');
      List<String> misCancionesTitle = new List();
      misCancionesTitle = playlistss;
      miPlaylistRepo.generateInitialPlayList(misCancionesTitle, misCancionesTitle);
    }

  }

  convertirALista() async{
    Respuesta r = await recibeGeneros();
    generos = r.generos.split('|');
    playlistRepo.generateInitialPlayList(generos, generos);

  }
  obtenerCancionesRandom(SongsModel model) async {

    ListaCancionesDefault c = await obtenerListaCanciones();
    List<String> listaNombres = c.getNombresAudio().split('|');
    List<String> listaUrls = c.getUrlsAudio().split('|');
    List<String> listaIds = c.listaIds.split('|');
    if(listaIds[0] == ""){
      listaIds[0] = "9999";
    }
    setState(() {
      songs = new List<Song>();
      for(int i = 0; i<listaNombres.length; i++){
        songs.add(new Song(int.parse(listaIds[i]),"", listaNombres[i], "",0,0,listaUrls[i],null, ""));
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
                trailing: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ),
                  onSelected: (String choice) async {
                    log("data: $choice");
                    if (choice == Constants.pl) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Añadir a Playlist",
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: double.maxFinite,
                                  child: (repo.playlist.length != 0)
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: repo.playlist.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                              child: ListTile(
                                                onTap: () {
                                                  PlaylistHelper(
                                                          repo.playlist[index])
                                                      .add(model.songs[pos]);
                                                  Navigator.pop(context);
                                                  anyadirCancionAPlaylist(model.songs[pos], repo.playlist[index]);
                                                },
                                                title: Text(
                                                  repo.playlist[index],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display2,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: Text("No existen Playlists"),
                                        ),
                                )
                              ],
                            );
                          });
                    }
                    //} else if (choice == Constants.de) {

                    //   model.fetchSongs();
                    // }else if(choice == Constants.re){
                    //   Directory x = await getExternalStorageDirectory();
                    //   await File("${x.path}../../").rename(x.path);
                    //}
                  },
                  itemBuilder: (BuildContext context) {
                    return Constants.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            choice,
                            style: Theme.of(context).textTheme.display2,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
                onTap: () async {
                  log("efectivamente");
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
  Future<Respuesta> anyadirCancionAPlaylistBD(String idAudio, String nombrePlaylist) async {
    Map data = {
      'email': username.email,
      'idAudio': idAudio,
      'nombreLista': nombrePlaylist,
    };
    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/anyadir_audio_lista_android',
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

  push(context) {
    username.esCancion = true;
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
                username.esCancion = true;
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
                          username.esCancion = true;
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

  void anyadirCancionAPlaylist(Song song, String playlist) async {
    String s = song.title;
    log("data $s, $playlist");
    await anyadirCancionAPlaylistBD(song.id.toString(), playlist);
    log("done añadir a playlist");
  }
}

/*class Respuesta {
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
}*/



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
    List<String> dummy = <String>[];
    List<String> recents = <String>[];
    for (int i = 0; i < model.songs.length; i++) {
      dummy.add(model.songs[i].title);
    }
    //for (int i = 0; i < 4; i++) {
    // recents.add(model.songs[i].title);
    //}
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
            onTap: () {
                model.player.stop();
                //model.playURI(suggestion[index].uri);
                model.playURI(model.devuelveCancion(suggestion[index]).uri);
                model.playlist = false;
                close(context, null);

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
            leading: CircleAvatar(backgroundColor: Colors.orange,child: Icon(Icons.music_note, color: Colors.white,)),
          ),
        );
      },
    );
  }

}



class PerfilPlaylist {
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

  PerfilPlaylist({this.respuesta, this.nombreUsuario, this.descripcion, this.email,
    this.contrasenya, this.repetirContraseya, this.playlists, this.descripcionesPlay,
    this.canciones, this.urls, this.podcasts,this.descripcionesPod,this.imagen,
    this.numSeguidores, this.imagenesPlaylists, this.imagenesPodcasts});

  factory PerfilPlaylist.fromJson(Map<String, dynamic> json) {
    return PerfilPlaylist(
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




Future<PerfilPlaylist> obtenerPerfilPlaylists(String email) async {
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
    return PerfilPlaylist.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo al enviar petición');
  }
}
class Respuesta {
  final String generos;

  Respuesta({this.generos});

  factory Respuesta.fromJson(Map<String, dynamic> json) {
    return Respuesta(
      generos: json['generos'],

    );

  }
  String getUserId(){
    return generos;
  }
}

Future<Respuesta> recibeGeneros() async {
  Map data = {
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/generos_android',
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
class Playlists {
  final String playlists;

  Playlists({this.playlists});

  factory Playlists.fromJson(Map<String, dynamic> json) {
    return Playlists(
      playlists: json['lista'],

    );

  }
  String getUserId(){
    return playlists;
  }
}
Future<Playlists> recibePlaylists() async {
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