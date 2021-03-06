import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MisCancionesModel extends ChangeNotifier {

  List<String> playlist = [""];
  SharedPreferences prefList;
  int selected;

  MisCancionesModel() {
    init();
  }


  init() async {
  }

  push()async {
    prefList.setStringList("misCanciones", playlist);
  }

  getList() {
    return playlist;
  }

  delete(String name)async{
    playlist.remove(name);
    notifyListeners();
    await prefList.setStringList("misCanciones", playlist);
    notifyListeners();
  }

  updatePlayList(List<String> list) {
    if (list != null) {
      playlist.addAll(list);
    }
    notifyListeners();
  }

  generateInitialPlayList(List<String> list) async{
    playlist = list;
  }

  add(String name) async {
    playlist.add(name);
    await prefList.setStringList("misCanciones", playlist);
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

