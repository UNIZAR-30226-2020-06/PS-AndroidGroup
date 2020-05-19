import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class PodcastRepo extends ChangeNotifier {

  List<String> podcast = [""];
  String podcastJSON;
  List<String> descripciones;
  String descripcionesJSON;
  List<String> imagenes;
  SharedPreferences prefList;
  int selected;

  PodcastRepo() {
    init();
  }

  init() async {
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

  updatePodcast(List<String> list, List<String> descriptions) {
    if (list != null) {
      podcast.addAll(list);
      descripciones.addAll(descriptions);
    }
    notifyListeners();
  }

  generateInitialPodcastImage(List<String> list, List<String> descriptions, List<String> images) async{
    podcast = list;
    descripciones = descriptions;
    imagenes = images;
  }
  generateInitialPodcast(List<String> list, List<String> descriptions) async{
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

}

