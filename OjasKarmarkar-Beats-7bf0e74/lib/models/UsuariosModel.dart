import 'dart:convert';
import 'dart:math';

import 'package:beats/models/const.dart';
import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:beats/models/ProgressModel.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'RecentsModel.dart';
import 'package:flutter/services.dart';
import 'package:beats/screens/PlayList.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class UsuariosModel extends ChangeNotifier {
  // Thousands of stuff packed into this ChangeNotifier
  List<String> usuarios = new List<String>();
  List<String> imagenes = new List<String>();
  List<String> descripciones = new List<String>();

  var duplicate = <String>[]; // Duplicate of songs variable for Search function
  bool playlist = false;
  var playlistSongs = <Song>[];
  var position;
  Random rnd = new Random();
  Recents recents;

  UsuariosModel(rec) {
    fetchUsers();
    recents = rec;
  }

  fetchUsers() async {
    ListaUsuariosDefault c = await obtenerListaUsuarios();
    List<String> listaNombres = c.getNombresUsuario().split('|');
    List<String> listaDescripciones = c.getDescripciones().split('|');

    for(int i = 0; i<listaNombres.length; i++){
      usuarios.add(listaNombres[i]);
      String yy = usuarios[i];
      debugPrint('data: $yy');
    }
    for(int j=0; j<listaDescripciones.length;j++){
      descripciones.add(listaDescripciones[j]);
      String yoy = descripciones[j];
      debugPrint('descripciones: $yoy');
    }

    if (usuarios.length == 0) usuarios = null;
    if (descripciones.length == 0) descripciones = null;
    initValues();
    usuarios?.forEach((item) {
      duplicate.add(item);
    });

    notifyListeners();
  }

  fetchUsersManual(List<String> usuarios, List<String> descripciones){
    String s = usuarios[0];
    String so = usuarios[1];
    debugPrint('manual: $s');
    debugPrint('manual: $so');
    this.usuarios = usuarios;
    this.descripciones = descripciones;
    s = usuarios[0];
    so = usuarios[1];
    debugPrint('manual: $s');
    debugPrint('manual: $so');
    if (usuarios.length == 0) usuarios = null;
    if (descripciones.length == 0) descripciones = null;
    initValues();
    s = usuarios[0];
    so = usuarios[1];
    debugPrint('manual: $s');
    debugPrint('manual: $so');
  }

  updateUI() {
    notifyListeners();
  }
  initValues() {
  }

  List<String> getUsers(){
    return usuarios;
  }
}

class ListaUsuariosDefault {
  final String nombresUsuario;
  final String descripciones;
  final String imagenes;

  ListaUsuariosDefault({this.nombresUsuario, this.descripciones, this.imagenes});

  factory ListaUsuariosDefault.fromJson(Map<String, dynamic> json) {
    return ListaUsuariosDefault(
      nombresUsuario: json['nombreUsuarios'],
      descripciones: json['descripciones'],
    );
  }
  String getNombresUsuario(){
    return nombresUsuario;
  }
  String getDescripciones(){
    return descripciones;
  }
}

Future<ListaUsuariosDefault> obtenerListaUsuarios() async {
  Map data = {
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/obtener_usuarios_android',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),

  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return ListaUsuariosDefault.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo al enviar petición');
  }
}
