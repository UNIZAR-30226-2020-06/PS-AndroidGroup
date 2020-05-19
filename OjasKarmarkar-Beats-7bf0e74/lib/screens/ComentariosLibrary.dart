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
import 'package:beats/models/Comentario.dart';
import '../custom_icons.dart';
import 'package:provider/provider.dart';
import 'PlayList.dart';
import 'Player.dart';
import 'package:http/http.dart' as http;

import 'PlaylistGenero.dart';
import 'ProfileEdit.dart';


class ComentariosLibraryState extends StatefulWidget {
  @override
  ComentariosLibrary createState() => ComentariosLibrary();
}

class ComentariosLibrary extends State<ComentariosLibraryState> {

  double width, height;
  TextEditingController comentarioController;

  Comentario comentarios = new Comentario();

  BookmarkModel b;

  ThemeChanger themeChanger;

  TextEditingController txt = TextEditingController();

  bool error = false;
  List<Song> songs;
  Username username;
  List<String> generos = [""];
  SongsModel songsModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    b = Provider.of<BookmarkModel>(context);
    username = Provider.of<Username>(context);
    songsModel = Provider.of<SongsModel>(context);
    actualizarComentarios();


    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;
    themeChanger = Provider.of<ThemeChanger>(context);
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
                    color: Colors.white,
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
                                color: Colors.black,
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
                            "Comentarios",
                            style:
                            TextStyle(fontSize: 40.0, color: Colors.black),
                          ),
                        ),
                      ),
                    ]),
                  )),
            ];
          },
          body: (comentarios.texto != null) ?
          Column(children: <Widget> [Expanded (child: buildCommentList()),
          TextField(
            onSubmitted: (String comment) async{
              await comentarios.escribirComentario(comment, username.email, songsModel.currentSong.title);
              setState(() {              });
            },
            decoration: InputDecoration(
              hintText:"Escribe aquí tu comentario"
            ),
          )

          ]):
          Column(children: <Widget> [Expanded (child: Center(
            child: Text(
              "No hay comentarios",
              style: Theme.of(context).textTheme.display1,
            ),
          ),),
            TextField(
              onSubmitted: (String comment) async {
                await comentarios.escribirComentario(comment, username.email, songsModel.currentSong.title);
                actualizarComentarios();
              },
              decoration: InputDecoration(
                  hintText:"Escribe aquí tu comentario"
              ),
            )

          ])


      ),
    );
  }

  buildCommentList() {
   return ListView.builder(
        itemCount: comentarios.texto.length,
        itemBuilder: (context, pos) {
          return Padding(
            padding:
            const EdgeInsets.only(top: 0.0, left: 10.0),
            child: comentarios.usuarios[pos] == "Kifixooo" ? ListTile( //todo Kifixoo debe ser == User.name
              trailing: IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.black54,
                ),
                onPressed: () async {
                  await comentarios.borrarComentario(comentarios.texto[pos], comentarios.usuarios[pos], songsModel.currentSong.title);
                  actualizarComentarios();
                },
              ),
              title: Text(
                comentarios.usuarios[pos],
                maxLines: 1,
                style: Theme.of(context).textTheme.display3,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  comentarios.texto[pos],
                  maxLines: 1,
                  style: Theme.of(context).textTheme.display2,
                ),
              ),
            ):
            ListTile(
              title: Text(
                comentarios.usuarios[pos],
                maxLines: 1,
                style: Theme.of(context).textTheme.display3,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  comentarios.texto[pos],
                  maxLines: 1,
                  style: Theme.of(context).textTheme.display2,
                ),
              ),
            ),
          );
        }
    );


  }

  void actualizarComentarios() async{

    await comentarios.obtenerListaComentarios(songsModel.currentSong.title);
    List<String> ss = comentarios.getUsuarios();
    log("comentarios actualizados: $ss");
    setState(() {

    });
  }
}