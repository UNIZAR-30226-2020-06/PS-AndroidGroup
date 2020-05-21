import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';


class Comentario extends ChangeNotifier {
  List<String> texto;
  List<String> usuarios;

  init() async {
    texto = new List();
    usuarios = new List();
  }

  List<String> getTexto() {
    return (texto);
  }


  List<String> getUsuarios() {
    return (usuarios);
  }





  void obtenerListaComentarios(String tituloElemento) async {  //se utiliza con referencia a objetos cometario.obtenerListaComentarios lo llena
    Map data = {
      'titulo' : tituloElemento,
    };
    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/obtener_comentarios_android',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),

    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      ComentarioPrevio a = ComentarioPrevio.fromJson(json.decode(response.body));
      this.usuarios = a.usuarios.split("|");
      this.texto = a.texto.split("|");
      String stringer = a.usuarios;
      log("$stringer");
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Fallo al enviar petición');
    }
  }
  void escribirComentario(String texto, String usuario, String title) async {  //se utiliza con referencia a objetos cometario.obtenerListaComentarios lo llena
    log("Autor del comentario: $usuario");
    Map data = {
      'comentario' : texto,
      'usuario' : usuario,
      'titulo' : title,
    };
    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/anyadir_comentario_android',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),

    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      log("comentario Escrito");
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Fallo al enviar petición');
    }
  }
  void borrarComentario(String texto, String usuario, String title) async {
    Map data = {
      'comentario' : texto,
      'usuario' : usuario,
      'titulo' : title,
    };
    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/eliminar_comentario_android',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),

    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      log("Comentario borrado");
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Fallo al enviar petición');
    }
  }
}



class ComentarioPrevio {
  String texto;
  String usuarios;

  ComentarioPrevio({this.texto, this.usuarios});


  factory ComentarioPrevio.fromJson(Map<String, dynamic> json) {
    return ComentarioPrevio(
      texto: json['comentario'],
      usuarios: json['usuarios'],
    );
  }



}