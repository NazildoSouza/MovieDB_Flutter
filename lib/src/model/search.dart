// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'dart:convert';

SearchResponse searchResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str));

class SearchResponse {
  SearchResponse({
    this.page,
    this.results,
    this.totalResults,
    this.totalPages,
  });

  int? page;
  List<Search>? results;
  int? totalResults;
  int? totalPages;

  List<Search> get movies {
    if (results != null && results!.length > 0)
      return results!.where((e) => e.mediaType == MediaType.MOVIE).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    return <Search>[];
  }

  List<Search> get series {
    if (results != null && results!.length > 0)
      return results!.where((e) => e.mediaType == MediaType.TV).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    return <Search>[];
  }

  List<Search> get persons {
    if (results != null && results!.length > 0)
      return results!.where((e) => e.mediaType == MediaType.PERSON).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    return <Search>[];
  }

  int get tabLenght {
    int count = 1;
    if (movies.length > 0 && series.length > 0 && persons.length > 0) {
      count = 3;
    } else if (movies.length > 0 && series.length > 0 && persons.length == 0) {
      count = 2;
    } else if (movies.length > 0 && series.length == 0 && persons.length > 0) {
      count = 2;
    } else if (movies.length == 0 && series.length > 0 && persons.length > 0) {
      count = 2;
    }
    return count;
  }

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        page: json["page"] == null ? null : json["page"],
        results: json["results"] == null
            ? null
            : List<Search>.from(json["results"].map((x) => Search.fromJson(x))),
        totalResults:
            json["total_results"] == null ? null : json["total_results"],
        totalPages: json["total_pages"] == null ? null : json["total_pages"],
      );
}

class Search {
  Search({
    this.posterPath,
    this.popularity,
    this.id,
    this.overview,
    this.backdropPath,
    this.voteAverage,
    this.mediaType,
    this.firstAirDate,
    this.originCountry,
    this.genreIds,
    this.originalLanguage,
    this.voteCount,
    this.name,
    this.originalName,
    this.adult,
    this.releaseDate,
    this.originalTitle,
    this.title,
    this.video,
    this.profilePath,
    this.knownFor,
  });

  String? posterPath;
  double? popularity;
  int? id;
  String? overview;
  String? backdropPath;
  double? voteAverage;
  MediaType? mediaType;
  DateTime? firstAirDate;
  List<String>? originCountry;
  List<int>? genreIds;
  String? originalLanguage;
  int? voteCount;
  String? name;
  String? originalName;
  bool? adult;
  DateTime? releaseDate;
  String? originalTitle;
  String? title;
  bool? video;
  String? profilePath;
  List<Search>? knownFor;

  String get atuou {
    if (knownFor != null && knownFor!.length > 0) {
      return knownFor!.map((e) => e.title ?? e.name).join(', ');
    }
    return '--';
  }

  DateTime get date =>
      releaseDate ?? firstAirDate ?? DateTime.now().add(Duration(days: 50000));

  String? posterString(String value) => posterPath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${posterPath!}';

  String? profileString(String value) => profilePath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${profilePath!}';

  String? backdropString(String value) => backdropPath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${backdropPath!}';

  factory Search.fromJson(Map<String, dynamic> json) => Search(
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        popularity:
            json["popularity"] == null ? null : json["popularity"].toDouble(),
        id: json["id"] == null ? null : json["id"],
        overview: json["overview"] == null ? null : json["overview"],
        backdropPath:
            json["backdrop_path"] == null ? null : json["backdrop_path"],
        voteAverage: json["vote_average"] == null
            ? null
            : json["vote_average"].toDouble(),
        mediaType: json["media_type"] == null
            ? null
            : mediaTypeValues.map[json["media_type"]],
        firstAirDate:
            (json["first_air_date"] == null || json["first_air_date"] == '')
                ? null
                : DateTime.parse(json["first_air_date"]),
        originCountry: json["origin_country"] == null
            ? null
            : List<String>.from(json["origin_country"].map((x) => x)),
        genreIds: json["genre_ids"] == null
            ? null
            : List<int>.from(json["genre_ids"].map((x) => x)),
        originalLanguage: json["original_language"] == null
            ? null
            : json["original_language"],
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
        name: json["name"] == null ? null : json["name"],
        originalName:
            json["original_name"] == null ? null : json["original_name"],
        adult: json["adult"] == null ? null : json["adult"],
        releaseDate:
            (json["release_date"] == null || json["release_date"] == '')
                ? null
                : DateTime.parse(json["release_date"]),
        originalTitle:
            json["original_title"] == null ? null : json["original_title"],
        title: json["title"] == null ? null : json["title"],
        video: json["video"] == null ? null : json["video"],
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
        knownFor: json["known_for"] == null
            ? null
            : List<Search>.from(
                json["known_for"].map((x) => Search.fromJson(x))),
      );
}

enum MediaType { TV, MOVIE, PERSON }

final mediaTypeValues = EnumValues(
    {"movie": MediaType.MOVIE, "person": MediaType.PERSON, "tv": MediaType.TV});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
