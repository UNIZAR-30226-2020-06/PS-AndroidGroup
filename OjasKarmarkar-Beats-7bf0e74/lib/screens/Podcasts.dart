import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beats/Animations/transitions.dart';
import 'package:beats/models/PlaylistRepo.dart';
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

class PodcastScreen extends StatefulWidget {
  @override
  PodcastScreenState createState() => PodcastScreenState();
}

class PodcastScreenState extends State<PodcastScreen> {
  PodcastRepo podcastRepo;
  SongsModel model;
  String name;
  TextEditingController editingController;
  TextEditingController txt = TextEditingController();
  bool error = false;
  List<Song> songs;
  Username username;
  List<String> generos; // Option 2
  String genero;
  String imagen = "";
  String autor = "";
  String descripcion = "";
  //final String email;

  //_PLayListScreenState({Key key, @required this.email}) : super(key: key);



  @override
  void didChangeDependencies() {
    username = Provider.of<Username>(context);
    podcastRepo = Provider.of<PodcastRepo>(context);
    model = Provider.of<SongsModel>(context);
    int stringerr = podcastRepo.selected;
    convertirALista();

    log("playlistrepo: $stringerr");
    if(podcastRepo.selected != null)
    {
      name = podcastRepo.podcast[podcastRepo.selected];
      podcastRepo.selected = null;
      initDataPodcasts();
    }

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
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
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
              ? (songs[0].title != "")
              ? Stack(children: <Widget>[

            ConditionalBuilder(
                condition: true, //vista de una lista de capítulos de podcast
                builder: (context) => ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, pos) {
                      return Padding(
                        padding:
                        const EdgeInsets.only(top: 0.0, left: 10.0),
                        child: ListTile(
                          trailing: PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey,
                            ),
                            onSelected: (String choice) async {
                              log("data: $choice");
                              if (choice == Constants.ep) {
                                txt.text = model.songs[pos].title;//editar capítulo de podcast
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
                                              DropdownButton(
                                                  hint: Text('Elige un género',style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.bold)), // Not necessary for Option 1
                                                  value: genero,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      genero = newValue;
                                                    });
                                                  },
                                                  items: generos.map((location) {
                                                    return DropdownMenuItem(
                                                      child: new Text(location),
                                                      value: location,
                                                    );
                                                  }).toList(),
                                                ),

                                              InkWell(
                                                onTap: ()  {
                                                  setState(() {
                                                    editarUnCapituloPodcast(username.email, model.songs[pos].id.toString(),
                                                        model.songs[pos].title,txt.text, genero);  //editar en la BD

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
                              }else if(choice == Constants.dp){ //borrar canciones
                                mostrarComprobacion(model.songs[pos], choice);
                              }else if(choice == Constants.dpp){
                                mostrarComprobacion(model.songs[pos], choice);
                              }
                            },
                            itemBuilder: (model.songs[pos].getEsMio() == "true")?(BuildContext context) {
                              return Constants.opcionesPodcast.map((String choice) {
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
                            } : (BuildContext context) {
                              return Constants.opcionesPodcastAjeno.map((String choice) {
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
                            }
                          ),
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
                          leading: CircleAvatar(backgroundColor: Colors.purpleAccent,child: getImage(pos)),
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
              "No hay capítulos",
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
  void mostrarComprobacion(Song nombreCancion, String choice){
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
                        "¡Alto ahí!",
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
                      child: (choice == Constants.dp)?Text("Quitar capítulo de podcast"):Text("Borrar capítulo de podcast"),
                  ),
                  InkWell(
                    onTap: () {
                      if(choice == Constants.dp){
                        quitarCapituloPodcast(username.email, name, nombreCancion);
                      }else{
                        borrarCapituloPodcast(username.email, name, nombreCancion);
                      }

                      Navigator.pop(context);
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
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
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
      },
    );
  }

  void initDataPodcasts() async {
    Canciones l = await obtenerCapitulos(name, username.email);
    var listaNombres = l.getNombresAudio().split('|');
    var listaUrls = l.getUrlsAudio().split('|');
    var listaIds = l.listaIds.split('|');
    var sonMios = l.sonMios.split('|');
    log('initData2: $sonMios');
    if(listaIds[0] == ""){
      listaIds[0] = "9999";
    }
    imagen = l.imagen;
    autor = l.autor;
    descripcion = l.descripcion;
    List<Song> listaPodcasts = new List<Song>();
    for(int i = 0; i<listaNombres.length; i++){
      Song song = new Song(int.parse(listaIds[i]),"", listaNombres[i], "",0,0,listaUrls[i],null, "");
      song.esMio = sonMios[i];
      listaPodcasts.add(song);
    }

    songs = listaPodcasts;
    model.fetchSongsManual(songs);
    setState(() {});
  }

  void editarUnCapituloPodcast(String email, String idCapitulo, String title, String newTitle, String genero) async {
    log("pod: $title $newTitle $genero");
    InfoCancion ic = await obtenerInfoCancion(idCapitulo);
    String aux = " ";
    if(genero != null){
      aux = genero;
    }
    await editarCapPodcast(email,idCapitulo, title, newTitle, aux, ic.genero);
    initDataPodcasts();
  }


  Future<InfoCancion> obtenerInfoCancion(String idCancion) async {
  Map data = {
  'idCancion': idCancion,
  };
  final http.Response response = await http.post(
  'http://34.69.44.48:8080/Espotify/info_audio_android',
  headers: <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  },
  body: jsonEncode(data),

  );
  if (response.statusCode == 200) {
  // If the server did return a 201 CREATED response,
  // then parse the JSON.
  return InfoCancion.fromJson(json.decode(response.body));
  } else {
  // If the server did not return a 201 CREATED response,
  // then throw an exception.
  throw Exception('Fallo al enviar petición');
  }
  }
  void borrarCapituloPodcast(String email,String nombrePodcast, Song song) async {

    await borrarCapPodcast(email,nombrePodcast, song.id.toString());
    initDataPodcasts();
  }

  void quitarCapituloPodcast(String email,String nombrePodcast, Song song) async {

    await borrarCancionesPlaylist(email,nombrePodcast, song.id.toString());
    initDataPodcasts();
  }


  Future<Canciones> editarCapPodcast(String email, String idCapitulo, String nombreViejo, String nuevoNombre, String genero,String generoViejo) async {
    log("pod: $nombreViejo $nuevoNombre $genero");
    Map data = {
      'email': email,
      'idCapitulo': idCapitulo,
      'nombrePodcastViejo': nombreViejo,
      'nombrePodcastNuevo': nuevoNombre,
      'generoPodcastViejo': generoViejo,
      'generoPodcastNuevo': genero,
    };
    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/modificar_capitulo_android',
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

  Future<Canciones> borrarCapPodcast(String email, String nombrePlaylist, String idAudio) async {
    Map data = {
      'email': email,
      'idAudio': idAudio,
    };
    log("debug: $email, $nombrePlaylist, $idAudio");
    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/cancion_eliminar_android',
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
          color: Colors.purpleAccent[400],
          border: Border.all(color: Colors.purpleAccent),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(10.0),
              bottomRight: Radius.elliptical(10, 4)),
        ),
        child: GestureDetector(
          onTap: () {
            username.esCancion = false;
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
  convertirALista() async{
    Respuesta r = await recibeGeneros();
    generos = r.generos.split('|');

  }
}

class Canciones {
  final String respuesta;
  final String nombresAudio;
  final String urlsAudio;
  final String autor;
  final String descripcion;
  final String imagen;
  final String listaIds;
  final String sonMios;
  Canciones({this.respuesta, this.nombresAudio,this.urlsAudio, this.autor, this.descripcion, this.imagen, this.listaIds, this.sonMios});

  factory Canciones.fromJson(Map<String, dynamic> json) {
    return Canciones(
      nombresAudio: json['nombresPodcast'],
      urlsAudio: json['urlsPodcast'],
      imagen: json['imagen'],
      descripcion: json['descripcion'],
      autor: json['autor'],
      listaIds: json['idsPodcast'],
      sonMios: json['sonMios'],

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

Future<Canciones> obtenerCapitulos(String nombrePodcast, String email) async {
  Map data = {
    'email': email,
    'podcast': nombrePodcast,
  };
  log("servlet: $nombrePodcast");
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/capitulos_podcast_android',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),

  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    Canciones c = Canciones.fromJson(json.decode(response.body));
    String s = c.getNombresAudio();
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

Future<Respuesta> recibeGeneros() async {
  Map data = {
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/generos_podcast_android',
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

Future<Canciones> borrarCancionesPlaylist(String email, String nombrePlaylist, String idAudio) async {
  Map data = {
    'email': email,
    'idAudio': idAudio,
    'nombrePlaylist': nombrePlaylist,
  };
  log("debug: $email, $nombrePlaylist, $idAudio");
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/eliminar_cancionlista_android',
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


class InfoCancion {
  final String respuesta;
  final String genero;
  final String autor;
  final String numLikes;
  final String tipo;
  InfoCancion({this.respuesta,this.genero, this.autor, this.numLikes, this.tipo});

  factory InfoCancion.fromJson(Map<String, dynamic> json) {
    return InfoCancion(
      genero: json['genero'],
      autor: json['autor'],
      numLikes: json['numLikes'],
      tipo: json['tipo'],
    );

  }
}