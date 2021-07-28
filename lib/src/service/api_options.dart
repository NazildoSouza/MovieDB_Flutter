import 'package:dio/dio.dart';

const kBaseUrl = 'https://api.themoviedb.org/3';
const kApiKey =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MDgyNmI0NjdjOTFiNWI5NGY2NTA0OWVhZDBjYWZhNiIsInN1YiI6IjVlZmZhNDE5YTI4NGViMDAzNjkyZWFmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4Yx2khSqqErkHPvyr1KlOImXHHkAys71WhLGAseCqIc';

const kServerError = 'Failed to connect to the server. Try again later.';
final kDioOptions = BaseOptions(
  baseUrl: kBaseUrl,
  connectTimeout: 5000,
  receiveTimeout: 3000,
  queryParameters: {
    'language': 'pt-BR',
  },
  contentType: 'application/json;charset=utf-8',
  headers: {'Authorization': 'Bearer $kApiKey'},
);

final kDioOptionsMovieDetail = BaseOptions(
  baseUrl: kBaseUrl,
  connectTimeout: 5000,
  receiveTimeout: 3000,
  queryParameters: {
    'language': 'pt-BR',
    'append_to_response': 'videos,credits,images'
  },
  contentType: 'application/json;charset=utf-8',
  headers: {'Authorization': 'Bearer $kApiKey'},
);

final kDioOptionsPesonDetail = BaseOptions(
  baseUrl: kBaseUrl,
  connectTimeout: 5000,
  receiveTimeout: 3000,
  queryParameters: {
    'language': 'pt-BR',
    'append_to_response': 'videos,movie_credits,tv_credits,images'
  },
  contentType: 'application/json;charset=utf-8',
  headers: {'Authorization': 'Bearer $kApiKey'},
);

final kDioOptionsMovieImages = BaseOptions(
  baseUrl: kBaseUrl,
  connectTimeout: 5000,
  receiveTimeout: 3000,
  queryParameters: {
    'language': 'pt-BR',
    'include_image_language': 'pt,null',
  },
  contentType: 'application/json;charset=utf-8',
  headers: {'Authorization': 'Bearer $kApiKey'},
);

BaseOptions kDioOptionsSearch([String query = '', int page = 1]) => BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: 5000,
      receiveTimeout: 3000,
      queryParameters: {
        "language": "pt-BR",
        "include_adult": "true",
        "region": "BR",
        "query": query,
        "page": page,
      },
      contentType: 'application/json;charset=utf-8',
      headers: {'Authorization': 'Bearer $kApiKey'},
    );
