// To parse this JSON data, do
//
//     final seasonResponse = seasonResponseFromJson(jsonString);

import 'dart:convert';

import 'package:moviedb_flutter/src/model/credits.dart';
import 'package:moviedb_flutter/src/model/images.dart';

SeasonResponse seasonResponseFromJson(String str) =>
    SeasonResponse.fromJson(json.decode(str));

class SeasonResponse {
  SeasonResponse({
    this.id,
    this.airDate,
    this.episodes,
    this.name,
    this.overview,
    this.seasonResponseId,
    this.posterPath,
    this.seasonNumber,
  });

  String? id;
  DateTime? airDate;
  List<Episode>? episodes;
  String? name;
  String? overview;
  int? seasonResponseId;
  String? posterPath;
  int? seasonNumber;

  factory SeasonResponse.fromJson(Map<String, dynamic> json) => SeasonResponse(
        id: json["_id"] == null ? null : json["_id"],
        airDate: (json["air_date"] == null || json["air_date"] == '')
            ? null
            : DateTime.parse(json["air_date"]),
        episodes: json["episodes"] == null
            ? null
            : List<Episode>.from(
                json["episodes"].map((x) => Episode.fromJson(x))),
        name: json["name"] == null ? null : json["name"],
        overview: json["overview"] == null ? null : json["overview"],
        seasonResponseId: json["id"] == null ? null : json["id"],
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        seasonNumber:
            json["season_number"] == null ? null : json["season_number"],
      );
}

class Episode {
  Episode({
    this.airDate,
    this.episodeNumber,
    this.crew,
    this.guestStars,
    this.id,
    this.name,
    this.overview,
    this.productionCode,
    this.seasonNumber,
    this.stillPath,
    this.voteAverage,
    this.voteCount,
  });

  DateTime? airDate;
  int? episodeNumber;
  List<Cast>? crew;
  List<Cast>? guestStars;
  int? id;
  String? name;
  String? overview;
  String? productionCode;
  int? seasonNumber;
  String? stillPath;
  double? voteAverage;
  int? voteCount;

  List<Screenshot>? images;

  String? stillString(String value) => stillPath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${stillPath!}';

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        airDate: (json["air_date"] == null || json["air_date"] == '')
            ? null
            : DateTime.parse(json["air_date"]),
        episodeNumber:
            json["episode_number"] == null ? null : json["episode_number"],
        crew: json["crew"] == null
            ? null
            : List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
        guestStars: json["guest_stars"] == null
            ? null
            : List<Cast>.from(json["guest_stars"].map((x) => Cast.fromJson(x))),
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        overview: json["overview"] == null ? null : json["overview"],
        productionCode:
            json["production_code"] == null ? null : json["production_code"],
        seasonNumber:
            json["season_number"] == null ? null : json["season_number"],
        stillPath: json["still_path"] == null ? null : json["still_path"],
        voteAverage: json["vote_average"] == null
            ? null
            : json["vote_average"].toDouble(),
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
      );
}
