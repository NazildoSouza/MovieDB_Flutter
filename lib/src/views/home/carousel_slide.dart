import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_flutter/src/bloc/moviebloc/movie_bloc.dart';
import 'package:moviedb_flutter/src/model/movie.dart';
import 'package:moviedb_flutter/src/views/components/error_message_screen.dart';
import 'package:moviedb_flutter/src/views/components/loading_screen.dart';
import 'package:moviedb_flutter/src/views/movie/movie_detail_screen.dart';
import 'package:palette_generator/palette_generator.dart';

class CarouselSlideMovie extends StatelessWidget {
  const CarouselSlideMovie({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return Container(height: 310, child: LoadingScreen());
        } else if (state is MovieLoaded) {
          List<Movie> movies = state.movieResponse.results ?? <Movie>[];
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Destaques'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      // color: Colors.black87,
                      fontFamily: 'muli',
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: CarouselSlider.builder(
                    itemCount: movies.length,
                    itemBuilder: (BuildContext context, int index, int i) {
                      Movie movie = movies[index];
                      // Color color = Colors.accents[
                      //     Random().nextInt(Colors.accents.length)];
                      Color color = Colors.grey.shade200;
                      return InkWell(
                        onTap: () async {
                          late PaletteGenerator paletteGenerator;
                          if (movie.posterString('w500') != null) {
                            paletteGenerator =
                                await PaletteGenerator.fromImageProvider(
                                    CachedNetworkImageProvider(
                                        movie.posterString('w500')!));
                          } else {
                            paletteGenerator =
                                await PaletteGenerator.fromImageProvider(
                                    AssetImage(
                                        'assets/images/img_not_found.jpg'));
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(
                                movieId: movie.id ?? 0,
                                paletteColor: paletteGenerator,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                              child: ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      movie.backdropString('original') ?? '',
                                  height: MediaQuery.sizeOf(context).height,
                                  width: MediaQuery.sizeOf(context).width,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => kIsWeb ||
                                          Platform.isAndroid
                                      ? Container(
                                          color: color,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        )
                                      : Container(
                                          color: color,
                                          child: CupertinoActivityIndicator(),
                                        ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: color,
                                    child: Icon(
                                      Icons.photo,
                                      color: Colors.black45,
                                      size: 150,
                                    ),
                                  ),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(15),
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black54,
                              ),
                              child: Text(
                                (movie.title ?? ''),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontFamily: 'muli',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      enableInfiniteScroll: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      pauseAutoPlayOnTouch: true,
                      enlargeCenterPage: true,
                      aspectRatio:
                          ((size.width) / (size.height / 2)).clamp(1.7, 2.8),
                      autoPlay: true,
                      viewportFraction:
                          (size.height / size.width).clamp(0.5, 0.8),
                    ),
                  ),
                ),
              ]);
        } else if (state is MovieError) {
          return ErrorMessage(
            message: state.message,
            onTap: () {
              context
                  .read<MovieBloc>()
                  .add(MovieEventStarted(endPoint: 'now_playing', page: 1));
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
