import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO: Cambiar luego por una instancia de movie

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    //as es tratar como Movie
    // De esta manera obtenemos los argumentos de la rua
    //Se coloca el signo de interrogacion antes de setting, porque puede que no vengan
    // y los ultimos signos de interrogacion se ponen en caso de que sea nulo, osea
    //Que venga de una pantalla que no sea el poster y no lo pongo en el String?
    //Porque siempre quiero que tenga un valor, puede ser una instancia de pelicula
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movie),
          SliverList(
            //Como un container tipo ListView
            delegate: SliverChildListDelegate(
              [
                _PosterAndTitle(movie),
                _Overview(movie),
                /* _Overview(movie),
                _Overview(movie), */
                CastingCards(movie.id)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  _CustomAppBar(this.movie);

  Movie movie;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 200.0,
      floating: false,
      pinned: true, //Que no desaparezca al momento de subir
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          bottom: 17,
          left: 25,
          right: 10,
        ), //Quita el pading del title
        //titlePadding: EdgeInsets.all(0),
        centerTitle: true,

        title: Text(
          movie.title,
          style: const TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis),
          maxLines: 2,
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            FadeInImage(
              placeholder: AssetImage('assets/loading.gif'),
              image: NetworkImage(movie.fullBackdropPath),
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  _PosterAndTitle(this.movie);
  Movie movie;
  @override
  Widget build(BuildContext context) {
    //Este para indicarle a un texto si es titulo, subtitulo o caption etc
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                height:
                    150, //Es importante especificar las dimensiones cuando las imagenes no son del mismo tamaño
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          ConstrainedBox(
            //Sirve para delimitar el espacio de un widget
            //Se uso este widget por el ROW que se expande todo
            //Con esto lo limitamos
            constraints: BoxConstraints(maxWidth: size.width - 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  movie.originalTitle,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 15,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      movie.voteAverage.toString(),
                      style: textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  _Overview(this.movie);
  Movie movie;
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: textTheme.subtitle1,
      ),
    );
  }
}
