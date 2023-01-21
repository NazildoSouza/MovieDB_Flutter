// To parse this JSON data, do
//
//     final credits = creditsFromJson(jsonString);

import 'dart:convert';

Credits creditsFromJson(String str) => Credits.fromJson(json.decode(str));

class Credits {
  Credits({
    this.id,
    this.cast,
    this.crew,
  });

  int? id;
  List<Cast>? cast;
  List<Cast>? crew;

  factory Credits.fromJson(Map<String, dynamic> json) => Credits(
        id: json["id"] == null ? null : json["id"],
        cast: json["cast"] == null
            ? null
            : List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: json["crew"] == null
            ? null
            : List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
      );
}

class Cast {
  Cast({
    this.knownForDepartment,
    this.id,
    this.name,
    this.gender,
    this.popularity,
    this.profilePath,
    this.adult,
    this.originalName,
    this.castId,
    this.character,
    this.creditId,
    this.order,
    this.department,
    this.job,
    this.releaseDate,
    this.voteCount,
    this.video,
    this.voteAverage,
    this.title,
    this.genreIds,
    this.originalLanguage,
    this.originalTitle,
    this.backdropPath,
    this.overview,
    this.posterPath,
    this.episodeCount,
    this.firstAirDate,
    this.originCountry,
  });

  String? knownForDepartment;
  int? id;
  String? name;
  int? gender;
  double? popularity;
  String? profilePath;
  bool? adult;
  String? originalName;
  int? castId;
  String? character;
  String? creditId;
  int? order;
  String? department;
  String? job;

  /// cast movie
  DateTime? releaseDate;
  int? voteCount;
  bool? video;
  double? voteAverage;
  String? title;
  List<int>? genreIds;
  String? originalLanguage;
  String? originalTitle;
  String? backdropPath;
  String? overview;
  String? posterPath;

  /// cast tv
  int? episodeCount;
  DateTime? firstAirDate;
  List<String>? originCountry;

  DateTime get date =>
      releaseDate ?? firstAirDate ?? DateTime.now().add(Duration(days: 50000));

  String? profileString(String value) => profilePath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${profilePath!}';

  String? posterString(String value) => posterPath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${posterPath!}';

  String? backdropString(String value) => backdropPath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${backdropPath!}';

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        adult: json["adult"] == null ? null : json["adult"],
        gender: json["gender"] == null ? null : json["gender"],
        id: json["id"] == null ? null : json["id"],
        knownForDepartment: json["known_for_department"] == null
            ? null
            : json["known_for_department"],
        name: json["name"] == null ? null : json["name"],
        originalName:
            json["original_name"] == null ? null : json["original_name"],
        popularity:
            json["popularity"] == null ? null : json["popularity"].toDouble(),
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
        castId: json["cast_id"] == null ? null : json["cast_id"],
        character: json["character"] == null ? null : json["character"],
        creditId: json["credit_id"] == null ? null : json["credit_id"],
        order: json["order"] == null ? null : json["order"],
        department: json["department"] == null ? null : json["department"],
        job: json["job"] == null ? null : json["job"],
        releaseDate:
            (json["release_date"] == null || json['release_date'] == '')
                ? null
                : DateTime.parse(json["release_date"]),
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
        video: json["video"] == null ? null : json["video"],
        voteAverage: json["vote_average"] == null
            ? null
            : json["vote_average"].toDouble(),
        title: json["title"] == null ? null : json["title"],
        genreIds: json["genre_ids"] == null
            ? null
            : List<int>.from(json["genre_ids"].map((x) => x)),
        originalLanguage: json["original_language"] == null
            ? null
            : json["original_language"],
        originalTitle:
            json["original_title"] == null ? null : json["original_title"],
        overview: json["overview"] == null ? null : json["overview"],
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        episodeCount:
            json["episode_count"] == null ? null : json["episode_count"],
        firstAirDate:
            (json["first_air_date"] == null || json['first_air_date'] == '')
                ? null
                : DateTime.parse(json["first_air_date"]),
        originCountry: json["origin_country"] == null
            ? null
            : List<String>.from(json["origin_country"].map((x) => x)),
      );
}

// enum Department {
//   ACTING,
//   WRITING,
//   CREW,
//   VISUAL_EFFECTS,
//   DIRECTING,
//   PRODUCTION,
//   COSTUME_MAKE_UP,
//   ART,
//   SOUND,
//   CAMERA,
//   EDITING,
//   LIGHTING
// }

// final departmentValues = EnumValues({
//   "Acting": Department.ACTING,
//   "Art": Department.ART,
//   "Camera": Department.CAMERA,
//   "Costume & Make-Up": Department.COSTUME_MAKE_UP,
//   "Crew": Department.CREW,
//   "Directing": Department.DIRECTING,
//   "Editing": Department.EDITING,
//   "Lighting": Department.LIGHTING,
//   "Production": Department.PRODUCTION,
//   "Sound": Department.SOUND,
//   "Visual Effects": Department.VISUAL_EFFECTS,
//   "Writing": Department.WRITING
// });

// class EnumValues<T> {
//   Map<String, T>? map;
//   Map<T, String>? reverseMap;

//   EnumValues(this.map);

//   Map<T, String>? get reverse {
//     if (reverseMap == null) {
//       reverseMap = map?.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
