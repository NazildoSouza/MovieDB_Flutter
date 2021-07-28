// To parse this JSON data, do
//
//     final videosResponse = videosResponseFromJson(jsonString);

import 'dart:convert';

VideosResponse videosResponseFromJson(String str) =>
    VideosResponse.fromJson(json.decode(str));

class VideosResponse {
  VideosResponse({
    this.id,
    this.results,
  });

  int? id;
  List<Video>? results;

  factory VideosResponse.fromJson(Map<String, dynamic> json) => VideosResponse(
        id: json["id"] == null ? null : json["id"],
        results: json["results"] == null
            ? null
            : List<Video>.from(json["results"].map((x) => Video.fromJson(x))),
      );
}

class Video {
  Video({
    this.id,
    this.iso6391,
    this.iso31661,
    this.key,
    this.name,
    this.site,
    this.size,
    this.type,
  });

  String? id;
  String? iso6391;
  String? iso31661;
  String? key;
  String? name;
  String? site;
  int? size;
  String? type;

  String? get youtubeURL {
    if (site != 'YouTube') return null;
    return 'https://www.youtube.com/embed/$key';
  }

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["id"] == null ? null : json["id"],
        iso6391: json["iso_639_1"] == null ? null : json["iso_639_1"],
        iso31661: json["iso_3166_1"] == null ? null : json["iso_3166_1"],
        key: json["key"] == null ? null : json["key"],
        name: json["name"] == null ? null : json["name"],
        site: json["site"] == null ? null : json["site"],
        size: json["size"] == null ? null : json["size"],
        type: json["type"] == null ? null : json["type"],
      );
}
