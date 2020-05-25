import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beats/Animations/transitions.dart';
import 'package:beats/models/PlaylistRepo.dart';
import 'package:beats/models/PlaylistRepoGeneros.dart';
import 'package:beats/models/PodcastRepo.dart';
import 'package:beats/models/SongsModel.dart';
import 'package:beats/models/PlayListHelper.dart';
import 'package:beats/models/Username.dart';
import 'package:beats/models/const.dart';
import 'package:beats/reproductorMusica.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'package:provider/provider.dart';
import '../custom_icons.dart';
import 'MusicLibrary.dart';
import 'package:http/http.dart' as http;

import 'Player.dart';
import 'ProfileEdit.dart';

class PlaylistGenero extends StatefulWidget {
  @override
  _PlaylistGeneroState createState() => _PlaylistGeneroState();
}

class _PlaylistGeneroState extends State<PlaylistGenero> {
  PlaylistRepoGeneros playlistRepo;
  SongsModel model;
  String name;
  TextEditingController editingController;
  TextEditingController txt = TextEditingController();
  bool error = false;
  List<Song> songs;
  Username username;
  List<String> generos; // Option 2
  String genero;
  //final String email;

  //_PLayListScreenState({Key key, @required this.email}) : super(key: key);



  @override
  void didChangeDependencies() {
    username = Provider.of<Username>(context);
    playlistRepo = Provider.of<PlaylistRepoGeneros>(context);
    model = Provider.of<SongsModel>(context);
    int stringerr = playlistRepo.selected;

    log("playlistrepo: $stringerr");
    name = playlistRepo.playlist[playlistRepo.selected];
    playlistRepo.selected = null;
    log("nameee: $name");
    initDataPlaylistGenero();


    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).backgroundColor,
                  expandedHeight: height * 0.25,
                  floating: true,
                  pinned: false,
                  snap: false,
                  flexibleSpace: Container(
                    height: 200,
                    color: Colors.orange,
                    child: Stack(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: height * 0.01, left: width * 0.034),
                          child: SizedBox(
                            width: 42.0,
                            height: 42.0,
                            child: IconButton(
                              iconSize: 35.0,
                              icon: Icon(
                                CustomIcons.arrow_circle_o_left,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);

                              },
                            ),
                          )),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: height * 0.02),
                          child: Text(
                            name,
                            style:
                            TextStyle(fontSize: 40.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ]),
                  )),
            ];
          },
          body: (songs != null)
              ? (songs[0].title != "")
              ? Stack(children: <Widget>[

            ConditionalBuilder(
                condition: true,
                builder: (context) => ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, pos) {
                      return Padding(
                        padding:
                        const EdgeInsets.only(top: 0.0, left: 10.0),
                        child: ListTile(
                          onTap: () {
                            //isPlayed = true;
                            model.player.stop();
                            model.playlist = true;
                            model.playlistSongs = songs;
                            model.currentSong = songs[pos];
                            //Navigator.of(context).push(new MaterialPageRoute(
                            //    builder: (context) => new ExampleApp(url: model.currentSong.uri)));
                            model.play();

                          },
                          leading: CircleAvatar(backgroundColor: Colors.orange,child: getImage(pos)),
                          title: Text(
                            songs[pos].title,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.display3,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              songs[pos].artist,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.display2,
                            ),
                          ),
                        ),
                      );
                    }
                )
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: showStatus(),
            )
          ])
              : Center(
            child: Text(
              "No hay canciones",
              style: Theme.of(context).textTheme.display2,
            ),
          )
              : Center(
            child: Text(
              "Vacío... ",
              style: Theme.of(context).textTheme.display2,
            ),
          )),
    );
  }

  void initDataPlaylistGenero() async {
    Canciones l = await obtenerCancionesGenero(name);
    log("nameeee: $name");

    List<String> listaNombres = l.getNombresAudio().split('|');
    log("nombresAudio2: $listaNombres");
    List<String> listaUrls = l.getUrlsAudio().split('|');
    log("nombresAudio3: $listaUrls");
    List<String> listaIds = l.getListasId().split('|');
    log("nombresAudio4: $listaIds");
    List<Song> listaPodcasts = new List<Song>();
    for(int i = 0; i<listaNombres.length; i++){
      listaPodcasts.add(new Song(int.parse(listaIds[i]),"", listaNombres[i], "",0,0,listaUrls[i],null));
    }
    log("nombresAudio5: $listaNombres");
    songs = listaPodcasts;
    //model.fetchSongsManual(songs);
    setState(() {});
  }

  getImage(pos) {
    if (songs[pos].albumArt != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.file(File.fromUri(Uri.parse(songs[pos].albumArt))));
    } else {
      return Icon(Icons.mic, color: Colors.white,);
    }
  }

  showStatus() {
    if (model.currentSong != null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.orange[400],
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(10.0),
              bottomRight: Radius.elliptical(10, 4)),
        ),
        child: GestureDetector(
          onTap: () {
            username.esCancion = true;
            Navigator.push(context, Scale(page: PlayBackPage()));
          },
          child:Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              leading: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: (model.currentSong.albumArt != null)
                        ? Image.file(
                      File.fromUri(Uri.parse(model.currentSong.albumArt)),
                      width: 100,
                      height: 100,
                    )
                        : Image.asset("assets/headphone.png"),
                  )),
              title: Text(
                model.currentSong.title,
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 11.0),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 0, top: 5.0, bottom: 10.0),
                child: Text(
                  model.currentSong.artist,
                  maxLines: 1,
                  style: TextStyle(
                      fontFamily: 'Sans', color: Colors.white, fontSize: 11.0),
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      if (model.currentState == PlayerState.PAUSED ||
                          model.currentState == PlayerState.STOPPED) {
                        model.play();
                      } else {
                        model.pause();
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      child: FloatingActionButton(
                        child: (model.currentState == PlayerState.PAUSED ||
                            model.currentState == PlayerState.STOPPED)
                            ? Icon(
                          CustomIcons.play,
                          size: 20.0,
                        )
                            : Icon(
                          CustomIcons.pause,
                          size: 20.0,
                        ),
                      ),
                    )),
              ),
            ),
          ),),
        height: height * 0.1,
        width: width * 0.62,
      );
    } else {}
  }

}

class Canciones {
  final String respuesta;
  final String nombresAudio;
  final String urlsAudio;
  final String listaIds;

  Canciones({this.respuesta, this.nombresAudio,this.urlsAudio, this.listaIds});

  factory Canciones.fromJson(Map<String, dynamic> json) {
    return Canciones(
      nombresAudio: json['nombresAudio'],
      urlsAudio: json['urlsAudio'],
      listaIds: json['idsAudio'],
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
  String getListasId(){
    return listaIds;
  }
}

Future<Canciones> obtenerCancionesGenero(String genero) async {
  Map data = {
    'genero': genero,
  };
  log("servlet: $genero");
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/audios_genero_android',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),

  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    Canciones c = Canciones.fromJson(json.decode(response.body));
    String s = c.getListasId();
    log("nombresAudio: $s");
    return c;
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

