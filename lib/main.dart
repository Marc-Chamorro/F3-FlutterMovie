import 'package:flutter/material.dart';

import 'package:film_flutter/src/pages/home_page.dart';
import 'package:film_flutter/src/pages/pelicula_detalle.dart';
import 'package:film_flutter/src/pages/actors_detalle.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas TMDB',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detalle': (BuildContext context) => PeliculaDetalle(),
        'detalleactor': (BuildContext context) => ActoresDetalle(),
      },
    );
  }
}
