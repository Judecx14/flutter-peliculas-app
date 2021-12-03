import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';

//Para pode hacer uso de esta classe como provier es necesario extender ChangeNotifier
class MoviesProvider extends ChangeNotifier {
  //No es necesario colcar https:// porque Uri.htpps lo coloca
  final String _baseURL = 'api.themoviedb.org';
  final String _apiKey = 'a6cc9fee602ebdb7bd1dab07246ed656';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};
  int _popularPage = 0;

  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  //Este es el controlador del stream, con el cual podremos controlar
  //la informacion del mismo
  final StreamController<List<Movie>> _suggestionsStreamController =
      StreamController.broadcast();
  //Creamos un cream que funcionara para retornar los resultados
  Stream<List<Movie>> get suggestionsStream => this
      ._suggestionsStreamController
      .stream; //Advertencia porque es necesario cerarlo
  //Extiende de ChangeNotifer porque es lo que espera provier en MultiProvier
  MoviesProvider() {
    //print('movies provider inicializado');
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(
      _baseURL,
      endpoint,
      {
        'api_key': _apiKey,
        'language': _language,
        'page': '$page',
      },
    );
    final response = await http.get(url);
    return response.body;
  }

  void getOnDisplayMovies() async {
    /* var url = Uri.https(
      _baseURL, //DOMINO
      '/3/movie/now_playing', //PARTE DE LA API O RUTA
      {
        //QUERY PARAMETROS POR LA URI
        'api_key': _apiKey,
        'lenguage': _language,
        'page': '1',
      },
    ); */ // Este sirve para crear toda una ruta de peticon
    //print('getOnDisplayMoives');
    //final response = await http.get(url); //HACEMOS LA PETICION
    final jsonData = await _getJsonData('/3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    //print(nowPlayingResponse.results[1].title);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners(); //Este metodo viene del ChangeNotifier y hace que todos los widgets que estan escuchando se redibujen si hay un cambio
    // as Map<String, dynamic>
    //final Map<String, dynamic> decodedData = json.decode(response.body);
    //print(decodedData['results']);
    //print(response.body);
  }

  void getPopularMovies() async {
    _popularPage++;
    /* var url = Uri.https(
      _baseURL,
      '/3/movie/popular',
      {
        'api_key': _apiKey,
        'lenguage': _language,
        'page': '1',
      },
    );
    final response = await http.get(url);
    final popularResponse = PopularResponse.fromJson(response.body); */
    //Es necesario deconstruir el arreglo para concatenar
    //los resultados de las peliculas populares
    //conforme el numero de pagina vaya amuentando
    final jsonData = await _getJsonData('/3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [
      ...popularMovies,
      ...popularResponse.results,
    ]; //popularResponse.results;
    // print(popularMovies[0]);
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieID) async {
    //El async convierte cualquier retrono en un Future
    //Verificar si existe ese move ID, si esa sí no hacemos la peticion
    //Con el fin de no estar haciendo peticiones.
    if (moviesCast.containsKey(movieID)) {
      return moviesCast[movieID]!;
    }
    print('Hola cast');

    final jsonData = await _getJsonData('/3/movie/$movieID/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieID] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(
      _baseURL,
      '/3/search/movie',
      {
        'api_key': _apiKey,
        'language': _language,
        //'page': '$page',
        'query': query,
      },
    );
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionsByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      //print('Buscamos: $value');
      final results = await searchMovies(value);
      _suggestionsStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
