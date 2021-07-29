import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:moviedb_flutter/src/bloc/seriebloc/serie_bloc.dart';
import 'package:moviedb_flutter/src/model/serie.dart';
import 'package:moviedb_flutter/src/views/components/delay.dart';
import 'package:moviedb_flutter/src/views/components/loading_screen.dart';
import 'package:moviedb_flutter/src/views/serie/serie_detail_screen.dart';
import 'package:palette_generator/palette_generator.dart';

import '../components/error_message_screen.dart';

class SerieOnAir extends StatefulWidget {
  const SerieOnAir({Key? key}) : super(key: key);

  @override
  _SerieOnAirState createState() => _SerieOnAirState();
}

class _SerieOnAirState extends State<SerieOnAir> {
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SerieBloc()..add(SerieEventOnAir(1)),
      child: _widgetNowPlaying(context),
    );
  }

  _loadMore(BuildContext context, SerieLoaded state) async {
    if (state.serieResponse.page == page) {
      page++;
      BlocProvider.of<SerieBloc>(context)..add(SerieEventOnAir(page));

      await Future.delayed(delay);
      setState(() {});
    }
  }

  _widgetNowPlaying(BuildContext context) {
    return BlocBuilder<SerieBloc, SerieState>(
      builder: (context, state) {
        if (state is SerieLoading) {
          return LoadingScreen();
        } else if (state is SerieLoaded) {
          return LazyLoadScrollView(
            onEndOfPage: () => _loadMore(context, state),
            child: OrientationBuilder(
              builder: (context, orientation) {
                Color color = Colors.grey.shade200;
                return GridView.builder(
                  //   physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(2.0),
                  itemCount: state.serieResponse.results?.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    Serie serie =
                        state.serieResponse.results?[index] ?? Serie();
                    return GestureDetector(
                      onTap: () async {
                        late PaletteGenerator paletteGenerator;
                        if (serie.posterString('w200') != null) {
                          paletteGenerator =
                              await PaletteGenerator.fromImageProvider(
                                  CachedNetworkImageProvider(
                                      serie.posterString('w200')!));
                        } else {
                          paletteGenerator =
                              await PaletteGenerator.fromImageProvider(
                                  AssetImage(
                                      'assets/images/img_not_found.jpg'));
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SerieDetailScreen(
                              serieId: serie.id ?? 0,
                              paletteColor: paletteGenerator,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            imageUrl: serie.posterString('w200') ?? '',
                            imageBuilder: (context, imageProvider) {
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
                            placeholder: (context, url) => Platform.isAndroid
                                ? Container(
                                    width: 180,
                                    height: 250,
                                    color: color,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  )
                                : Container(
                                    width: 180,
                                    height: 250,
                                    color: color,
                                    child: CupertinoActivityIndicator(),
                                  ),
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              width: 180,
                              height: 250,
                              color: color,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo,
                                    color: Colors.black45,
                                    size: 80,
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.black54,
                                    ),
                                    child: Text(
                                      (serie.name ?? ''),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        fontFamily: 'muli',
                                      ),
                                      //  overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        } else if (state is SerieError) {
          return ErrorMessage(
            message: state.message,
            onTap: () {
              context.read<SerieBloc>().add(SerieEventOnAir(page));
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
