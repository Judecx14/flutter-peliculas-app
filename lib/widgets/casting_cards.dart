import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  CastingCards(this.movieID);
  final int movieID;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final moviesProvider = Provider.of<MoviesProvider>(
      context,
      listen: false,
    );
    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieID),
      //initialData: InitialData,
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final List<Cast> cast = snapshot.data!;

        return Container(
          //width: double.infinity,
          margin: EdgeInsets.only(bottom: 30),
          height: 250,
          //color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Reparto',
                  style: textTheme.headline5,
                  //textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cast.length,
                  itemBuilder: (_, int index) => _CastCard(cast[index]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard(this.actor);
  final Cast actor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      width: 110,
      height: 100,
      //color: Colors.green,
      child: Column(
        children: [
          CircleAvatar(
            maxRadius: 60,
            //child:
            backgroundImage: NetworkImage(actor.fullProfilePath),
            //foregroundImage: AssetImage('no-image.jpg'),
            //height: 140.0,
            //width: 100,
          ),
          /* ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              height: 140.0,
              width: 100,
              fit: BoxFit.cover,
            ),
          ), */
          SizedBox(
            height: 5,
          ),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
