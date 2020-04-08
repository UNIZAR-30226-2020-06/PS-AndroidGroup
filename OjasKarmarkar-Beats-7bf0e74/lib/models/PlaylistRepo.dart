import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PlaylistRepo extends ChangeNotifier {

  List<String> playlist = [];
  SharedPreferences prefList;
  int selected;

  PlaylistRepo() {
    init();
    if(!playlist.contains("Favoritos")){
      playlist.add("Favoritos");
    }
  }

  init() async {
    prefList = await SharedPreferences.getInstance();
    List<String> list = prefList.getStringList("playlist");
    updatePlayList(list);
  }

  push()async {
    prefList.setStringList("playlist", playlist);
  }

  getList() {
    return playlist;
  }

  delete(String name)async{
    playlist.remove(name);
    notifyListeners();
    await prefList.setStringList("playlist", playlist);
    notifyListeners();
  }

  updatePlayList(List<String> list) {
    if (list != null) {
      playlist.addAll(list);
    }
    notifyListeners();
  }

  add(String name) async {
    playlist.add(name);
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
