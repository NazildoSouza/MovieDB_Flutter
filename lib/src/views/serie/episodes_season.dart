import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_flutter/src/bloc/episodeimagesbloc/episodeimages_bloc.dart';
import 'package:moviedb_flutter/src/bloc/seriedetailbloc/serie_detail_bloc.dart';
import 'package:moviedb_flutter/src/extensions/extension.dart';
import 'package:moviedb_flutter/src/model/credits.dart';
import 'package:moviedb_flutter/src/model/images.dart';
import 'package:moviedb_flutter/src/model/season.dart';
import 'package:moviedb_flutter/src/views/components/error_message_screen.dart';
import 'package:moviedb_flutter/src/views/components/galery.dart';
import 'package:moviedb_flutter/src/views/components/loading_screen.dart';
import 'package:moviedb_flutter/src/views/person/person_detail_screen.dart';
import 'package:palette_generator/palette_generator.dart';

class EpisodesSeason extends StatelessWidget {
  const EpisodesSeason(
      {Key? key,
      required this.serieId,
      required this.seasonNumber,
      required this.seasonName,
      required this.paletteColor})
      : super(key: key);

  final int serieId;
  final int seasonNumber;
  final String seasonName;
  final PaletteGenerator paletteColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(seasonName),
        elevation: 0,
      ),
      body: BlocProvider(
        create: (_) => SerieDetailBloc()
          ..add(SeasonDetailEventStated(serieId, seasonNumber)),
        child: _widgetNowPlaying(context),
      ),
    );
  }

  _widgetNowPlaying(BuildContext context) {
    var palette = paletteColor.mutedColor ?? paletteColor.dominantColor;
    return BlocBuilder<SerieDetailBloc, SerieDetailState>(
        builder: (context, state) {
      if (state is SeasonDetailLoading) {
        return LoadingScreen();
      } else if (state is SeasonDetailLoaded) {
        List<Episode> episodes = state.seasonResponse.episodes ?? <Episode>[];

        return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              return EpisodeView(
                serieId: serieId,
                seasonNumber: seasonNumber,
                episode: episodes[index],
                palette: palette,
              );
            });
      } else if (state is SeasonDetailError) {
        return ErrorMessage(
          message: state.message,
          onTap: () {
            context
                .read<SerieDetailBloc>()
                .add(SeasonDetailEventStated(serieId, seasonNumber));
          },
        );
      } else {
        return Container();
      }
    });
  }
}

class EpisodeView extends StatelessWidget {
  const EpisodeView(
      {Key? key,
      required this.serieId,
      required this.seasonNumber,
      required this.episode,
      this.palette})
      : super(key: key);

  final int serieId;
  final int seasonNumber;
  final Episode episode;
  final PaletteColor? palette;

  @override
  Widget build(BuildContext context) {
    if (episode.images == null) {
      return BlocProvider<EpisodeimagesBloc>(
        create: (_) => EpisodeimagesBloc()
          ..add(EpisodeImagesEventStated(serieId, seasonNumber, episode)),
        child: _buildEpisode(context),
      );
    } else {
      return _buildEpisode(context);
    }
  }

  Widget _buildEpisode(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              margin: EdgeInsets.all(0),
              elevation: 5,
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: episode.stillString('w500') ?? '',
                  height: MediaQuery.of(context).size.height / 4,
                  width: double.infinity,
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
                      size: 150,
                    ),
                  ),
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
                (episode.airDate?.formattedDate() ?? '--'),
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
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            ('${episode.episodeNumber ?? 0}') +
                ' - ' +
                (episode.name ?? '').toUpperCase(),
            // textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              //  color: Colors.black87,
              fontFamily: 'muli',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (episode.overview != null && episode.overview!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              (episode.overview ?? ''),
              style: TextStyle(fontFamily: 'muli'),
            ),
          ),
        if (episode.images == null)
          BlocBuilder<EpisodeimagesBloc, EpisodeimagesState>(
              builder: (context, state) {
            if (state is EpisodeImagesLoading) {
              return Container(height: 190, child: LoadingScreen());
            } else if (state is EpisodeImagesLoaded) {
              bool containImages = state.containImages;

              if (containImages &&
                  episode.images != null &&
                  episode.images!.length > 0) return _images(context);
              return Container();
            } else if (state is EpisodeImagesError) {
              return ErrorMessage(
                message: state.message,
                onTap: () {
                  context.read<EpisodeimagesBloc>().add(
                      EpisodeImagesEventStated(serieId, seasonNumber, episode));
                },
              );
            } else {
              return Container();
            }
          }),
        if (episode.images != null && episode.images!.length > 0)
          _images(context),
        if (episode.guestStars != null && episode.guestStars!.length > 0) ...[
          Divider(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Artistas Convidados'.toUpperCase(),
              style: Theme.of(context).textTheme.caption?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'muli',
                  ),
            ),
          ),
          Container(
            height: 130,
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => VerticalDivider(
                color: Colors.transparent,
                width: 5,
              ),
              itemCount: episode.guestStars!.length,
              itemBuilder: (context, index) {
                Cast cast = episode.guestStars![index];
                return GestureDetector(
                  onTap: () async {
                    late PaletteGenerator paletteGenerator;
                    if (cast.profileString('w200') != null) {
                      paletteGenerator =
                          await PaletteGenerator.fromImageProvider(
                              CachedNetworkImageProvider(
                                  cast.profileString('w200')!));
                    } else {
                      paletteGenerator =
                          await PaletteGenerator.fromImageProvider(
                              AssetImage('assets/images/img_not_found.jpg'));
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonDetail(
                          personId: cast.id!,
                          personName: cast.name ?? 'Sem Nome',
                          paletteColor: paletteGenerator,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    child: Column(
                      children: [
                        Card(
                          clipBehavior: Clip.antiAlias,
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: cast.profileString('w200') ?? '',
                              imageBuilder: (context, imageBuilder) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    image: DecorationImage(
                                      image: imageBuilder,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              placeholder: (context, url) => Platform.isAndroid
                                  ? Container(
                                      width: 80,
                                      height: 80,
                                      color: palette?.color,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        color: palette?.titleTextColor,
                                      )),
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      color: palette?.color,
                                      child: CupertinoActivityIndicator(),
                                    ),
                              errorWidget: (context, url, error) => Container(
                                color: palette?.color,
                                width: 80,
                                height: 80,
                                child: Icon(
                                  Icons.person,
                                  color: palette?.titleTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              (cast.name ?? '').toUpperCase(),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                //   color: Colors.black54,
                                fontSize: 10,
                                fontFamily: 'muli',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              (cast.character ?? '').toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                //   color: Colors.black54,
                                fontSize: 10,
                                fontFamily: 'muli',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        if (episode.crew != null && episode.crew!.length > 0) ...[
          Divider(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Equipe Técnica'.toUpperCase(),
              style: Theme.of(context).textTheme.caption?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'muli',
                  ),
            ),
          ),
          Container(
            height: 130,
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => VerticalDivider(
                color: Colors.transparent,
                width: 5,
              ),
              itemCount: episode.crew!.length,
              itemBuilder: (context, index) {
                Cast cast = episode.crew![index];
                return GestureDetector(
                  onTap: () async {
                    late PaletteGenerator paletteGenerator;
                    if (cast.profileString('w200') != null) {
                      paletteGenerator =
                          await PaletteGenerator.fromImageProvider(
                              CachedNetworkImageProvider(
                                  cast.profileString('w200')!));
                    } else {
                      paletteGenerator =
                          await PaletteGenerator.fromImageProvider(
                              AssetImage('assets/images/img_not_found.jpg'));
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonDetail(
                          personId: cast.id!,
                          personName: cast.name ?? 'Sem Nome',
                          paletteColor: paletteGenerator,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    child: Column(
                      children: [
                        Card(
                          clipBehavior: Clip.antiAlias,
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: cast.profileString('w200') ?? '',
                              imageBuilder: (context, imageBuilder) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    image: DecorationImage(
                                      image: imageBuilder,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              placeholder: (context, url) => Platform.isAndroid
                                  ? Container(
                                      width: 80,
                                      height: 80,
                                      color: palette?.color,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        color: palette?.titleTextColor,
                                      )),
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      color: palette?.color,
                                      child: CupertinoActivityIndicator(),
                                    ),
                              errorWidget: (context, url, error) => Container(
                                color: palette?.color,
                                width: 80,
                                height: 80,
                                child: Icon(
                                  Icons.person,
                                  color: palette?.titleTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              (cast.name ?? '').toUpperCase(),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                //     color: Colors.black54,
                                fontSize: 10,
                                fontFamily: 'muli',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              (cast.job ?? '').toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                //     color: Colors.black54,
                                fontSize: 10,
                                fontFamily: 'muli',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        Divider(),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  Widget _images(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Imagens'.toUpperCase(),
            style: Theme.of(context).textTheme.caption?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'muli',
                ),
          ),
        ),
        Container(
          height: 155,
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            separatorBuilder: (context, index) => VerticalDivider(
              color: Colors.transparent,
              width: 5,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: episode.images!.length,
            itemBuilder: (context, index) {
              Screenshot image = episode.images![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GalleryPhotoViewWrapper(
                        galleryItems: episode.images!,
                        backgroundDecoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        initialIndex: index,
                        // scrollDirection: verticalGallery
                        //     ? Axis.vertical
                        //     : Axis.horizontal,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: image.filePath!,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 3,
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      //  borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: image.imageString('original') ?? '',
                        placeholder: (context, url) => Platform.isAndroid
                            ? Container(
                                width: 255,
                                height: 155,
                                color: palette?.color,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: palette?.titleTextColor,
                                )),
                              )
                            : Container(
                                width: 255,
                                height: 155,
                                color: palette?.color,
                                child: CupertinoActivityIndicator(),
                              ),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: palette?.color,
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.photo,
                            color: palette?.titleTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
