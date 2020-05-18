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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    comentarios = Provider.of<Comentario>(context);
    b = Provider.of<BookmarkModel>(context);
    username = Provider.of<Username>(context);

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
                    color: Colors.purpleAccent,
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
                            "Comentarios",
                            style:
                            TextStyle(fontSize: 40.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ]),
                  )),
            ];
          },
          body: (comentarios.texto != null) ?
          Flexible(child: SizedBox(
            height: height * 0.16,
            child: Consumer<PlaylistRepo>(
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
                        playlistRepo.selected = null;
                        playlistRepo.selected = pos;
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => new PlaylistGenero()));
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
          ),) :
          Center(
            child: Text(
              "No hay comentarios",
              style: Theme.of(context).textTheme.display1,
            ),
          ),
      ),
    );
  }
}