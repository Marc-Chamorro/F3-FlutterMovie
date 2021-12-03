import 'package:film_flutter/src/models/actores_model.dart';
import 'package:film_flutter/src/models/actoresinfo_model.dart';
import 'package:flutter/material.dart';
import 'package:film_flutter/src/providers/peliculas_provider.dart';
import 'package:film_flutter/src/search/search_delegate.dart';

import 'package:film_flutter/src/widgets/card_swiper_widget.dart';
import 'package:film_flutter/src/widgets/movie_horizontal.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {  //objecte on implementem les accions
    peliculasProvider.getPopulares();

    return Scaffold(
      backgroundColor: Color.fromRGBO(225, 225, 225, 1.0), //Colors.white70,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Peliculas TMDB'),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),
            //_crearCasting(),
            _footerCasting(context)],
        ),
      )
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(padding: EdgeInsets.only(left: 20.0), child: Text('Populares', style: Theme.of(context).textTheme.bodyText1)),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
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

  /*Widget _footercast(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(padding: EdgeInsets.only(left: 20.0), child: Text('Actores Populares', style: Theme.of(context).textTheme.bodyText1)),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: peliculasProvider.popularesActoresStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopularesActores,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }*/

  //Widget Copiat de pelicula_detalle

  //custom widget
  //Container(padding: EdgeInsets.only(left: 20.0), child: Text('Actores Populares', style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.left)),

  Widget _footerCasting(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(padding: EdgeInsets.only(left: 20.0), child: Text('Actores Populares', style: Theme.of(context).textTheme.bodyText1)),
          SizedBox(height: 5.0),
          _crearCasting(),
          /*StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopularesActores,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),*/
        ],
      ),
    );
  }

  Widget _crearCasting() {
    final peliProvider = new PeliculasProvider();

    peliculasProvider.getPopularesActores();

    return FutureBuilder(  
      future: peliProvider.getPopularesActores(),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i], context),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor, BuildContext context) {
    //final peliProvider = new PeliculasProvider();
    //peliculasProvider.buscarActorBiografia(actor.id.toString()); //aixo funciona?
    //final ActorInfo actorinfo = new ActorInfo();
    return GestureDetector(
      onTap: () {
        //peliculasProvider.buscarActorBiografia(actor.id.toString());
        Navigator.pushNamed(context, 'detalleactor', arguments: actor); //ACTOR CANVIAR PER ACTORPLUS?
      },
      child: new Container(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(actor.getFoto()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                height: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              actor.name,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),         
    );
  }
}
