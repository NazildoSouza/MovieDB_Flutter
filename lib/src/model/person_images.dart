// To parse this JSON data, do
//
//     final personImages = personImagesFromJson(jsonString);

import 'dart:convert';

import 'package:moviedb_flutter/src/model/images.dart';

PersonImages personImagesFromJson(String str) =>
    PersonImages.fromJson(json.decode(str));

class PersonImages {
  PersonImages({
    this.id,
    this.profiles,
  });

  int? id;
  List<Screenshot>? profiles;

  factory PersonImages.fromJson(Map<String, dynamic> json) => PersonImages(
        id: json["id"] == null ? null : json["id"],
        profiles: json["profiles"] == null
            ? null
            : List<Screenshot>.from(
                json["profiles"].map((x) => Screenshot.fromJson(x))),
      );
}
