// To parse this JSON data, do
//
//     final person = personFromJson(jsonString);

import 'dart:convert';

import 'package:moviedb_flutter/src/extensions/extension.dart';
import 'package:moviedb_flutter/src/model/credits.dart';
import 'package:moviedb_flutter/src/model/person_images.dart';

Person personFromJson(String str) => Person.fromJson(json.decode(str));

class Person {
  Person({
    this.birthday,
    this.knownForDepartment,
    this.deathday,
    this.id,
    this.name,
    this.alsoKnownAs,
    this.gender,
    this.biography,
    this.popularity,
    this.placeOfBirth,
    this.profilePath,
    this.adult,
    this.imdbId,
    this.homepage,
    this.movieCredits,
    this.tvCredits,
    this.images,
  });

  DateTime? birthday;
  String? knownForDepartment;
  DateTime? deathday;
  int? id;
  String? name;
  List<String>? alsoKnownAs;
  int? gender;
  String? biography;
  double? popularity;
  String? placeOfBirth;
  String? profilePath;
  bool? adult;
  String? imdbId;
  String? homepage;

  Credits? movieCredits;
  Credits? tvCredits;
  PersonImages? images;

  String get genderString {
    if (gender != null) {
      if (gender! == 1) {
        return 'Feminino';
      } else if (gender! == 2) {
        return 'Masculino';
      }
    }
    return '--';
  }

  String? profileString(String value) => profilePath == null
      ? null
      : 'https://image.tmdb.org/t/p/$value${profilePath!}';

  String get birthdayString {
    if (birthday != null) {
      var dur = DateTime.now().difference(birthday!);
      String differenceInYears = (dur.inDays / 365).floor().toString();
      var date = birthday!.formattedDate();

      if (deathday == null) {
        return '$date ($differenceInYears de Idade)';
      } else {
        return '$date';
      }
    }
    return '-';
  }

  String get deathDayString {
    if (deathday != null && birthday != null) {
      var dur = deathday!.difference(birthday!);
      String differenceInYears = (dur.inDays / 365).floor().toString();
      var date = deathday!.formattedDate();

      return '$date ($differenceInYears de Idade)';
    }
    return '-';
  }

  List<Cast> get casts {
    List<Cast> listCast = [];
    if (movieCredits != null &&
        movieCredits!.cast != null &&
        movieCredits!.cast!.isNotEmpty) {
      listCast.addAll(movieCredits!.cast!);
    }
    if (tvCredits != null &&
        tvCredits!.cast != null &&
        tvCredits!.cast!.isNotEmpty) {
      listCast.addAll(tvCredits!.cast!);
    }
    listCast.sort((a, b) => b.date.compareTo(a.date));
    return listCast;
  }

  List<Cast> get crews {
    List<Cast> listCast = [];
    if (movieCredits != null &&
        movieCredits!.crew != null &&
        movieCredits!.crew!.isNotEmpty) {
      listCast.addAll(movieCredits!.crew!);
    }
    if (tvCredits != null &&
        tvCredits!.crew != null &&
        tvCredits!.crew!.isNotEmpty) {
      listCast.addAll(tvCredits!.crew!);
    }
    listCast.sort((a, b) => b.date.compareTo(a.date));
    return listCast;
  }

  int get tabLenght {
    int count = 1;
    if (crews.length > 0 && casts.length > 0) {
      count = 3;
    } else if (casts.length > 0 && crews.length == 0) {
      count = 2;
    } else if (crews.length > 0 && casts.length == 0) {
      count = 2;
    }
    return count;
  }

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        birthday: (json["birthday"] == null || json["birthday"] == '')
            ? null
            : DateTime.parse(json["birthday"]),
        knownForDepartment: json["known_for_department"] == null
            ? null
            : json["known_for_department"],
        deathday: (json["deathday"] == null || json["deathday"] == '')
            ? null
            : DateTime.parse(json["deathday"]),
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        alsoKnownAs: json["also_known_as"] == null
            ? null
            : List<String>.from(json["also_known_as"].map((x) => x)),
        gender: json["gender"] == null ? null : json["gender"],
        biography: json["biography"] == null ? null : json["biography"],
        popularity:
            json["popularity"] == null ? null : json["popularity"].toDouble(),
        placeOfBirth:
            json["place_of_birth"] == null ? null : json["place_of_birth"],
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
        adult: json["adult"] == null ? null : json["adult"],
        imdbId: json["imdb_id"] == null ? null : json["imdb_id"],
        homepage: json["homepage"],
        movieCredits: json['movie_credits'] == null
            ? null
            : Credits.fromJson(json['movie_credits']),
        tvCredits: json['tv_credits'] == null
            ? null
            : Credits.fromJson(json['tv_credits']),
        images: json['images'] == null
            ? null
            : PersonImages.fromJson(json['images']),
      );
}
