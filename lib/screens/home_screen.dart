import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Esta linea crea la instacia de MoviesProvider, usando el contexto
    //Lo que hace es buscar en el arbol de widgets si es que existe una instancia
    //Por eso se declara la instacia de la clase en el main
    final moviesProvier = Provider.of<MoviesProvider>(
      context,
      //Por defecto viene en true pero la deje para acordame
      //que esta propiedad sierve para indicar si se va a redibujar en
      //caso de que se llame el metodo notifierListeners
      //listen: true,
    );

    //print(moviesProvier.onDisplayMovies);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en cines'),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: MovieSearchDelegate(),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        //Crea el scroll en caso de que el tamaño se sobre pase
        child: Column(
          children: [
            //Listado horizonal de peliculas
            CardSwipper(movies: moviesProvier.onDisplayMovies),
            //Slider de peliculas
            MovieSlider(
              movies: moviesProvier.popularMovies,
              title: 'Más Populares!',
              onNextPage: () => moviesProvier.getPopularMovies(),
            ),
          ],
        ),
      ),
    );
  }
}
