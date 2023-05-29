import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_flutter/src/bloc/moviebloc/movie_bloc.dart';
import 'package:moviedb_flutter/src/bloc/personbloc/person_bloc.dart';
import 'package:moviedb_flutter/src/views/home/carousel_slide.dart';
import 'package:moviedb_flutter/src/views/home/category_movie_screen.dart';
import 'package:moviedb_flutter/src/views/home/category_serie_screen.dart';
import 'package:moviedb_flutter/src/views/home/person_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()
            ..add(MovieEventStarted(endPoint: "now_playing", page: 1)),
        ),
        BlocProvider<PersonBloc>(
          create: (_) => PersonBloc()..add(PersonEventStated()),
        ),
      ],
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: SafeArea(
        child: Column(
          children: [
            CarouselSlideMovie(),
            MovieCategories(),
            SerieCategories(),
            PersonList(),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
