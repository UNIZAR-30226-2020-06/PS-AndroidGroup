import 'dart:convert';
import 'dart:developer';

import 'package:beats/Animations/transitions.dart';
import 'package:beats/models/ThemeModel.dart';
import 'package:beats/models/BookmarkModel.dart';
import 'package:beats/models/Username.dart';
import 'package:beats/models/UsuariosModel.dart';
import 'package:beats/screens/UserProfile.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'Player.dart';
import 'package:http/http.dart' as http;

import 'ProfileEdit.dart';

double height, width;

class Social extends StatefulWidget {
  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {
  TextEditingController editingController;

  UsuariosModel model;

  BookmarkModel b;

  ThemeChanger themeChanger;

  TextEditingController txt = TextEditingController();

  bool error = false;
  List<String> usuarios;
  List<String> descripciones;
  Username username;
  @override
  void didChangeDependencies() {
    model = Provider.of<UsuariosModel>(context);
    b = Provider.of<BookmarkModel>(context);
    username = Provider.of<Username>(context);
    obtenerUsuarios(model);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    themeChanger = Provider.of<ThemeChanger>(context);

    for(int i=0; i<model.getUsers().length;i++){
      String s = model.getUsers().elementAt(i);
      log('usuario: $s');
    }

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).backgroundColor,
          body: (model.usuarios == null)
              ? Center(
            child: Text(
              "No hay usuarios",
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
                                    "Social",
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
                ],
              ))),
      onWillPop: () {},
    );
  }

  obtenerUsuarios(UsuariosModel model) async {

    ListaUsuariosDefault c = await obtenerListaUsuarios();
    List<String> listaNombres = c.getNombresUsuario().split('|');
    List<String> listaDescripciones = c.getDescripciones().split('|');
    setState(() {
      usuarios = new List<String>();
      for(int i = 0; i<listaNombres.length; i++){
        usuarios.add(listaNombres[i]);
      }
      for(String s in listaNombres){
        log('initData2: $s');
      }
      descripciones = new List<String>();
      for(int i = 0; i<listaDescripciones.length; i++){
        descripciones.add(listaDescripciones[i]);
      }
      model.fetchUsersManual(usuarios, descripciones);
    });

  }

  getLoading(UsuariosModel model) {
    if (model.usuarios.length == 0) {
      return Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ));
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: model.usuarios.length,
          itemBuilder: (context, pos) {
            return Consumer<UsuariosModel>(builder: (context, repo, _) {
              return ListTile(
                onTap: () async {

                },
                leading: CircleAvatar(child: getImage(model, pos)),
                title: Text(
                  model.usuarios[pos],
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Sans'),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    model.descripciones[pos],
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
    /*if (model.imagenes[pos] != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child:
          Image.file(File.fromUri(Uri.parse(model.usuarios[pos].albumArt))));
    } else {*/
      return Container(
          child: IconButton(
            onPressed: null,
            icon: Icon(
              Icons.person_pin,
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
    //}
  }

  push(context) {
    Navigator.push(context, SlideRightRoute(page: UserProfile()));
  }

}

class Search extends SearchDelegate<String> {
  UsuariosModel model;
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
    model = Provider.of<UsuariosModel>(context);
    List<String> dummy = <String>[];
    List<String> recents = <String>[];
    for (int i = 0; i < model.usuarios.length; i++) {
      dummy.add(model.usuarios[i]);
      recents.add(model.descripciones[i]);
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
            leading: CircleAvatar(backgroundColor: Colors.orange,child: Icon(Icons.person_pin, color: Colors.white,)),
          ),
        );
      },
    );
  }

}
