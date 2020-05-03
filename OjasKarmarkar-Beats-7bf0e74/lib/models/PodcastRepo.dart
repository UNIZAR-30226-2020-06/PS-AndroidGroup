import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class PodcastRepo extends ChangeNotifier {

  List<String> podcast = [];
  String podcastJSON;
  List<String> descripciones = [];
  String descripcionesJSON;
  List<String> imagenes = [];
  SharedPreferences prefList;
  int selected;

  PodcastRepo({this.podcastJSON,this.descripcionesJSON}) {
    init();
  }


  init() async {
    podcast.clear();
    prefList = await SharedPreferences.getInstance();
    List<String> list = prefList.getStringList("podcast");
    updatePlayList(list, descripciones);

  }

  push()async {
    prefList.setStringList("podcast", podcast);
  }

  getList() {
    return podcast;
  }

  getDescripciones(){
    return descripciones;
  }

  getDescripcionesJSON(){
    return descripcionesJSON;
  }
  getPodcastJSON(){
    return podcastJSON;
  }

  delete(String name)async{
    for(int i=0; i<podcast.length; i++){
      if(podcast[i] == name){
        descripciones.removeAt(i);
        podcast.remove(name);
      }
    }
    notifyListeners();
    await prefList.setStringList("podcast", podcast);
    notifyListeners();
  }

  updatePlayList(List<String> list, List<String> descriptions) {
    if (list != null) {
      podcast.addAll(list);
      descripciones.addAll(descriptions);
    }
    notifyListeners();
  }

  generateInitialPlayList(List<String> list, List<String> descriptions) async{
    podcast = list;
    descripciones = descriptions;
  }

  add(String name, String description) async {
    podcast.add(name);
    descripciones.add(description);
    await prefList.setStringList("podcast", podcast);
    notifyListeners();
  }

  contains(String name) async {
    for(String e in podcast){
      if(e ==name){
        return true;
      }
    }
    return false;
  }

  static PodcastRepo fromJson(Map<String, dynamic> json) {
    return PodcastRepo(
      podcastJSON: json['podcast'],
      descripcionesJSON: json['descripciones'],
    );
  }
  Future<PodcastRepo> obtenerPodcasts() async {
    Map data = {
    };
    final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/obtener_randomaudios_android',  //TODO CAMBIAR URL A LA DE LOS PODCASTS
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),

    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      PodcastRepo fromJtoPR = PodcastRepo.fromJson(json.decode(response.body));
      fromJtoPR.podcast = fromJtoPR.getPodcastJSON().split('|');
      fromJtoPR.descripciones = fromJtoPR.getDescripcionesJSON().split('|');
      return(fromJtoPR);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Fallo al enviar petición');
    }
  }
}

