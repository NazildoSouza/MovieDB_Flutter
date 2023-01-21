// To parse this JSON data, do
//
//     final genre = genreFromJson(jsonString);

import 'dart:convert';

GenresResponse genreFromJson(String str) =>
    GenresResponse.fromJson(json.decode(str));

class GenresResponse {
  GenresResponse({
    this.genres,
  });

  List<Genre>? genres;

  factory GenresResponse.fromJson(Map<String, dynamic> json) => GenresResponse(
        genres: json["genres"] == null
            ? null
            : List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
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
