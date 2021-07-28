// To parse this JSON data, do
//
//     final movieImage = movieImageFromJson(jsonString);

import 'dart:convert';

ImagesResponse movieImageFromJson(String str) =>
    ImagesResponse.fromJson(json.decode(str));

class ImagesResponse {
  ImagesResponse({
    this.id,
    this.backdrops,
    this.posters,
  });

  int? id;
  List<Screenshot>? backdrops;
  List<Screenshot>? posters;

  factory ImagesResponse.fromJson(Map<String, dynamic> json) => ImagesResponse(
        id: json["id"] == null ? null : json["id"],
        backdrops: json["backdrops"] == null
            ? null
            : List<Screenshot>.from(
                json["backdrops"].map((x) => Screenshot.fromJson(x))),
        posters: json["posters"] == null
            ? null
            : List<Screenshot>.from(
                json["posters"].map((x) => Screenshot.fromJson(x))),
      );
}

class Screenshot {
  Screenshot({
    this.aspectRatio,
    this.filePath,
    this.height,
    this.iso6391,
    this.voteAverage,
    this.voteCount,
    this.width,
  });

  double? aspectRatio;
  String? filePath;
  int? height;
  String? iso6391;
  double? voteAverage;
  int? voteCount;
  int? width;

  String? imageString(String value) =>
      filePath == null ? null : 'https://image.tmdb.org/t/p/$value${filePath!}';

  factory Screenshot.fromJson(Map<String, dynamic> json) => Screenshot(
        aspectRatio: json["aspect_ratio"] == null
            ? null
            : json["aspect_ratio"].toDouble(),
        filePath: json["file_path"] == null ? null : json["file_path"],
        height: json["height"] == null ? null : json["height"],
        iso6391: json["iso_639_1"] == null ? null : json["iso_639_1"],
        voteAverage: json["vote_average"] == null ? null : json["vote_average"],
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
        width: json["width"] == null ? null : json["width"],
      );
}
