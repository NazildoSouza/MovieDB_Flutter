import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:moviedb_flutter/src/bloc/searchbloc/search_bloc.dart';
import 'package:moviedb_flutter/src/extensions/extension.dart';
import 'package:moviedb_flutter/src/model/search.dart';
import 'package:moviedb_flutter/src/ui/components/error_message_screen.dart';
import 'package:moviedb_flutter/src/ui/movie/movie_detail_screen.dart';
import 'package:moviedb_flutter/src/ui/person/person_detail_screen.dart';
import 'package:moviedb_flutter/src/ui/serie/serie_detail_screen.dart';
import 'package:palette_generator/palette_generator.dart';

import '../components/loading_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // return BlocProvider(
    //   create: (_) => SearchBloc()..add(SearchEventQuery('ma', 1)),
    //   child: _widgetSearch(context),
    // );
    return _widgetSearch(context);
  }

  _widgetSearch(BuildContext context) {
    final labelStyle = TextStyle(
      fontSize: 18,
    );
    final contentPadding = const EdgeInsets.fromLTRB(16, 10, 12, 10);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
          child: TextField(
            controller: _textEditingController,
            onChanged: (value) async {
              setState(() {});
              await Future.delayed(Duration(milliseconds: 700));
              if (value == _textEditingController.text) {
                context.read<SearchBloc>().add(SearchEventQuery(value, 1));
              }
            },
            autocorrect: false,
            decoration: InputDecoration(
              labelStyle: labelStyle,
              hintText: 'Busque por filme, série ou pessoa...',
              contentPadding: contentPadding,
              suffixIcon: _textEditingController.text != ''
                  ? IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _textEditingController.clear();

                        context.read<SearchBloc>().add(
                            SearchEventQuery(_textEditingController.text, 1));
                        _textEditingController.selection;
                        setState(() {});
                      })
                  : null,
            ),
          ),
        ),
        // Card(
        //   child: TextField(
        //     controller: _textEditingController,
        //     autocorrect: false,
        //     onChanged: (value) async {
        //       await Future.delayed(Duration(milliseconds: 700));
        //       if (value == _textEditingController.text)
        //         context.read<SearchBloc>().add(SearchEventQuery(value, 1));
        //     },
        //     decoration: InputDecoration(
        //       contentPadding: const EdgeInsets.symmetric(vertical: 15),
        //       border: InputBorder.none,
        //       suffixIcon: IconButton(
        //           icon: Icon(Icons.close),
        //           color: Colors.grey[700],
        //           onPressed: () {
        //             _textEditingController.clear();
        //             context
        //                 .read<SearchBloc>()
        //                 .add(SearchEventQuery(_textEditingController.text, 1));
        //           }),
        //     ),
        //     textInputAction: TextInputAction.search,
        //     autofocus: true,
        //   ),
        // ),
        Expanded(
          child: BlocBuilder<SearchBloc, SearchState>(
            bloc: BlocProvider.of<SearchBloc>(context),
            builder: (context, state) {
              if (state is SearchLoading) {
                return LoadingScreen();
              } else if (state is SearchLoaded) {
                SearchResponse searchResponse = state.searchResponse;

                return TabbarSearch(searchResponse: searchResponse);
              } else if (state is SearchQueryIsEmpty) {
                return Center(
                    child: Text(
                  state.message,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: Theme.of(context).hintColor),
                ));
              } else if (state is SearchError) {
                return ErrorMessage(message: state.message);
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }
}

class TabbarSearch extends StatefulWidget {
  TabbarSearch(
      {Key? key, required this.searchResponse, this.query, this.palette})
      : super(key: key);

  final SearchResponse searchResponse;
  final String? query;
  final PaletteColor? palette;

  @override
  _TabbarSearchState createState() => _TabbarSearchState();
}

class _TabbarSearchState extends State<TabbarSearch>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int page = 1;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: widget.searchResponse.tabLenght,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: BouncingScrollPhysics(),
      controller: _tabController,
      children: [
        if (widget.searchResponse.movies.length > 0)
          LazyLoadScrollView(
              onEndOfPage: () async {
                // if (widget.searchResponse.page == page) {
                //   page++;
                //   context
                //       .read<SearchBloc>()
                //       .add(SearchEventQuery(widget.query, page));

                //   // await Future.delayed(Duration(milliseconds: 600));
                // }
                // setState(() {});
              },
              child: ListSearch(
                titlePage: 'Filmes',
                result: widget.searchResponse.movies,
                palette: widget.palette,
              )),
        if (widget.searchResponse.series.length > 0)
          LazyLoadScrollView(
              onEndOfPage: () async {
                // if (widget.searchResponse.page == page) {
                //   page++;
                //   context
                //       .read<SearchBloc>()
                //       .add(SearchEventQuery(widget.query, page));
                //   // await Future.delayed(Duration(milliseconds: 600));
                //   setState(() {});
                // }
              },
              child: ListSearch(
                titlePage: 'Séries',
                result: widget.searchResponse.series,
                palette: widget.palette,
              )),
        if (widget.searchResponse.persons.length > 0)
          LazyLoadScrollView(
              onEndOfPage: () async {
                // if (widget.searchResponse.page == page) {
                //   page++;
                //   context
                //       .read<SearchBloc>()
                //       .add(SearchEventQuery(widget.query, page));
                //   // await Future.delayed(Duration(milliseconds: 600));
                //   setState(() {});
                // }
              },
              child: ListSearch(
                titlePage: 'Pessoas',
                result: widget.searchResponse.persons,
                palette: widget.palette,
              )),
      ],
    );
  }
}

class ListSearch extends StatelessWidget {
  ListSearch(
      {Key? key, required this.titlePage, required this.result, this.palette})
      : super(key: key);

  final String titlePage;
  final List<Search> result;
  final PaletteColor? palette;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: result.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result.first == result[index])
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    titlePage.toUpperCase(),
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'muli',
                        ),
                  ),
                ),
              _cardPerson(context, result[index]),
            ],
          );
        });
  }

  Widget _cardPerson(BuildContext context, Search search) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              late PaletteGenerator paletteGenerator;
              if (search.posterString('w200') != null ||
                  search.profileString('w200') != null) {
                paletteGenerator = await PaletteGenerator.fromImageProvider(
                    CachedNetworkImageProvider(search.profileString('w200') ??
                        search.posterString('w200') ??
                        ''));
              } else {
                paletteGenerator = await PaletteGenerator.fromImageProvider(
                    AssetImage('assets/images/img_not_found.jpg'));
              }
              if (search.mediaType == MediaType.MOVIE) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(
                        movieId: search.id ?? 0,
                        paletteColor: paletteGenerator),
                  ),
                );
              } else if (search.mediaType == MediaType.TV) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SerieDetailScreen(
                        serieId: search.id ?? 0,
                        paletteColor: paletteGenerator),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonDetail(
                        personId: search.id ?? 0,
                        personName: search.name ?? '',
                        paletteColor: paletteGenerator),
                  ),
                );
              }
            },
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 80,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 1,
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: search.posterString('w200') ??
                            search.profileString('w200') ??
                            '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Platform.isAndroid
                            ? Container(
                                color: palette?.color,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: palette?.titleTextColor,
                                )),
                              )
                            : Container(
                                color: palette?.color,
                                child: CupertinoActivityIndicator(),
                              ),
                        errorWidget: (context, url, error) => Container(
                          color: palette?.color,
                          child: Icon(
                            Icons.photo,
                            color: palette?.titleTextColor,
                            size: 25,
                          ),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (search.mediaType != MediaType.PERSON)
                        Text(search.releaseDate?.formattedDatePerson() ??
                            search.firstAirDate?.formattedDatePerson() ??
                            '--'),
                      Text(
                        search.title ?? search.name ?? '',
                        style: TextStyle(
                            fontFamily: 'muli', fontWeight: FontWeight.bold),
                      ),
                      if (search.mediaType != MediaType.PERSON &&
                          search.overview != null &&
                          search.overview!.isNotEmpty)
                        Text(
                          search.overview!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      if (search.mediaType == MediaType.PERSON)
                        Text(
                          search.atuou,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (result.last != search) Divider(),
        ],
      ),
    );
  }
}
