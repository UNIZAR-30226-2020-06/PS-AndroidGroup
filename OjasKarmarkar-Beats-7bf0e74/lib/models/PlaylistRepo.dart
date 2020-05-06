import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PlaylistRepo extends ChangeNotifier {

  List<String> playlist = [];
  List<String> descripciones = [];
  List<String> imagenes = [];
  SharedPreferences prefList;
  int selected;

  PlaylistRepo() {
    init();
  }


  init() async {


  }

  push()async {
    prefList.setStringList("playlist", playlist);
  }

  getList() {
    return playlist;
  }

  getDescripciones(){
    return descripciones;
  }

  delete(String name)async{
    for(int i=0; i<playlist.length; i++){
      if(playlist[i] == name){
        descripciones.removeAt(i);
        playlist.remove(name);
      }
    }
    notifyListeners();
    await prefList.setStringList("playlist", playlist);
    notifyListeners();
  }

  updatePlayList(List<String> list, List<String> descriptions) {
    if (list != null) {
      playlist.addAll(list);
      descripciones.addAll(descriptions);
    }
    notifyListeners();
  }

  generateInitialPlayList(List<String> list, List<String> descriptions) async{
    playlist = list;
    descripciones = descriptions;
  }

  add(String name, String description) async {
    playlist.add(name);
    descripciones.add(description);
    await prefList.setStringList("playlist", playlist);
    notifyListeners();
  }

  contains(String name) async {
    for(String e in playlist){
      if(e ==name){
        return true;
      }
    }
    return false;
  }
}

