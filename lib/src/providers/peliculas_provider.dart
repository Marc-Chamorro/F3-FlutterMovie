import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:film_flutter/src/models/actores_model.dart';
import 'package:film_flutter/src/models/pelicula_model.dart';
import 'package:film_flutter/src/models/actoresinfo_model.dart';

class PeliculasProvider {
  String _apikey = '3b8f6da8b230d86607a8696eaf50a230';
  String _url = 'api.themoviedb.org';
  String _language = 'en-EN';

  int _popularesPage = 0;
  int _popularesActorPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = [];
  List<Actor> _popularesActores = [];
  //List<ActorInfo> _infoActores = [];

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;
  void disposeStreams() {
    _popularesStreamController?.close();
  }

  final _popularesActoresStreamController = StreamController<List<Actor>>.broadcast();
  Function(List<Actor>) get popularesActoresSink => _popularesActoresStreamController.sink.add;
  Stream<List<Actor>> get popularesActoresStream => _popularesActoresStreamController.stream;
  void disposeActoresStreams() {
    _popularesActoresStreamController?.close();
  }

  // final _getpeliculasactor = StreamController<List<Pelicula>>.broadcast();
  // Function(List<Pelicula>) get peliculasactorsink => _getpeliculasactor.sink.add;
  // Stream<List<Pelicula>> get peliculasactorstream => _getpeliculasactor.stream;
  // void disposepeliculasactores() {
  //   _getpeliculasactor?.close();
  // }

  // final _infoActoresPlusStreamController = StreamController<List<ActorInfo>>.broadcast();
  // Function(List<ActorInfo>) get infoActoresPlusSink => _infoActoresPlusStreamController.sink.add;
  // Stream<List<ActorInfo>> get infoActoresPlusStream => _infoActoresPlusStreamController.stream;
  // void infoActoresPlusStreams() {
  //   _infoActoresPlusStreamController?.close();
  // }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> _procesarRespuestapelisactores(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['cast']);

    return peliculas.items;
  }

  Future<List<Actor>> _procesarRespuestaActores(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);   //aqui si que ho agafa la biografia

    final cast = new Cast.fromJsonList(decodedData['results']);

    return cast.actores;
  }

    Future<List<ActorInfo>> _procesarRespuestaActoresInfoPlus(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final castplus = new CastPlus.fromJsonList(decodedData['results']);

    return castplus.actoresinfo;
  }




  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {'api_key': _apikey, 'language': _language}); // Pelicula
    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {'api_key': _apikey, 'language': _language, 'page': _popularesPage.toString()});  // Pelicula
    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getPopularesActores() async {
    if (_cargando) return [];

    _cargando = true;
    _popularesActorPage++;

    final url = Uri.https(_url, '3/person/popular', {'api_key': _apikey, 'language': _language, 'page': _popularesActorPage.toString()});  // Pelicula
    final resp = await _procesarRespuestaActores(url);

    _popularesActores.addAll(resp);

    //loop
    for (Actor actor in resp) {
      actor.biography = await buscarActorBiografia(actor.id.toString());
    }

    popularesActoresSink(_popularesActores);

    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits', {'api_key': _apikey, 'language': _language});  // pelicula
    
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    for (Actor actor in cast.actores) { //hi havia decodedData
      actor.biography = await buscarActorBiografia(actor.id.toString());
    }

    return cast.actores;
  }

  Future<List<Pelicula>> getActoresPeliculas(String personid) async {
    // final url = Uri.https(_url, '3/person/$personid/movie_credits', {'api_key': _apikey, 'language': _language});  // pelicula
    
    // final resp = await http.get(url);
    // final decodedData = json.decode(resp.body);

    // final peli = new Peliculas.fromJsonList(decodedData['cast']);

    // return peli.items;

    if (_cargando) return [];

    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_url, '3/person/$personid/movie_credits', {'api_key': _apikey, 'language': _language});  // Pelicula
    final resp = await _procesarRespuestapelisactores(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future<List<Pelicula>> buscarPeliculasActor(String search) async {
    final url = Uri.https(_url, '3/person/$search/movie_credits', {'api_key': _apikey, 'language': _language});  // Pelicules fetes per X actor
    
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['cast']);

    return peliculas.items;
    //return await _procesarRespuestaActores(url);
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie', {'api_key': _apikey, 'language': _language, 'query': query});  // Pelicula
    
    return await _procesarRespuesta(url);
  }

  Future<List<ActorInfo>> buscarActorInfoPlus(String query) async {
    final url = Uri.https(_url, '3/person/$query', {'api_key': _apikey, 'language': _language});  // Pelicula
    
    return await _procesarRespuestaActoresInfoPlus(url);
    //https://api.themoviedb.org/3/person/10859?api_key=3b8f6da8b230d86607a8696eaf50a230&language=en-US
  }

  //Future<List<Actor>>
  Future<String> 
  buscarActorBiografia(String query) async {
    final url = Uri.https(_url, '3/person/$query', {'api_key': _apikey, 'language': _language});  // Pelicula
    
    //return _procesarRespuestaActoresTest(url);

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);   //aqui si que ho agafa la biografia
    String bio = decodedData["biography"].toString();

    return bio;

    //https://api.themoviedb.org/3/person/10859?api_key=3b8f6da8b230d86607a8696eaf50a230&language=en-US
  }

  //Future<List<Actor>> 
  Future<String>
  _procesarRespuestaActoresTest(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);   //aqui si que ho agafa la biografia

    //final cast = new Cast.fromJsonList(decodedData[0]);

    //var x = json.decode(decodedData);

    //var cast = Actor.fromJsonMap(x);

    //var request = await http.get(url);
    //var response = await request.close();
    //final cast = decodedData.transform(utf8.decoder).join();
    // List data = json.decode(responseBody);
    String bio = decodedData["biography"].toString();
    // sha aconseguit treure les dades com a json, pero ara que faig amb aquestes?, com les torno en forma de string/afegir a la llista

    return bio;
  }
}
