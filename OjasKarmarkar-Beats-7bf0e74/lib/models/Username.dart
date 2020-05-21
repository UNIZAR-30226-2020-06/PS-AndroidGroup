import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Username with ChangeNotifier{

String name;
String email;
String canciones;
String cancionesUrl;
String urlDirecto;
SharedPreferences prefs;
String archivoPodcast;
List<String> listaGenerosPodcasts;
List<String> listaGenerosCanciones;
String archivoCancion;
String nombrePodcast;

Username(){
  this.name = "Bienvenido";
  init();
}
init() async{
  prefs = await SharedPreferences.getInstance();
 String temp =  prefs.getString("user") ?? "User";
  name = temp;
}

setName(String x){
  prefs.setString("user", x);
  name = x;
  notifyListeners();

}
getName(){
  return name;
}

setEmail(String x){
  prefs.setString("email", x);
  email = x;
  notifyListeners();
}

getEmail(){
  return email;
}
setCanciones(String x){
  prefs.setString("canciones", x);
  canciones = x;
}

getCanciones(){
  return canciones;
}
setCancionesUrl(String x){
  prefs.setString("cancionesUrl", x);
  cancionesUrl = x;
}

getCancionesUrl(){
  return cancionesUrl;
}

}
