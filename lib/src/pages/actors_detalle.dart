import 'package:flutter/material.dart';

import 'package:film_flutter/src/models/actores_model.dart';
//import 'package:film_flutter/src/models/pelicula_model.dart';
import 'package:film_flutter/src/models/actoresinfo_model.dart';

import 'package:film_flutter/src/providers/peliculas_provider.dart';
import 'package:film_flutter/src/widgets/movie_horizontal.dart';

import 'package:http/http.dart' as http;

//import 'dart:convert';
//import 'dart:async';

// String _apikey = '3b8f6da8b230d86607a8696eaf50a230';
// String _url = 'api.themoviedb.org';
// String _language = 'es-ES';

class ActoresDetalle extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    //final ActorInfo actorinfo = ModalRoute.of(context).settings.arguments;      
    final Actor actorinfo = ModalRoute.of(context).settings.arguments;

    //final ActorInfo actorinfo = new ActorInfo();

    // final actorinfo = new ActorInfo();
    // peliculasProvider.getCastValues(actor.id.toString());

    return Scaffold(
      backgroundColor: Color.fromRGBO(225, 225, 225, 1.0), //Colors.white70,
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(actorinfo),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _posterTitulo(context, actorinfo),
            _descripcion(actorinfo),
            _footer(context, actorinfo),
            //_crearCasting(actor),  NO FA FALTA EL CASTING
          ]),
        )
      ],
    ));
  }

  Widget _crearAppbar(Actor actorinfo) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.redAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          actorinfo.name,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(actorinfo.getFoto()),
          //image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/no-image.jpg'),
          //fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Actor actorinfo) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: actorinfo.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(actorinfo.getFoto()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(actorinfo.name, style: Theme.of(context).textTheme.bodyText1, overflow: TextOverflow.ellipsis),
                Text(actorinfo.getGender(), style: Theme.of(context).textTheme.bodyText1, overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[Icon(Icons.star_border), Text(actorinfo.popularity.toString(), style: Theme.of(context).textTheme.bodyText1)],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Actor actorinfo) {
    // final ActorInfo actorinfo = ModalRoute.of(context).settings.arguments;
    //final ActorInfo actorinfo = ModalRoute.of(context).settings.arguments;
    // final actorinfo = new ActorInfo();
    
    // peliculasProvider.getCastValues(actor);
    // peliculasProvider.buscarActorInfoPlus(actorid);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        actorinfo.getBiography(),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _footer(BuildContext context, Actor actorinfo) {
    //peliculasProvider.buscarPeliculasActor(actorinfo.id.toString());
    peliculasProvider.getActoresPeliculas(actorinfo.id.toString());
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(padding: EdgeInsets.only(left: 20.0), child: Text('Trabajado en:', style: Theme.of(context).textTheme.bodyText1)),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getActoresPeliculas,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

//   Widget _crearCasting(Pelicula pelicula) {
//     final peliProvider = new PeliculasProvider();

//     return FutureBuilder(
//       future: peliProvider.getCast(pelicula.id.toString()),
//       builder: (context, AsyncSnapshot<List> snapshot) {
//         if (snapshot.hasData) {
//           return _crearActoresPageView(snapshot.data);
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }

//   Widget _crearActoresPageView(List<Actor> actores) {
//     return SizedBox(
//       height: 200.0,
//       child: PageView.builder(
//         pageSnapping: false,
//         controller: PageController(viewportFraction: 0.3, initialPage: 1),
//         itemCount: actores.length,
//         itemBuilder: (context, i) => _actorTarjeta(actores[i]),
//       ),
//     );
//   }

//   Widget _actorTarjeta(Actor actor) {
//     return Container(
//         child: Column(
//       children: <Widget>[
//         ClipRRect(
//           borderRadius: BorderRadius.circular(20.0),
//           child: FadeInImage(
//             image: NetworkImage(actor.getFoto()),
//             placeholder: AssetImage('assets/img/no-image.jpg'),
//             height: 150.0,
//             fit: BoxFit.cover,
//           ),
//         ),
//         Text(
//           actor.name,
//           overflow: TextOverflow.ellipsis,
//         )
//       ],
//     ));
//   }
}