// To parse this JSON data, do
//
//     final serie = serieFromJson(jsonString);

import 'dart:convert';

import 'package:moviedb_flutter/src/extensions/extension.dart';
import 'package:moviedb_flutter/src/model/credits.dart';
import 'package:moviedb_flutter/src/model/images.dart';
import 'package:moviedb_flutter/src/model/videos.dart';

SerieDetail serieFromJson(String str) => SerieDetail.fromJson(json.decode(str));

class SerieDetail {
  SerieDetail({
    this.backdropPath,
    this.createdBy,
    this.episodeRunTime,
    this.firstAirDate,
    this.genres,
    this.homepage,
    this.id,
    this.inProduction,
    this.languages,
    this.lastAirDate,
    this.lastEpisodeToAir,
    this.name,
    this.nextEpisodeToAir,
    this.networks,
    this.numberOfEpisodes,
    this.numberOfSeasons,
    this.originCountry,
    this.originalLanguage,
    this.originalName,
    this.overview,
    this.popularity,
    this.posterPath,
    this.productionCompanies,
    this.productionCountries,
    this.seasons,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.type,
    this.voteAverage,
    this.voteCount,
    this.credits,
    this.videos,
  });

  String? backdropPath;
  List<CreatedBy>? createdBy;
  List<int>? episodeRunTime;
  DateTime? firstAirDate;
  List<Genre>? genres;
  String? homepage;
  int? id;
  bool? inProduction;
  List<String>? languages;
  DateTime? lastAirDate;
  LastEpisodeToAir? lastEpisodeToAir;
  String? name;
  dynamic nextEpisodeToAir;
  List<Network>? networks;
  int? numberOfEpisodes;
  int? numberOfSeasons;
  List<String>? originCountry;
  String? originalLanguage;
  String? originalName;
  String? overview;
  double? popularity;
  String? posterPath;
  List<Network>? productionCompanies;
  List<ProductionCountry>? productionCountries;
  List<Season>? seasons;
  List<SpokenLanguage>? spokenLanguages;
  String? status;
  String? tagline;
  String? type;
  double? voteAverage;
  int? voteCount;

  ImagesResponse? serieImage;

  Credits? credits;
  VideosResponse? videos;

  String get statusString {
    if (status != null && status!.isNotEmpty) {
      if (status! == 'Ended') {
        return 'Finalizada';
      } else if (status! == 'Returning Series') {
        return 'Renovada';
      }
    }

    return '--';
  }

  String get createdString {
    if (createdBy != null && createdBy!.length > 0)
      return createdBy!.map((e) => e.name).join(', ');
    return '--';
  }

  String? posterString(String value) => posterPath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${posterPath!}';

  String? backdropString(String value) => backdropPath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${backdropPath!}';

  String get genresString => genres?.map((e) => e.name ?? '').join(', ') ?? '-';

  String get dateString {
    if (firstAirDate != null && lastAirDate != null) {
      return '${firstAirDate!.formattedDate()} à ${lastAirDate!.formattedDate()}';
    } else if (firstAirDate != null && lastAirDate == null) {
      return firstAirDate!.formattedDate();
    }

    return '--';
  }

  String get timeString {
    try {
      var episodeRunTime = this.episodeRunTime?.first;
      if (episodeRunTime != null && episodeRunTime >= 60) {
        var duration = Duration(minutes: episodeRunTime);
        if (duration.inMinutes.remainder(60) > 0)
          return '${duration.inHours.remainder(60)}h ${duration.inMinutes.remainder(60)}m';
        return '${duration.inHours.remainder(60)}h';
      } else if (episodeRunTime != null && episodeRunTime < 60) {
        var duration = Duration(minutes: episodeRunTime);
        return '${duration.inMinutes.remainder(60)}m';
      }
    } catch (_) {
      return '-';
    }
    return '-';
  }

  factory SerieDetail.fromJson(Map<String, dynamic> json) => SerieDetail(
        backdropPath:
            json["backdrop_path"] == null ? null : json["backdrop_path"],
        createdBy: json["created_by"] == null
            ? null
            : List<CreatedBy>.from(
                json["created_by"].map((x) => CreatedBy.fromJson(x))),
        episodeRunTime: json["episode_run_time"] == null
            ? null
            : List<int>.from(json["episode_run_time"].map((x) => x)),
        firstAirDate:
            (json["first_air_date"] == null || json["first_air_date"] == '')
                ? null
                : DateTime.parse(json["first_air_date"]),
        genres: json["genres"] == null
            ? null
            : List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
        homepage: json["homepage"] == null ? null : json["homepage"],
        id: json["id"] == null ? null : json["id"],
        inProduction:
            json["in_production"] == null ? null : json["in_production"],
        languages: json["languages"] == null
            ? null
            : List<String>.from(json["languages"].map((x) => x)),
        lastAirDate:
            (json["last_air_date"] == null || json["last_air_date"] == '')
                ? null
                : DateTime.parse(json["last_air_date"]),
        lastEpisodeToAir: json["last_episode_to_air"] == null
            ? null
            : LastEpisodeToAir.fromJson(json["last_episode_to_air"]),
        name: json["name"] == null ? null : json["name"],
        nextEpisodeToAir: json["next_episode_to_air"],
        networks: json["networks"] == null
            ? null
            : List<Network>.from(
                json["networks"].map((x) => Network.fromJson(x))),
        numberOfEpisodes: json["number_of_episodes"] == null
            ? null
            : json["number_of_episodes"],
        numberOfSeasons: json["number_of_seasons"] == null
            ? null
            : json["number_of_seasons"],
        originCountry: json["origin_country"] == null
            ? null
            : List<String>.from(json["origin_country"].map((x) => x)),
        originalLanguage: json["original_language"] == null
            ? null
            : json["original_language"],
        originalName:
            json["original_name"] == null ? null : json["original_name"],
        overview: json["overview"] == null ? null : json["overview"],
        popularity:
            json["popularity"] == null ? null : json["popularity"].toDouble(),
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        productionCompanies: json["production_companies"] == null
            ? null
            : List<Network>.from(
                json["production_companies"].map((x) => Network.fromJson(x))),
        productionCountries: json["production_countries"] == null
            ? null
            : List<ProductionCountry>.from(json["production_countries"]
                .map((x) => ProductionCountry.fromJson(x))),
        seasons: json["seasons"] == null
            ? null
            : List<Season>.from(json["seasons"].map((x) => Season.fromJson(x))),
        spokenLanguages: json["spoken_languages"] == null
            ? null
            : List<SpokenLanguage>.from(json["spoken_languages"]
                .map((x) => SpokenLanguage.fromJson(x))),
        status: json["status"] == null ? null : json["status"],
        tagline: json["tagline"] == null ? null : json["tagline"],
        type: json["type"] == null ? null : json["type"],
        voteAverage: json["vote_average"] == null
            ? null
            : json["vote_average"].toDouble(),
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
        videos: json["videos"] == null
            ? null
            : VideosResponse.fromJson(json["videos"]),
        credits:
            json["credits"] == null ? null : Credits.fromJson(json["credits"]),
      );
}

class CreatedBy {
  CreatedBy({
    this.id,
    this.creditId,
    this.name,
    this.gender,
    this.profilePath,
  });

  int? id;
  String? creditId;
  String? name;
  int? gender;
  String? profilePath;

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"] == null ? null : json["id"],
        creditId: json["credit_id"] == null ? null : json["credit_id"],
        name: json["name"] == null ? null : json["name"],
        gender: json["gender"] == null ? null : json["gender"],
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
      );
}

class Genre {
  Genre({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );
}

class LastEpisodeToAir {
  LastEpisodeToAir({
    this.airDate,
    this.episodeNumber,
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
  int? id;
  String? name;
  String? overview;
  String? productionCode;
  int? seasonNumber;
  String? stillPath;
  double? voteAverage;
  int? voteCount;

  factory LastEpisodeToAir.fromJson(Map<String, dynamic> json) =>
      LastEpisodeToAir(
        airDate: (json["air_date"] == null || json["air_date"] == '')
            ? null
            : DateTime.parse(json["air_date"]),
        episodeNumber:
            json["episode_number"] == null ? null : json["episode_number"],
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

class Network {
  Network({
    this.name,
    this.id,
    this.logoPath,
    this.originCountry,
  });

  String? name;
  int? id;
  String? logoPath;
  String? originCountry;

  factory Network.fromJson(Map<String, dynamic> json) => Network(
        name: json["name"] == null ? null : json["name"],
        id: json["id"] == null ? null : json["id"],
        logoPath: json["logo_path"] == null ? null : json["logo_path"],
        originCountry:
            json["origin_country"] == null ? null : json["origin_country"],
      );
}

class ProductionCountry {
  ProductionCountry({
    this.iso31661,
    this.name,
  });

  String? iso31661;
  String? name;

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      ProductionCountry(
        iso31661: json["iso_3166_1"] == null ? null : json["iso_3166_1"],
        name: json["name"] == null ? null : json["name"],
      );
}

class Season {
  Season({
    this.airDate,
    this.episodeCount,
    this.id,
    this.name,
    this.overview,
    this.posterPath,
    this.seasonNumber,
  });

  DateTime? airDate;
  int? episodeCount;
  int? id;
  String? name;
  String? overview;
  String? posterPath;
  int? seasonNumber;

  String? posterString(String value) => posterPath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${posterPath!}';

  factory Season.fromJson(Map<String, dynamic> json) => Season(
        airDate: (json["air_date"] == null || json["air_date"] == '')
            ? null
            : DateTime.parse(json["air_date"]),
        episodeCount:
            json["episode_count"] == null ? null : json["episode_count"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        overview: json["overview"] == null ? null : json["overview"],
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        seasonNumber:
            json["season_number"] == null ? null : json["season_number"],
      );
}

class SpokenLanguage {
  SpokenLanguage({
    this.englishName,
    this.iso6391,
    this.name,
  });

  String? englishName;
  String? iso6391;
  String? name;

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) => SpokenLanguage(
        englishName: json["english_name"] == null ? null : json["english_name"],
        iso6391: json["iso_639_1"] == null ? null : json["iso_639_1"],
        name: json["name"] == null ? null : json["name"],
      );
}
