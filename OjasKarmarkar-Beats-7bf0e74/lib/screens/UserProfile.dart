import 'dart:io';

import 'package:beats/Animations/AnimatedButton.dart';
import 'package:beats/icono_personalizado.dart';
import 'package:beats/models/PlayListHelper.dart';
import 'package:beats/models/PlaylistRepo.dart';
import 'package:beats/models/SongsModel.dart';
import 'package:beats/models/const.dart';
import 'package:beats/screens/PlayList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'MusicLibrary.dart';

import 'login.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  TextEditingController txt = TextEditingController();
  bool error = false;

  SongsModel model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<SongsModel>(context);
    return new Scaffold(
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AppBar(
                    actions: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.003, left: width * 0.85),

                      ),
                    ],
                    backgroundColor: Colors.white,
                  ),
                  new Container(
                    height: 180.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: new ExactAssetImage(
                                            'assets/prof.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    height: 50.0,
                    color: Colors.white,
                    child: AnimatedButton(
                      onTap: () {
                        print("seguido");
                      },
                      animationDuration: const Duration(milliseconds: 2000),
                      initialText: "Seguir",
                      finalText: "Seguido",
                      iconData: Icons.check,
                      iconSize: 32.0,
                      buttonStyle: ButtonStyle(
                        primaryColor: Colors.orange,
                        secondaryColor: Colors.white,
                        elevation: 20.0,
                        initialTextStyle: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                        ),
                        finalTextStyle: TextStyle(
                          fontSize: 22.0,
                          color: Colors.orangeAccent,
                        ),
                        borderRadius: 10.0,
                      ),
                    ),
                  ),
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Nombre de usuario',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Eduarda la crack',
                                        style: TextStyle(
                                            fontSize: 16.0,),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Descripción personal',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Soy una bad b****',
                                        style: TextStyle(
                                            fontSize: 16.0,),
                                      ),
                                    ],
                                  ),
                                ],
                              )),


                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Seguidores',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        '930.000',
                                        style: TextStyle(
                                          fontSize: 16.0,),
                                      ),
                                    ],
                                  ),
                                ],
                              )),

                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Playlists',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),

                          !_status ? _getActionButtons() : new Container(),
                          Padding(
                              padding: EdgeInsets.only(top: height * 0.04),
                              child: SizedBox(
                                height: height * 0.23,
                                child: Consumer<PlaylistRepo>(
                                  builder: (context, playlistRepo, _) => ListView.builder(

                                    itemCount: playlistRepo.playlist.length + 1,
                                    itemBuilder: (context, pos) {
                                      var padd = (pos == 0) ? width * 0.08 : 5.0;
                                      if (pos == (playlistRepo.playlist.length)) {
                                        return GestureDetector(
                                          onTap: () {
                                          },
                                          child: Card(
                                            margin: EdgeInsets.only(left: padd, right: 5.0),
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(color: Colors.orangeAccent),
                                                borderRadius: BorderRadius.circular(20)),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Container(
                                                    width: width * 0.4,
                                                    )),
                                          ),
                                        );
                                      } else {
                                        return Card(
                                          margin: EdgeInsets.only(left: padd, right: 5.0),
                                          elevation: 20,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          child: GestureDetector(
                                            onTap: () {
                                              playlistRepo.selected = pos;
                                              Navigator.of(context).push(new MaterialPageRoute(
                                                  builder: (context) => new PLayListScreen()));
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
                                                    Align(
                                                      alignment: Alignment.topRight,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(
                                                            right: 10.0, top: 8.0),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons.add_circle,
                                                            size: 19,
                                                            color: Colors.white,
                                                          ),
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return AlertDialog(
                                                                  // Retrieve the text the that user has entered by using the
                                                                  // TextEditingController.
                                                                  content: Text("Añadir a mis playlists"),

                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                        child: Text(playlistRepo.playlist[pos],
                                                            style:
                                                            TextStyle(color: Colors.white)))
                                                  ]),
                                                )),
                                          ),
                                        );
                                      }
                                    },
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              )),

                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Canciones',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),


                          Padding(
                              padding: EdgeInsets.only(top: height * 0.03),
                              child: SizedBox(
                                height: height * 0.09,
                                child: Consumer<PlaylistRepo>(
                                  builder: (context, playlistRepo, _) => ListView.builder(

                                    itemCount: playlistRepo.playlist.length + 1,
                                    itemBuilder: (context, pos) {
                                      var padd = (pos == 0) ? width * 0.08 : 5.0;
                                      return Card(
                                        margin: EdgeInsets.only(left: padd, right: 5.0),
                                        elevation: 20,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(500)),
                                        child: GestureDetector(
                                          onTap: () {
                                          },
                                          child: getImage(model, pos),
                                        ),
                                      );

                                    },
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              )),

                        ],
                      ),
                    ),

                  )

                ],
              ),
            ],
          ),

        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Guardar"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Cancelar"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }


  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AlertDialog(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              backgroundColor: Theme.of(context).backgroundColor,
              actions: <Widget>[
                Padding(padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () { Navigator.push(context, new MaterialPageRoute(
                        builder: (context) =>
                        new LoginPage())); },

                    child: new RaisedButton(
                      child: new Text("Cerrar sesión"),
                      textColor: Colors.black,
                      color: Colors.white,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                    ),
                  ),),

                Padding(padding: EdgeInsets.only(right: 9),
                  child: new RaisedButton(
                    child: new Text("Eliminar cuenta"),
                    textColor: Colors.red,
                    color: Colors.white,
                    onPressed: () {
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  ),),

                Padding(padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () { Navigator.of(context).pop(); },

                    child: new RaisedButton(
                      child: new Text("Cancelar"),
                      textColor: Colors.black,
                      color: Colors.white,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                    ),
                  ),),

              ],
            ),
          );
        });
  }
  void validate(context, repo) {
    setState(() {
      txt.text.toString().isEmpty ? error = true : error = false;
    });
    if (txt.text.toString().isNotEmpty) {
      repo.add(txt.text);
      txt.clear();
      Navigator.of(context).pop();
    }
  }


  getLoading(SongsModel model) {
    if (model.songs.length == 0) {
      return Flexible(
          child: Center(
            child: CircularProgressIndicator(),
          ));
    } else {
      return Flexible(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: model.songs.length,
          itemBuilder: (context, pos) {
            return Consumer<PlaylistRepo>(builder: (context, repo, _) {
              return ListTile(
                onTap: () async {
                  model.player.stop();
                  model.playlist = false;
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

}
