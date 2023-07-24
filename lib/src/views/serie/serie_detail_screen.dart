import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_flutter/src/bloc/seriedetailbloc/serie_detail_bloc.dart';
import 'package:moviedb_flutter/src/circle_progress/circle_progress_screen.dart';
import 'package:moviedb_flutter/src/model/credits.dart';
import 'package:moviedb_flutter/src/model/images.dart';
import 'package:moviedb_flutter/src/model/serie_detail.dart';
import 'package:moviedb_flutter/src/views/components/error_message_screen.dart';
import 'package:moviedb_flutter/src/views/components/galery.dart';
import 'package:moviedb_flutter/src/views/components/loading_screen.dart';
import 'package:moviedb_flutter/src/views/person/person_detail_screen.dart';
import 'package:moviedb_flutter/src/views/serie/series_seasons_screen.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher.dart';

class SerieDetailScreen extends StatelessWidget {
  const SerieDetailScreen(
      {Key? key, required this.serieId, required this.paletteColor})
      : super(key: key);

  final int serieId;
  final PaletteGenerator paletteColor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SerieDetailBloc()..add(SerieDetailEventStated(serieId)),
      child: Scaffold(
        body: _buildDetailBody(context),
      ),
    );
  }

  Widget _buildDetailBody(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    // Color color = Colors.accents[Random().nextInt(Colors.accents.length)];
    var palette = paletteColor.mutedColor ?? paletteColor.dominantColor;
    return BlocBuilder<SerieDetailBloc, SerieDetailState>(
      builder: (context, state) {
        if (state is SerieDetailLoading) {
          return LoadingScreen();
        } else if (state is SerieDetailLoaded) {
          SerieDetail serieDetail = state.detail;
          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                leading: Align(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12.withOpacity(0.05),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 0.0),
                          blurRadius: 15.0,
                          spreadRadius: 2.0,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white.withOpacity(0.5),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: Icon(
                              Icons.adaptive.arrow_back,
                              size: 26.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
                  ),
                ),
                expandedHeight:
                    size.width <= 700 ? size.height / 2.5 : size.height,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                  ],
                  background: CachedNetworkImage(
                    imageUrl: serieDetail.backdropString('original') ?? '',
                    height: MediaQuery.sizeOf(context).height,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => kIsWeb || Platform.isAndroid
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
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        (serieDetail.name ?? '').toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          //   color: Colors.black87,
                          fontFamily: 'muli',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(
                          serieDetail.genresString,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontFamily: 'muli',
                                  ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              serieDetail.dateString,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontFamily: 'muli',
                                  ),
                            ),
                            Text(
                              ' - ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontFamily: 'muli',
                                  ),
                            ),
                            Text(
                              serieDetail.timeString,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontFamily: 'muli',
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          serieDetail.statusString,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'muli', fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          child: RadialChart(
                              voteAverage: serieDetail.voteAverage ?? 0),
                        ),
                        Text(
                          'Avaliação dos Usuários',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontFamily: 'muli',
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (serieDetail.tagline != null &&
                      serieDetail.tagline!.isNotEmpty) ...[
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        serieDetail.tagline!,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.w200,
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                              fontFamily: 'muli',
                            ),
                      ),
                    ),
                  ],
                  if (serieDetail.overview != null &&
                      serieDetail.overview!.isNotEmpty) ...[
                    if (serieDetail.tagline == null ||
                        serieDetail.tagline!.isEmpty)
                      Divider(),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Sinopse'.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        // height: 35,
                        child: Text(
                          (serieDetail.overview ?? ''),
                          // maxLines: 2,
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontFamily: 'muli'),
                        ),
                      ),
                    ),
                  ],
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Episódios:'.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'muli',
                                  ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${(serieDetail.numberOfEpisodes ?? 0)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    //  fontSize: 12,
                                    fontFamily: 'muli',
                                  ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            ' - ',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  //  fontSize: 12,
                                  fontFamily: 'muli',
                                ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Temporadas:'.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'muli',
                                  ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${(serieDetail.numberOfSeasons ?? 0)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    //   fontSize: 12,
                                    fontFamily: 'muli',
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (serieDetail.seasons != null &&
                      serieDetail.seasons!.length > 0) ...[
                    Divider(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SerieSeasons(
                              serie: serieDetail,
                              palette: palette,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        serieDetail.seasons!.length > 1
                            ? 'Exibir Temporadas'
                            : 'Exibir Temporada',
                      ),
                    ),
                  ],
                  if (serieDetail.createdString != '--') ...[
                    // if (serieDetail.tagline == null ||
                    //     serieDetail.tagline!.isEmpty)
                    Divider(),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          serieDetail.createdBy!.length > 1
                              ? 'Criadores'
                              : 'Criador'.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        // height: 35,
                        child: Text(
                          (serieDetail.createdString),
                          // maxLines: 2,
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontFamily: 'muli'),
                        ),
                      ),
                    ),
                  ],
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //  Divider(),

                      if (serieDetail.serieImage != null &&
                          serieDetail.serieImage!.backdrops != null &&
                          serieDetail.serieImage!.backdrops!.length > 0) ...[
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Imagens'.toUpperCase(),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
                            separatorBuilder: (context, index) =>
                                VerticalDivider(
                              color: Colors.transparent,
                              width: 5,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                serieDetail.serieImage!.backdrops!.length,
                            itemBuilder: (context, index) {
                              Screenshot image =
                                  serieDetail.serieImage!.backdrops![index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GalleryPhotoViewWrapper(
                                        galleryItems:
                                            serieDetail.serieImage!.backdrops!,
                                        backgroundDecoration:
                                            const BoxDecoration(
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
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
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
                                          imageUrl:
                                              image.imageString('original') ??
                                                  '',
                                          placeholder: (context, url) =>
                                              kIsWeb || Platform.isAndroid
                                                  ? Container(
                                                      width: 255,
                                                      height: 155,
                                                      color: palette?.color,
                                                      child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                        color: palette
                                                            ?.titleTextColor,
                                                      )),
                                                    )
                                                  : Container(
                                                      width: 255,
                                                      height: 155,
                                                      color: palette?.color,
                                                      child:
                                                          CupertinoActivityIndicator(),
                                                    ),
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Container(
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
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                      if (serieDetail.credits != null &&
                          serieDetail.credits!.cast != null &&
                          serieDetail.credits!.cast!.length > 0) ...[
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Elenco'.toUpperCase(),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
                            separatorBuilder: (context, index) =>
                                VerticalDivider(
                              color: Colors.transparent,
                              width: 5,
                            ),
                            itemCount: serieDetail.credits!.cast!.length,
                            itemBuilder: (context, index) {
                              Cast cast = serieDetail.credits!.cast![index];
                              return InkWell(
                                onTap: () async {
                                  late PaletteGenerator paletteGenerator;
                                  if (cast.profileString('w500') != null) {
                                    paletteGenerator = await PaletteGenerator
                                        .fromImageProvider(
                                            CachedNetworkImageProvider(
                                                cast.profileString('w500')!));
                                  } else {
                                    paletteGenerator = await PaletteGenerator
                                        .fromImageProvider(AssetImage(
                                            'assets/images/img_not_found.jpg'));
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        elevation: 3,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                cast.profileString('w500') ??
                                                    '',
                                            imageBuilder:
                                                (context, imageBuilder) {
                                              return Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(100)),
                                                  image: DecorationImage(
                                                    image: imageBuilder,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            },
                                            placeholder: (context, url) =>
                                                kIsWeb || Platform.isAndroid
                                                    ? Container(
                                                        width: 80,
                                                        height: 80,
                                                        color: palette?.color,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          color: palette
                                                              ?.titleTextColor,
                                                        )),
                                                      )
                                                    : Container(
                                                        width: 80,
                                                        height: 80,
                                                        color: palette?.color,
                                                        child:
                                                            CupertinoActivityIndicator(),
                                                      ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
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
                                              //  color: Colors.black54,
                                              fontSize: 10,
                                              fontFamily: 'muli',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                          child: Text(
                                            (cast.character ?? '')
                                                .toUpperCase(),
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
                      if (serieDetail.credits != null &&
                          serieDetail.credits!.crew != null &&
                          serieDetail.credits!.crew!.length > 0) ...[
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Equipe Técnica'.toUpperCase(),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
                            separatorBuilder: (context, index) =>
                                VerticalDivider(
                              color: Colors.transparent,
                              width: 5,
                            ),
                            itemCount: serieDetail.credits!.crew!.length,
                            itemBuilder: (context, index) {
                              Cast crew = serieDetail.credits!.crew![index];
                              return InkWell(
                                onTap: () async {
                                  var paletteGenerator =
                                      await PaletteGenerator.fromImageProvider(
                                          CachedNetworkImageProvider(
                                              crew.profileString('w500') ??
                                                  ''));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PersonDetail(
                                        personId: crew.id!,
                                        personName: crew.name ?? 'Sem Nome',
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
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        elevation: 3,
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                crew.profileString('w500') ??
                                                    '',
                                            imageBuilder:
                                                (context, imageBuilder) {
                                              return Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(100)),
                                                  image: DecorationImage(
                                                    image: imageBuilder,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            },
                                            placeholder: (context, url) =>
                                                kIsWeb || Platform.isAndroid
                                                    ? Container(
                                                        width: 80,
                                                        height: 80,
                                                        color: palette?.color,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          color: palette
                                                              ?.titleTextColor,
                                                        )),
                                                      )
                                                    : Container(
                                                        width: 80,
                                                        height: 80,
                                                        color: palette?.color,
                                                        child:
                                                            CupertinoActivityIndicator(),
                                                      ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              color: palette?.color,
                                              width: 80,
                                              height: 80,
                                              child: Icon(Icons.person,
                                                  color:
                                                      palette?.titleTextColor),
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
                                            (crew.name ?? '').toUpperCase(),
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
                                            (crew.job ?? '').toUpperCase(),
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
                      if (serieDetail.videos != null &&
                          serieDetail.videos!.results != null &&
                          serieDetail.videos!.results!.length > 0) ...[
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Trailers'.toUpperCase(),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'muli',
                                    ),
                          ),
                        ),
                        Column(
                          children: serieDetail.videos!.results!.map((e) {
                            return TextButton(
                              onPressed: () async {
                                final uri = Uri.parse(e.youtubeURL!);
                                await launchUrl(uri);
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.play_circle,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  e.name ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontFamily: 'muli',
                                        fontSize: 13,
                                      ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 35),
                ]),
              ),
            ],
          );
        } else if (state is SerieDetailError) {
          return ErrorMessage(
            message: state.message,
            onTap: () {
              context
                  .read<SerieDetailBloc>()
                  .add(SerieDetailEventStated(serieId));
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
