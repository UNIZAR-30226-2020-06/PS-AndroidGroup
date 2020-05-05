import 'dart:convert';
import 'dart:developer';

import 'package:beats/Animations/transitions.dart';
import 'package:beats/models/PodcastRepo.dart';
import 'package:beats/models/ThemeModel.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:beats/models/CapPodcastsModel.dart';
import '../custom_icons.dart';
import 'package:provider/provider.dart';
import 'Player.dart';
import 'package:http/http.dart' as http;

import 'Podcasts.dart';

double height, width;

class PodcastLibrary extends StatefulWidget {
  @override
  _PodcastLibraryState createState() => _PodcastLibraryState();
}
// ignore: must_be_immutable
class _PodcastLibraryState extends State<PodcastLibrary> {
  TextEditingController editingController;

  ThemeChanger themeChanger;

  TextEditingController txt = TextEditingController();

  bool error = false;

  List<String> podcasts;
  PodcastRepo podcastRepo;

  @override
  void initState() {
    super.initState();

  }
  @override
  void didChangeDependencies() {
    height = MediaQuery.of(context).size.height;
    podcastRepo = Provider.of<PodcastRepo>(context);


    anyadePodcasts(podcastRepo);


    width = MediaQuery.of(context).size.width;
    themeChanger = Provider.of<ThemeChanger>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).backgroundColor,
          body: (podcastRepo.podcast == null)
              ? Center(
            child: Text(
              "No hay podcasts",
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
                                    "Podcasts",
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
              body: getLoading(podcastRepo))),
      onWillPop: () {},
    );
  }

  getLoading(PodcastRepo model) {
    if (model.podcast.length == 0) {
      return Flexible(
          child: Center(
            child: Text("No hay podcasts..."),
          ));
    } else {
      return Padding(
          padding: EdgeInsets.only(top: height * 0.04),
          child: SizedBox(
            height: height * 0.6,
            child: Consumer<PodcastRepo>(
              builder: (context, pos, _) => ListView.builder(
                itemCount: podcastRepo.podcast.length,
                itemBuilder: (context, pos) {
                    return Card(
                      margin: EdgeInsets.only(left: 0.4, right: 5.0),
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: GestureDetector(
                        onTap: () {
                          podcastRepo.selected = pos;
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new PodcastScreen()));
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: width * 0.4,
                              height: height *0.1,
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
                                    Colors.purpleAccent,
                                    Colors.purple,
                                    Colors.purple,
                                    Colors.purpleAccent,
                                  ]
                                      : [
                                    Colors.lightBlueAccent,
                                    Colors.indigoAccent,
                                    Colors.indigoAccent,
                                    Colors.lightBlueAccent,
                                  ],
                                ),
                              ),
                              child: Stack(children: <Widget>[

                                Center(
                                    child: Text(podcastRepo.podcast[pos],
                                        style:
                                        TextStyle(color: Colors.white)))
                              ]),
                            )),
                      ),
                    );

                },
                scrollDirection: Axis.vertical,
              ),
            ),
          ));
    }
  }

  push(context) {
    Navigator.push(context, SlideRightRoute(page: PlayBackPage()));
  }

  void anyadePodcasts(PodcastRepo podcastRepo) async{
    Podcasts p = await obtenerPodcasts();

    List<String> listaNombres = p.nombres.split('|');
    List<String> listaDescripciones = p.descripciones.split('|');
    log('podcasts: $listaNombres');

    setState(() {
       podcastRepo.generateInitialPodcast(listaNombres, listaDescripciones);
    });
  }


  Future<Podcasts> obtenerPodcasts() async {
    Map data = {
    };
    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/podcasts_android',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),

    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Podcasts.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Fallo al enviar petición');
    }
  }


}

class Search extends SearchDelegate<Song> {
  PodcastRepo model;
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
    model = Provider.of<PodcastRepo>(context);
    List<String> dummy = <String>[];
    List<String> recents = <String>[];
    for (int i = 0; i < model.podcast.length; i++) {
      dummy.add(model.podcast[i]);
    }
    //for (int i = 0; i < 4; i++) {
    // recents.add(model.podcasts[i].title);
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
              model.selected = index;
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new PodcastScreen()));
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
            leading: CircleAvatar(backgroundColor: Colors.purple,child: Icon(Icons.mic, color: Colors.white,)),
          ),
        );
      },
    );
  }
}
class Podcasts {
  final String nombres;
  final String descripciones;

  Podcasts({this.nombres, this.descripciones});

  factory Podcasts.fromJson(Map<String, dynamic> json) {
    return Podcasts(
      nombres: json['lista'],
      descripciones: json['listaDescripcion'],
    );

  }
  String getUserId(){
    return nombres;
  }
}


