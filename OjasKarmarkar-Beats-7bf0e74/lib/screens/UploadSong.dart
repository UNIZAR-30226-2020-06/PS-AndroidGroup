import 'package:beats/Animations/transitions.dart';
import 'package:beats/models/PlayListHelper.dart';
import 'package:beats/models/PlaylistRepo.dart';
import 'package:beats/models/ThemeModel.dart';
import 'package:beats/models/BookmarkModel.dart';
import 'package:beats/models/const.dart';
import 'package:beats/screens/UploadSongData.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:beats/models/SongsModel.dart';
import '../custom_icons.dart';
import 'package:provider/provider.dart';
import 'Player.dart';

double height, width;

class UploadSong extends StatefulWidget {
  @override
  _UploadSongState createState() => _UploadSongState();
}

class _UploadSongState extends State<UploadSong> {
  TextEditingController editingController;

  SongsModel model;

  BookmarkModel b;

  ThemeChanger themeChanger;

  TextEditingController txt = TextEditingController();

  bool error = false;

  @override
  Widget build(BuildContext context) {
    model = Provider.of<SongsModel>(context);
    b = Provider.of<BookmarkModel>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    themeChanger = Provider.of<ThemeChanger>(context);
    return WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).backgroundColor,
          body: (model.songs == null)
              ? Center(
            child: Text(
              "No tienes canciones en el móvil",
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
                                    "Sube una canción",
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
                  )
                ],
              ))),
      onWillPop: () {},
    );
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
                    print("debug " + choice);
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
                                        "Subir canción",
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
                                    child: Text("No Playlist"),
                                  ),
                                )
                              ],
                            );
                          });
                    } // else if (choice == Constants.bm) {
                    // if (!b.alreadyExists(model.songs[pos])) {
                    //   b.add(model.songs[pos]);
                    // } else {
                    //    b.remove(model.songs[pos]);
                    // }
                    //} else if (choice == Constants.de) {

                    //   model.fetchSongs();
                    // }else if(choice == Constants.re){
                    //   Directory x = await getExternalStorageDirectory();
                    //   await File("${x.path}../../").rename(x.path);
                    //}
                  },
                  itemBuilder: (BuildContext context) {
                    return Constants.customizedChoices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: GestureDetector(
                            onTap: () { Navigator.push(context, new MaterialPageRoute(
                                builder: (context) =>
                                new UploadSongData())); },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  Text(choice,
                                style: Theme.of(context).textTheme.display2,),
                            ),
                        ),
                      );
                    }).toList();
                  },
                ),
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
    Navigator.push(context, SlideRightRoute(page: PlayBackPage()));
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
          color: Colors.orange,
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
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) =>
                  new UploadSongData()));
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
            leading: CircleAvatar(child: Icon(Icons.music_note)),
          ),
        );
      },
    );
  }
}