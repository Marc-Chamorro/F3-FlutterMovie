import 'package:film_flutter/src/providers/peliculas_provider.dart';
import 'package:flutter/cupertino.dart';

class Cast {
  List<Actor> actores = [];

  Cast.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final actor = Actor.fromJsonMap(item);
      actores.add(actor);

      // if(actor.biography == null){actor.biography == "No data";}

      // if(actor.biography != null && actor.profilePath != null){
      //   actores.add(actor);
      // }
    });
  }
}

class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;
  String department;
  double popularity;
  String biography;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
    this.department,
    this.popularity,
    this.biography,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    castId = json['cast_id'];
    character = json['character'];
    creditId = json['credit_id'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    profilePath = json['profile_path'];
    department = json['known_for_department'];
    popularity = json['popularity'];
    biography = json['biography'];
  }

  getFoto() {
    if (profilePath == null) {
      return 'http://forum.spaceengine.org/styles/se/theme/images/no_avatar.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }

  getGender() {
    if (gender == 1) {
      return "Woman";
    } else {
      return "Man";
    }
  }

  getBiography() {
    if(biography == null) {
      return "No data";
    } else {
      return biography;
    }
  }

  // getBiography(String id) async {
  //   final peliculasProvider = new PeliculasProvider();
  //   String proba = peliculasProvider.buscarActorBiografia(id);
  //   if(proba == null) {
  //     return "No data"; 
  //   } else {
  //     return proba;
  //   }
  // }

    // return FutureBuilder(
    //   future: peliculasProvider.buscarActorBiografia(id),
    //   //builder: (context, AsyncSnapshot<List> snapshot) {
    //     string valor peliculasProvider.buscarActorBiografia(id),
    //     if (valor != null) {
    //       return _crearActoresPageView(snapshot.data);
    //     } else {
    //       return "No data";
    //     }
    // )
}
