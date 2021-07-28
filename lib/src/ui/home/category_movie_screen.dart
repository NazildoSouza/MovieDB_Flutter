import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:moviedb_flutter/src/bloc/genrebloc/genre_bloc.dart';
import 'package:moviedb_flutter/src/bloc/moviebloc/movie_bloc.dart';
import 'package:moviedb_flutter/src/circle_progress/circle_progress_screen.dart';
import 'package:moviedb_flutter/src/model/genres.dart';
import 'package:moviedb_flutter/src/model/movie.dart';
import 'package:moviedb_flutter/src/ui/components/delay.dart';
import 'package:moviedb_flutter/src/ui/components/error_message_screen.dart';
import 'package:moviedb_flutter/src/ui/components/loading_screen.dart';
import 'package:moviedb_flutter/src/ui/movie/movie_detail_screen.dart';
import 'package:palette_generator/palette_generator.dart';

class MovieCategories extends StatefulWidget {
  MovieCategories({Key? key, this.selectedGenre = 28}) : super(key: key);

  final int selectedGenre;

  @override
  _MovieCategoriesState createState() => _MovieCategoriesState();
}

class _MovieCategoriesState extends State<MovieCategories> {
  late int selectedGenre;
  int page = 1;

  @override
  void initState() {
    super.initState();
    selectedGenre = widget.selectedGenre;
  }

  _loadMore(BuildContext context, MovieLoaded state) async {
    if (state.movieResponse.page == page) {
      page++;

      BlocProvider.of<MovieBloc>(context)
        ..add(MovieEventGenre(selectedGenre, page));
      await Future.delayed(delay);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GenreBloc>(
          create: (_) => GenreBloc()..add(GenreMovieEventStarted()),
        ),
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()..add(MovieEventGenre(selectedGenre, page)),
        ),
      ],
      child: _buildGenre(context),
    );
  }

  Widget _buildGenre(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<GenreBloc, GenreState>(
          builder: (context, state) {
            if (state is GenreLoading) {
              return LoadingScreen();
            } else if (state is GenreLoaded) {
              List<Genre> genres = state.genreList;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Text(
                        'Filmes'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          //  color: Colors.black87,
                          fontFamily: 'muli',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      height: 45,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        separatorBuilder: (BuildContext context, int index) =>
                            VerticalDivider(
                          color: Colors.transparent,
                          width: 5,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: genres.length,
                        itemBuilder: (context, index) {
                          Genre genre = genres[index];
                          return Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (selectedGenre != (genre.id ?? 0)) {
                                    setState(() {
                                      selectedGenre = genre.id!;
                                      page = 1;
                                      context.read<MovieBloc>().add(
                                          MovieEventGenre(selectedGenre, page));
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black45,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                    color: (genre.id == selectedGenre)
                                        ? Theme.of(context).buttonColor
                                        : Theme.of(context).cardColor,
                                  ),
                                  child: Text(
                                    (genre.name ?? '').toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: (genre.id == selectedGenre)
                                          ? Theme.of(context).selectedRowColor
                                          : Theme.of(context).hintColor,
                                      fontFamily: 'muli',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is GenreError) {
              return ErrorMessage(
                message: state.message,
                onTap: () {
                  context.read<GenreBloc>().add(GenreMovieEventStarted());
                },
              );
            } else {
              return Container();
            }
          },
        ),
        SizedBox(
          height: 20,
        ),
        BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return Container(height: 310, child: LoadingScreen());
            } else if (state is MovieLoaded) {
              List<Movie> movieList = state.movieResponse.results ?? <Movie>[];

              return Container(
                height: 310,
                child: LazyLoadScrollView(
                  //  isLoading: true,
                  // scrollOffset: 50,
                  scrollDirection: Axis.horizontal,
                  onEndOfPage: () => _loadMore(context, state),
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    separatorBuilder: (context, index) => VerticalDivider(
                      color: Colors.transparent,
                      width: 15,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: movieList.length,
                    itemBuilder: (context, index) {
                      Movie movie = movieList[index];
                      Color color = Colors.grey.shade200;
                      return Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  late PaletteGenerator paletteGenerator;
                                  if (movie.posterString('w200') != null) {
                                    paletteGenerator = await PaletteGenerator
                                        .fromImageProvider(
                                            CachedNetworkImageProvider(
                                                movie.posterString('w200')!));
                                  } else {
                                    paletteGenerator = await PaletteGenerator
                                        .fromImageProvider(AssetImage(
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
                                  clipBehavior: Clip.none,
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    Card(
                                      margin: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 5,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        clipBehavior: Clip.antiAlias,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              movie.posterString('w200') ?? '',
                                          imageBuilder:
                                              (context, imageProvider) {
                                            return Container(
                                              width: 180,
                                              height: 250,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            );
                                          },
                                          placeholder: (context, url) =>
                                              Platform.isAndroid
                                                  ? Container(
                                                      width: 180,
                                                      height: 250,
                                                      color: color,
                                                      child: Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                    )
                                                  : Container(
                                                      width: 180,
                                                      height: 250,
                                                      color: color,
                                                      child:
                                                          CupertinoActivityIndicator(),
                                                    ),
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            width: 180,
                                            height: 250,
                                            color: color,
                                            child: Icon(
                                              Icons.photo,
                                              color: Colors.black45,
                                              size: 150,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -18,
                                      width: 60,
                                      height: 60,
                                      child: RadialChart(
                                          voteAverage: movie.voteAverage ?? 0),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 180,
                                child: Text(
                                  (movie.title ?? '').toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    //   color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'muli',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            } else if (state is MovieError) {
              return ErrorMessage(
                message: state.message,
                onTap: () {
                  context
                      .read<MovieBloc>()
                      .add(MovieEventGenre(selectedGenre, page));
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
