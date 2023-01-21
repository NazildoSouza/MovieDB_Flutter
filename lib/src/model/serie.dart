// To parse this JSON data, do
//
//     final serie = serieFromJson(jsonString);

import 'dart:convert';

SerieResponse serieFromJson(String str) =>
    SerieResponse.fromJson(json.decode(str));

class SerieResponse {
  SerieResponse({
    this.page,
    this.results,
    this.totalResults,
    this.totalPages,
  });

  int? page;
  List<Serie>? results;
  int? totalResults;
  int? totalPages;

  factory SerieResponse.fromJson(Map<String, dynamic> json) => SerieResponse(
        page: json["page"] == null ? null : json["page"],
        results: json["results"] == null
            ? null
            : List<Serie>.from(json["results"].map((x) => Serie.fromJson(x))),
        totalResults:
            json["total_results"] == null ? null : json["total_results"],
        totalPages: json["total_pages"] == null ? null : json["total_pages"],
      );
}

class Serie {
  Serie({
    this.posterPath,
    this.popularity,
    this.id,
    this.backdropPath,
    this.voteAverage,
    this.overview,
    this.firstAirDate,
    this.originCountry,
    this.genreIds,
    this.originalLanguage,
    this.voteCount,
    this.name,
    this.originalName,
  });

  String? posterPath;
  double? popularity;
  int? id;
  String? backdropPath;
  double? voteAverage;
  String? overview;
  DateTime? firstAirDate;
  List<String>? originCountry;
  List<int>? genreIds;
  String? originalLanguage;
  int? voteCount;
  String? name;
  String? originalName;

  String? posterString(String value) => posterPath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${posterPath!}';

  String? backdropString(String value) => backdropPath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${backdropPath!}';

  factory Serie.fromJson(Map<String, dynamic> json) => Serie(
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        popularity:
            json["popularity"] == null ? null : json["popularity"].toDouble(),
        id: json["id"] == null ? null : json["id"],
        backdropPath:
            json["backdrop_path"] == null ? null : json["backdrop_path"],
        voteAverage: json["vote_average"] == null
            ? null
            : json["vote_average"].toDouble(),
        overview: json["overview"] == null ? null : json["overview"],
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
      );
}
