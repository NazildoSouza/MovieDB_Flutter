import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviedb_flutter/src/extensions/extension.dart';
import 'package:moviedb_flutter/src/model/serie_detail.dart';
import 'package:moviedb_flutter/src/views/serie/episodes_season.dart';
import 'package:palette_generator/palette_generator.dart';

class SerieSeasons extends StatelessWidget {
  const SerieSeasons({Key? key, required this.serie, this.palette})
      : super(key: key);

  final SerieDetail serie;
  final PaletteColor? palette;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serie.name ?? 'Sem Nome'),
        elevation: 0,
      ),
      body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: serie.seasons?.length ?? 0,
          itemBuilder: (context, index) {
            return _buildSeason(context, (serie.seasons?[index] ?? Season()));
          }),
    );
  }

  _buildSeason(BuildContext context, Season season) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              late PaletteGenerator paletteGenerator;
              if (season.posterString('w200') != null) {
                paletteGenerator = await PaletteGenerator.fromImageProvider(
                    CachedNetworkImageProvider(
                        season.posterString('w200') ?? ''));
              } else {
                paletteGenerator = await PaletteGenerator.fromImageProvider(
                    AssetImage('assets/images/img_not_found.jpg'));
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EpisodesSeason(
                    serieId: serie.id ?? 0,
                    seasonNumber: season.seasonNumber ?? 0,
                    seasonName: season.name ?? 'Sem Nome',
                    paletteColor: paletteGenerator,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 120,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 1,
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: season.posterString('w200') ?? '',
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
                      Text(
                        season.name ?? '',
                        style: TextStyle(
                            fontFamily: 'muli', fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${season.airDate?.formattedDatePerson() ?? '--'} | ${season.episodeCount} episódios',
                        style: Theme.of(context).textTheme.subtitle2?.copyWith(
                              fontFamily: 'muli',
                            ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (season.overview != null &&
                          season.overview!.isNotEmpty)
                        Text(
                          season.overview!,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (serie.seasons?.last != season) Divider(),
        ],
      ),
    );
  }
}
