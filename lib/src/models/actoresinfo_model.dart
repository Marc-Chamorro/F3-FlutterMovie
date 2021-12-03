class CastPlus {
  List<ActorInfo> actoresinfo = [];
  CastPlus.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final actorinfo = ActorInfo.fromJsonMap(item);
      actoresinfo.add(actorinfo);
    });
  }
}

class ActorInfo {
  String idInfo; 
  String biographyInfo;
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

  ActorInfo({
    this.idInfo,
    this.biographyInfo,
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

  ActorInfo.fromJsonMap(Map<String, dynamic> json) {
    idInfo = json['id'];
    biographyInfo = json['biography'];
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

  getBiography() {
    if(biographyInfo == null) {
      return "No data";
    } else {
      return biographyInfo;
    }
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
}