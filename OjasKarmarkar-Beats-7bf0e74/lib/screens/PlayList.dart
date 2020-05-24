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

class PLayListScreen extends StatefulWidget {
  @override
  _PLayListScreenState createState() => _PLayListScreenState();
}

class _PLayListScreenState extends State<PLayListScreen> {
  PlaylistRepo playlistRepo;
  MisCancionesModel misCanciones;
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
    playlistRepo = Provider.of<PlaylistRepo>(context);
    misCanciones = Provider.of<MisCancionesModel>(context);
    model = Provider.of<SongsModel>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    int stringer = misCanciones.selected;
    int stringerr = playlistRepo.selected;
    obtieneGeneros();

    log("miscanciones: $stringer");
    log("playlistrepo: $stringerr");
    if(playlistRepo.selected != null)
    {
      name = playlistRepo.playlist[playlistRepo.selected];
      //playlistRepo.selected = null;
      initDataPlaylists();
    }
    if(misCanciones.selected != null) {
      name =
      misCanciones.playlist[misCanciones.selected];
      log("name: $name");
      //misCanciones.selected = null;
      initDataMisCanciones();
    }



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
                      (misCanciones.selected != null)?Align(alignment: Alignment.center,child:
                      Text(name,
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(color: Colors.white),
                      textScaleFactor: 1.5),
                      ):Align(alignment: Alignment.center,child:
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
                          condition: misCanciones.selected != null, //vista de misCanciones
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
                                        if (choice == Constants.ed) {   //editar canciones
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
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 25.0, right: 25.0, top: 2.0),
                                                          child: DropdownButton(
                                                            hint: Text('Elige un género',style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight: FontWeight.bold)), // Not necessary for Option 1
                                                            value: genero,
                                                            onChanged: (newValue) {
                                                              genero = newValue;
                                                            },
                                                            items: generos.map((location) {
                                                              return DropdownMenuItem(
                                                                child: new Text(location),
                                                                value: location,
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: ()  {
                                                            setState(() {
                                                              for(int i =0; i<misCanciones.playlist.length;i++){
                                                                String s = misCanciones.playlist[i];
                                                                log("playlist: $s" );
                                                              }

                                                                editarUnaCancionMia(username.email, model.songs[pos].title,txt.text, genero);  //editar en la BD


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
                                        }else if(choice == Constants.de){ //borrar canciones
                                          setState(() {
                                            mostrarComprobacion("Quitar de Mis Canciones", model.songs[pos]);

                                          });

                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return Constants.opciones.map((String choice) {
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
                          ),
                      ),

                      ConditionalBuilder(
                        condition: misCanciones.selected == null, //vista de una playlist de canciones
                        builder: (context) => ListView.builder(
                            itemCount: songs.length,
                            itemBuilder: (context, pos) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(top: 0.0, left: 10.0),
                                child: ListTile(
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        mostrarComprobacion("Eliminar canción", model.songs[pos]);
                                        model.player.stop();
                                        initDataPlaylists();
                                      });

                                    },
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
    var listaNombres = l.getNombresAudio().split('|');
    var listaUrls = l.getUrlsAudio().split('|');
    var listaIds = l.listaIds.split('|');
    log('initData2: $listaNombres');
    imagen = l.imagen;
    autor = l.autor;
    descripcion = l.descripcion;
    List<Song> listaCanciones = new List<Song>();
    for(int i = 0; i<listaNombres.length; i++){
      listaCanciones.add(new Song(int.parse(listaIds[i]),"", listaNombres[i], "",0,0,listaUrls[i],null));
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
        listaCanciones.add(new Song(listaIds[i],"", listaNombres[i], "",0,0,listaUrls[i],null));
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

  void editarUnaCancionMia(String email, String title, String newTitle, String genero) async {
    await editarCanciones(email, title, newTitle, genero);
    await actualizarUsername(username.email);
    initDataMisCanciones();
  }

  void borrarCancionDeMisCanciones(String email, Song song) async {

    await borrarCanciones(email, "misCanciones", song.title);
    await actualizarUsername(username.email);
    initDataMisCanciones();   //reiniciamos

  }

  void borrarCancionDePlaylist(String email, String namePlaylist, Song song) async {
    log("hecho $song");
    String s=song.title;
    log("data $email, $namePlaylist, $s");
    await borrarCancionesPlaylist(email, namePlaylist, song.title);
    log("hecho2");
    initDataPlaylists();
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

  void mostrarComprobacion(String accion, Song nombreCancion){
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
                      child: Text(accion)
                  ),
                  InkWell(
                    onTap: () {
                      if(accion == "Eliminar canción") {
                        borrarCancionDePlaylist(username.email, name, nombreCancion);
                        Navigator.pop(context);
                      }else if(accion == "Quitar de Mis Canciones"){
                        borrarCancionDeMisCanciones(username.email, nombreCancion);
                        Navigator.pop(context);
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



Future<Canciones> editarCanciones(String email, String nombreCancion, String nuevoNombre, String genero) async {
  Map data = {
    'email': email,
    'nombreCancionViejo': nombreCancion,
    'nombreCancionNuevo': nuevoNombre,
    'generoCancionNuevo': genero,
  };
  log("editarCanciones: $nombreCancion, $nuevoNombre, $email, $genero" );
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/cancion_modificar_android',
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

Future<Canciones> borrarCanciones(String email, String nombrePlaylist, String nombreCancion) async {
  Map data = {
    'email': email,
    'nombreCancion': nombreCancion,
  };
  log("debug: $email, $nombrePlaylist, $nombreCancion");
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

Future<Canciones> borrarCancionesPlaylist(String email, String nombrePlaylist, String nombreCancion) async {
  Map data = {
    'email': email,
    'nombreCancion': nombreCancion,
    'nombrePlaylist': nombrePlaylist,
  };
  log("debug: $email, $nombrePlaylist, $nombreCancion");
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