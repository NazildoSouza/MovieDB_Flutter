// import 'package:dio/dio.dart';
// import 'package:moviedb_flutter/src/model/credits.dart';
// import 'package:moviedb_flutter/src/model/genres.dart';
// import 'package:moviedb_flutter/src/model/images.dart';
// import 'package:moviedb_flutter/src/model/movie.dart';
// import 'package:moviedb_flutter/src/model/movie_detail.dart';
// import 'package:moviedb_flutter/src/model/person.dart';
// import 'package:moviedb_flutter/src/service/api_options.dart';

// class ApiService {
//   final Dio _dio = Dio(kDioOptions);

//   //https://api.themoviedb.org/3/movie/now_playing?api_key=60826b467c91b5b94f65049ead0cafa6&page=1&language=pt-BR

//   // final String baseUrl = 'https://api.themoviedb.org/3';
//   // final String apiKey = 'api_key=60826b467c91b5b94f65049ead0cafa6';

//   Future<List<Movie>> getNowPlayingMovie() async {
//     try {
//       final response = await _dio.get('/movie/popular?page=1');
//       var movies = response.data['results'] as List;
//       List<Movie> movieList = movies.map((m) => Movie.fromJson(m)).toList();
//       return movieList;
//     } catch (error, stacktrace) {
//       throw Exception(
//           'Exception accoured: $error with stacktrace: $stacktrace');
//     }
//   }

//   Future<List<Movie>> getMovieByGenre(int movieId) async {
//     try {
//       final url = '/discover/movie?with_genres=$movieId';
//       final response = await _dio.get(url);
//       var movies = response.data['results'] as List;
//       List<Movie> movieList = movies.map((m) => Movie.fromJson(m)).toList();
//       return movieList;
//     } catch (error, stacktrace) {
//       throw Exception(
//           'Exception accoured: $error with stacktrace: $stacktrace');
//     }
//   }

//   Future<List<Genre>> getGenreList() async {
//     try {
//       final response = await _dio.get('/genre/movie/list');
//       var genres = response.data['genres'] as List;
//       List<Genre> genreList = genres.map((g) => Genre.fromJson(g)).toList();
//       return genreList;
//     } catch (error, stacktrace) {
//       throw Exception(
//           'Exception accoured: $error with stacktrace: $stacktrace');
//     }
//   }

//   Future<List<Person>> getTrendingPerson() async {
//     try {
//       final response = await _dio.get('/trending/person/week');
//       var persons = response.data['results'] as List;
//       List<Person> personList = persons.map((p) => Person.fromJson(p)).toList();
//       return personList;
//     } catch (error, stacktrace) {
//       throw Exception(
//           'Exception accoured: $error with stacktrace: $stacktrace');
//     }
//   }

//   Future<MovieDetail> getMovieDetail(int movieId) async {
//     var options = baseOptions(
//         params: {'language': 'pt-BR', 'append_to_response': 'videos,credits'});
//     final Dio dio2 = Dio(options);
//     try {
//       final response = await dio2.get('/movie/$movieId');
//       MovieDetail movieDetail = MovieDetail.fromJson(response.data);

//       // var idVideo = await getYoutubeId(movieId);

//       // movieDetail.trailerId = idVideo != null ? idVideo : null;

//       movieDetail.movieImage = await getMovieImage(movieId);

//       // movieDetail.castList = await getCastList(movieId);

//       return movieDetail;
//     } catch (error, stacktrace) {
//       throw Exception(
//           'Exception accoured: $error with stacktrace: $stacktrace');
//     }
//   }

//   Future<String?> getYoutubeId(int id) async {
//     var options = baseOptions();
//     final Dio dio2 = Dio(options);
//     try {
//       final response = await dio2.get('/movie/$id/videos');
//       var youtubeId = response.data['results'][0]['key'];
//       return youtubeId;
//     } catch (error, stacktrace) {
//       throw Exception(
//           'Exception accoured: $error with stacktrace: $stacktrace');
//     }
//   }

//   Future<ImagesResponse?> getMovieImage(int movieId) async {
//     var options = baseOptions(params: {
//       'language': 'pt-BR',
//       'include_image_language': 'pt,null',
//     });
//     final Dio dio2 = Dio(options);
//     try {
//       var url = '/movie/$movieId/images';
//       final response = await dio2.get(url);
//       return ImagesResponse.fromJson(response.data);
//     } catch (error, stacktrace) {
//       throw Exception(
//           'Exception accoured: $error with stacktrace: $stacktrace');
//     }
//   }

//   Future<List<Cast>?> getCastList(int movieId) async {
//     var options = baseOptions(params: {'language': 'pt-BR'});
//     final Dio dio2 = Dio(options);
//     try {
//       final response = await dio2.get('/movie/$movieId/credits');
//       var list = response.data['cast'] as List;
//       List<Cast> castList = list
//           .map((c) => Cast(
//               name: c['name'],
//               profilePath: c['profile_path'],
//               character: c['character']))
//           .toList();
//       return castList;
//     } catch (error, stacktrace) {
//       throw Exception(
//           'Exception accoured: $error with stacktrace: $stacktrace');
//     }
//   }
// }
