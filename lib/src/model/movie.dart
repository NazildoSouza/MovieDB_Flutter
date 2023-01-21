import 'dart:convert';

MovieResponse movieResponseFromJson(String str) =>
    MovieResponse.fromJson(json.decode(str));

class MovieResponse {
  MovieResponse({
    this.page,
    this.results,
    this.dates,
    this.totalPages,
    this.totalResults,
  });

  int? page;
  List<Movie>? results;
  Dates? dates;
  int? totalPages;
  int? totalResults;

  MovieResponse copyWith({
    int? page,
    List<Movie>? results,
    Dates? dates,
    int? totalPages,
    int? totalResults,
  }) {
    return MovieResponse(
      page: page ?? this.page,
      results: results ?? this.results,
      dates: dates ?? this.dates,
      totalPages: totalPages ?? this.totalResults,
      totalResults: totalResults ?? this.totalResults,
    );
  }

  factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
        page: json["page"] == null ? null : json["page"],
        results: json["results"] == null
            ? null
            : List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        dates: json["dates"] == null ? null : Dates.fromJson(json["dates"]),
        totalPages: json["total_pages"] == null ? null : json["total_pages"],
        totalResults:
            json["total_results"] == null ? null : json["total_results"],
      );
}

class Dates {
  Dates({
    this.maximum,
    this.minimum,
  });

  DateTime? maximum;
  DateTime? minimum;

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        maximum:
            json["maximum"] == null ? null : DateTime.parse(json["maximum"]),
        minimum:
            json["minimum"] == null ? null : DateTime.parse(json["minimum"]),
      );
}

class Movie {
  Movie({
    this.posterPath,
    this.adult,
    this.overview,
    this.releaseDate,
    this.genreIds,
    this.id,
    this.originalTitle,
    this.originalLanguage,
    this.title,
    this.backdropPath,
    this.popularity,
    this.voteCount,
    this.video,
    this.voteAverage,
  });

  String? posterPath;
  bool? adult;
  String? overview;
  DateTime? releaseDate;
  List<int>? genreIds;
  int? id;
  String? originalTitle;
  String? originalLanguage;
  String? title;
  String? backdropPath;
  double? popularity;
  int? voteCount;
  bool? video;
  double? voteAverage;

  String? posterString(String value) => posterPath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${posterPath!}';

  String? backdropString(String value) => backdropPath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${backdropPath!}';

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        adult: json["adult"] == null ? null : json["adult"],
        overview: json["overview"] == null ? null : json["overview"],
        releaseDate: json["release_date"] == null
            ? null
            : DateTime.parse(json["release_date"]),
        genreIds: json["genre_ids"] == null
            ? null
            : List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"] == null ? null : json["id"],
        originalTitle:
            json["original_title"] == null ? null : json["original_title"],
        originalLanguage: json["original_language"] == null
            ? null
            : json["original_language"],
        title: json["title"] == null ? null : json["title"],
        backdropPath:
            json["backdrop_path"] == null ? null : json["backdrop_path"],
        popularity:
            json["popularity"] == null ? null : json["popularity"].toDouble(),
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
        video: json["video"] == null ? null : json["video"],
        voteAverage: json["vote_average"] == null
            ? null
            : json["vote_average"].toDouble(),
      );
}
