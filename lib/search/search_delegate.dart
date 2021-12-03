import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  // Esto esta sobrescribiendo la propiedad del label de search
  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => 'Buscar';

  @override
  List<Widget>? buildActions(BuildContext context) {
    //Botones
    return [
      IconButton(
        onPressed: () => query = '',
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //Antes del buscar
    return IconButton(
      onPressed: () {
        close(
          context,
          null, //Este puede retornar un resultado
        );
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //Resultados
    return Text('buildResults');
  }

  //Este es porque lo reutilizamos dos veces, uno cuando inicia
  //Y otro cuando busca y no encuentra o cuando inicia la data ponerle
  //Ese por defecto
  Widget _emptyContainer() {
    return Container(
      child: Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.grey,
          size: 100,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Este siempre esta activo
    //Sugerencias
    //query es una propiedad del SearhDelegate que nos permite ver la busqueda
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(
      context,
      listen: false,
    );
    //Se pone aquí porque el buildSuggestion se ejecuta cada vez que
    //se escribe así que se ejecuta cada vez que sucede eso
    moviesProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionsStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();

        final List<Movie> movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int index) => _itemSuggestion(movies[index]),
        );
      },
    );
  }
}

class _itemSuggestion extends StatelessWidget {
  const _itemSuggestion(this.movie);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}
