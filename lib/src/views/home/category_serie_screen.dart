import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:moviedb_flutter/src/bloc/genrebloc/genre_bloc.dart';
import 'package:moviedb_flutter/src/bloc/seriebloc/serie_bloc.dart';
import 'package:moviedb_flutter/src/circle_progress/circle_progress_screen.dart';
import 'package:moviedb_flutter/src/model/genres.dart';
import 'package:moviedb_flutter/src/model/serie.dart';
import 'package:moviedb_flutter/src/views/components/delay.dart';
import 'package:moviedb_flutter/src/views/components/error_message_screen.dart';
import 'package:moviedb_flutter/src/views/components/loading_screen.dart';
import 'package:moviedb_flutter/src/views/serie/serie_detail_screen.dart';
import 'package:palette_generator/palette_generator.dart';

class SerieCategories extends StatefulWidget {
  SerieCategories({Key? key, this.selectedGenre = 10759}) : super(key: key);

  final int selectedGenre;

  @override
  _SerieCategoriesState createState() => _SerieCategoriesState();
}

class _SerieCategoriesState extends State<SerieCategories> {
  late int selectedGenre;
  int page = 1;

  @override
  void initState() {
    super.initState();
    selectedGenre = widget.selectedGenre;
  }

  _loadMore(BuildContext context, SerieLoaded state) async {
    if (state.serieResponse.page == page) {
      page++;

      BlocProvider.of<SerieBloc>(context)
        ..add(SerieEventGenre(selectedGenre, page));
      await Future.delayed(delay);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GenreBloc>(
          create: (_) => GenreBloc()..add(GenreSerieEventStarted()),
        ),
        BlocProvider<SerieBloc>(
          create: (_) => SerieBloc()..add(SerieEventGenre(selectedGenre, page)),
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
                        'Séries'.toUpperCase(),
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
                              InkWell(
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  if (selectedGenre != (genre.id ?? 0)) {
                                    setState(() {
                                      selectedGenre = genre.id!;
                                      page = 1;
                                      context.read<SerieBloc>().add(
                                          SerieEventGenre(selectedGenre, page));
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
                                        ? Theme.of(context)
                                            .colorScheme
                                            .surfaceTint
                                        : Theme.of(context).cardColor,
                                  ),
                                  child: Text(
                                    (genre.name ?? '').toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: (genre.id == selectedGenre)
                                          ? Colors.white
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
                  context.read<GenreBloc>().add(GenreSerieEventStarted());
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
        BlocBuilder<SerieBloc, SerieState>(
          builder: (context, state) {
            if (state is SerieLoading) {
              return Container(height: 310, child: LoadingScreen());
            } else if (state is SerieLoaded) {
              List<Serie> serieList = state.serieResponse.results ?? <Serie>[];

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
                    itemCount: serieList.length,
                    itemBuilder: (context, index) {
                      Serie serie = serieList[index];
                      Color color = Colors.grey.shade200;
                      return CardSerie(serie: serie, color: color);
                    },
                  ),
                ),
              );
            } else if (state is SerieError) {
              return ErrorMessage(
                message: state.message,
                onTap: () {
                  context
                      .read<SerieBloc>()
                      .add(SerieEventGenre(selectedGenre, page));
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

class CardSerie extends StatefulWidget {
  const CardSerie({
    super.key,
    required this.serie,
    required this.color,
  });

  final Serie serie;
  final Color color;

  @override
  State<CardSerie> createState() => _CardSerieState();
}

class _CardSerieState extends State<CardSerie> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onHover: !kIsWeb
          ? null
          : (value) => setState(() {
                isHovering = value;
              }),
      onTap: () async {
        late PaletteGenerator paletteGenerator;
        if (widget.serie.posterString('w500') != null) {
          paletteGenerator = await PaletteGenerator.fromImageProvider(
              CachedNetworkImageProvider(widget.serie.posterString('w500')!));
        } else {
          paletteGenerator = await PaletteGenerator.fromImageProvider(
              AssetImage('assets/images/img_not_found.jpg'));
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SerieDetailScreen(
                serieId: widget.serie.id ?? 0, paletteColor: paletteGenerator),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
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
                    imageUrl: widget.serie.posterString('w500') ?? '',
                    imageBuilder: (context, imageProvider) {
                      return AnimatedContainer(
                        alignment: Alignment.center,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        transform: !kIsWeb ? null : Matrix4.identity()
                          ?..scale(
                            isHovering ? 1.05 : 1,
                          ),
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
                    placeholder: (context, url) => kIsWeb || Platform.isAndroid
                        ? Container(
                            width: 180,
                            height: 250,
                            color: widget.color,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Container(
                            width: 180,
                            height: 250,
                            color: widget.color,
                            child: CupertinoActivityIndicator(),
                          ),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      width: 180,
                      height: 250,
                      color: widget.color,
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
                child: RadialChart(voteAverage: widget.serie.voteAverage ?? 0),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 180,
            child: Text(
              (widget.serie.name ?? '').toUpperCase(),
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
    );
  }
}
