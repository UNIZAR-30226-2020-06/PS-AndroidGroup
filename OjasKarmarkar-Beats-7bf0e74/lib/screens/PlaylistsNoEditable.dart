import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beats/Animations/transitions.dart';
import 'package:beats/models/MisCancionesModel.dart';
import 'package:beats/models/PlaylistRepo.dart';
import 'package:beats/models/SongsModel.dart';
import 'package:beats/models/PlayListHelper.dart';
import 'package:beats/models/Username.dart';
import 'package:beats/screens/UploadSong.dart';
import 'package:beats/models/const.dart';
import 'package:beats/reproductorMusica.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'package:provider/provider.dart';
import 'package:beats/screens/ProfileEdit.dart';
import '../custom_icons.dart';
import 'MusicLibrary.dart';
import 'package:http/http.dart' as http;

import 'Player.dart';
import 'ProfileEdit.dart';

class PLayListNoEditableScreen extends StatefulWidget {
  @override
  _PLayListNoEditableScreenState createState() => _PLayListNoEditableScreenState();
}

class _PLayListNoEditableScreenState extends State<PLayListNoEditableScreen> {
  PlaylistRepo playlistRepo;
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
  String imagen = "";
  String autor = "";
  String descripcion = "";

  @override
  void didChangeDependencies() {
    username = Provider.of<Username>(context);
    playlistRepo = Provider.of<PlaylistRepo>(context);
    model = Provider.of<SongsModel>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    int stringerr = playlistRepo.selected;
    obtieneGeneros();

    log("playlistrepo: $stringerr");
    name = playlistRepo.playlist[playlistRepo.selected];
    //playlistRepo.selected = null;
    initDataPlaylists();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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
                    decoration: BoxDecoration(
                    color: Colors.orange,
                        image: DecorationImage(
                          image: NetworkImage(imagen),
                          fit: BoxFit.cover,
                        ),),
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
                        Align(alignment: Alignment.center,child:
                          Text(name +"\n" +descripcion +"\n" +"Autor: "+autor,
                              textAlign: TextAlign.center,
                              style:
                              TextStyle(color: Colors.white),
                              textScaleFactor: 1.5),
                        ),

                    ]),
                  )),
            ];
          },
          body: (songs != null)
              ? (songs.length != 0 && songs[0].title != "")
              ? Stack(children: <Widget>[

            ConditionalBuilder(
                condition: true, //vista de una playlist de canciones
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
                          leading: CircleAvatar(child: getImage(pos)),
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
              "Vacío...",
              style: Theme.of(context).textTheme.display2,
            ),
          )),
    );
  }

  //void initData() async {
  //  var helper = PlaylistHelper(name);
  //  songs = await helper.getSongs();
  //  setState(() {});
  //}

  void initDataPlaylists() async {
    Canciones l = await obtenerCanciones(username.email, name);
    imagen = l.imagen;
    autor = l.autor;
    descripcion = l.descripcion;
    var listaNombres = l.getNombresAudio().split('|');
    var listaUrls = l.getUrlsAudio().split('|');
    var listaIds = l.listaIds.split('|');
    if(listaIds[0] == ""){
      listaIds[0] = "9999";
    }
    log('initData2: $listaNombres');
    List<Song> listaCanciones = new List<Song>();
    for(int i = 0; i<listaNombres.length; i++){
      listaCanciones.add(new Song(int.parse(listaIds[i]),"", listaNombres[i], "",0,0,listaUrls[i],null, ""));
    }

    songs = listaCanciones;
    model.fetchSongsManual(songs);
    setState(() {});
  }

  void initDataMisCanciones() async{
    var listaNombres = username.getCanciones().split('|');
    var listaUrls = username.getCancionesUrl().split('|');
    var listaIds = username.getIdsCanciones().split('|');
    log('initData3: $listaNombres');
    List<Song> listaCanciones = new List<Song>();

    for(int i = 0; i<listaNombres.length; i++){
      if(listaNombres[i] != ""){
        listaCanciones.add(new Song(listaIds[i],"", listaNombres[i], "",0,0,listaUrls[i],null, ""));
      }

    }

    songs = listaCanciones;
    model.fetchSongsManual(songs);
    setState(() {});
  }

  getImage(pos) {
    if (songs[pos].albumArt != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.file(File.fromUri(Uri.parse(songs[pos].albumArt))));
    } else {
      return Icon(Icons.music_note, color: Colors.white,);
    }
  }

  showStatus() {
    if (model.currentSong != null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.orange[400],
          border: Border.all(color: Colors.orangeAccent),
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

  void obtieneGeneros() async {
    generos = await convertirALista();
  }

  actualizarUsername(String email) async{
    Perfil p = await obtenerPerfil(email);
    String s = p.canciones;
    log("actualizarUsername: $s");
    setState(() {
      username.setCanciones(p.canciones);
      username.setCancionesUrl(p.urls);
    });
  }
}

class Canciones {
  final String respuesta;
  final String nombresAudio;
  final String urlsAudio;
  final String genero;
  final String autor;
  final String descripcion;
  final String imagen;
  final String listaIds;
  Canciones({this.respuesta, this.nombresAudio,this.urlsAudio, this.genero, this.autor, this.descripcion, this.imagen, this.listaIds});

  factory Canciones.fromJson(Map<String, dynamic> json) {
    return Canciones(
      nombresAudio: json['nombresAudio'],
      urlsAudio: json['urlsAudio'],
      imagen: json['imagen'],
      descripcion: json['descripcion'],
      autor: json['autor'],
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
}

Future<Canciones> obtenerCanciones(String email, String nombrePlaylist) async {
  Map data = {
    'email': email,
    'nombrePlaylist': nombrePlaylist,
  };
  log("data $email, $nombrePlaylist");
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/obtener_audios_android',
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