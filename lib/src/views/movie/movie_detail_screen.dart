import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_flutter/src/bloc/moviedetailbloc/movie_detail_bloc.dart';
import 'package:moviedb_flutter/src/circle_progress/circle_progress_screen.dart';
import 'package:moviedb_flutter/src/extensions/extension.dart';
import 'package:moviedb_flutter/src/model/credits.dart';
import 'package:moviedb_flutter/src/model/images.dart';
import 'package:moviedb_flutter/src/model/movie_detail.dart';
import 'package:moviedb_flutter/src/views/components/error_message_screen.dart';
import 'package:moviedb_flutter/src/views/components/galery.dart';
import 'package:moviedb_flutter/src/views/components/loading_screen.dart';
import 'package:moviedb_flutter/src/views/person/person_detail_screen.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen(
      {Key? key, required this.movieId, required this.paletteColor})
      : super(key: key);

  final int movieId;
  final PaletteGenerator paletteColor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieDetailBloc()..add(MovieDetailEventStated(movieId)),
      child: WillPopScope(
        child: Scaffold(
          body: _buildDetailBody(context),
        ),
        onWillPop: () async => true,
      ),
    );
  }

  Widget _buildDetailBody(BuildContext context) {
    // Color color = Colors.accents[Random().nextInt(Colors.accents.length)];
    var palette = paletteColor.mutedColor ?? paletteColor.dominantColor;
    return BlocBuilder<MovieDetailBloc, MovieDetailState>(
      builder: (context, state) {
        if (state is MovieDetailLoading) {
          return LoadingScreen();
        } else if (state is MovieDetailLoaded) {
          MovieDetail movieDetail = state.detail;
          return OrientationBuilder(
            builder: (context, orientaion) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      if (orientaion == Orientation.landscape)
                        Column(
                          children: [
                            Card(
                              margin: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              elevation: 8,
                              child: ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      movieDetail.backdropString('original') ??
                                          '',
                                  height: MediaQuery.of(context).size.height,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Platform
                                          .isAndroid
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
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: palette?.color,
                                    child: Icon(
                                      Icons.photo,
                                      color: palette?.titleTextColor,
                                      size: 150,
                                    ),
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      if (orientaion == Orientation.portrait)
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 3.5),
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            (movieDetail.title ?? '').toUpperCase(),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                              // color: Colors.black87,
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
                              movieDetail.genresString,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              // style: TextStyle(
                              //     fontFamily: 'muli',
                              //     color: Theme.of(context).hintColor),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
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
                                  movieDetail.dateString,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      ?.copyWith(
                                        fontFamily: 'muli',
                                      ),
                                ),
                                Text(
                                  ' - ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      ?.copyWith(
                                        fontFamily: 'muli',
                                      ),
                                ),
                                Text(
                                  movieDetail.timeString,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
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
                              movieDetail.statusString,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'muli',
                                  fontWeight: FontWeight.bold),
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
                                  voteAverage: movieDetail.voteAverage ?? 0),
                            ),
                            Text(
                              'Avaliação dos Usuários',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontFamily: 'muli',
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (movieDetail.tagline != null &&
                          movieDetail.tagline!.isNotEmpty) ...[
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            movieDetail.tagline!,
                            style:
                                Theme.of(context).textTheme.subtitle2?.copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.w200,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                      fontFamily: 'muli',
                                    ),
                          ),
                        ),
                      ],
                      if (movieDetail.overview != null &&
                          movieDetail.overview!.isNotEmpty) ...[
                        if (movieDetail.tagline == null ||
                            movieDetail.tagline!.isEmpty)
                          Divider(),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Sinopse'.toUpperCase(),
                              style:
                                  Theme.of(context).textTheme.caption?.copyWith(
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
                              (movieDetail.overview ?? ''),
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
                                      'Orçamento:'.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'muli',
                                          ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      movieDetail.budget?.formattedPrice() ??
                                          '--',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          ?.copyWith(
                                            //  fontSize: 12,
                                            fontFamily: 'muli',
                                          ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Text(
                                    ' - ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        ?.copyWith(
                                          //   fontSize: 12,
                                          fontFamily: 'muli',
                                        ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Receita:'.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'muli',
                                          ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      movieDetail.revenue?.formattedPrice() ??
                                          '--',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
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
                          if (movieDetail.movieImage != null &&
                              movieDetail.movieImage!.backdrops != null &&
                              movieDetail.movieImage!.backdrops!.length >
                                  0) ...[
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Imagens'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'muli',
                                    ),
                              ),
                            ),
                            Container(
                              height: 155,
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                separatorBuilder: (context, index) =>
                                    VerticalDivider(
                                  color: Colors.transparent,
                                  width: 5,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    movieDetail.movieImage!.backdrops!.length,
                                itemBuilder: (context, index) {
                                  Screenshot image =
                                      movieDetail.movieImage!.backdrops![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GalleryPhotoViewWrapper(
                                            galleryItems: movieDetail
                                                .movieImage!.backdrops!,
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
                                      child: Card(
                                        clipBehavior: Clip.antiAlias,
                                        elevation: 3,
                                        borderOnForeground: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ClipRRect(
                                          //  borderRadius: BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                image.imageString('original') ??
                                                    '',
                                            placeholder: (context, url) =>
                                                Platform.isAndroid
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
                                            errorWidget:
                                                (context, url, error) =>
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
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                          if (movieDetail.credits != null &&
                              movieDetail.credits!.cast != null &&
                              movieDetail.credits!.cast!.length > 0) ...[
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Elenco'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'muli',
                                    ),
                              ),
                            ),
                            Container(
                              height: 130,
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) =>
                                    VerticalDivider(
                                  color: Colors.transparent,
                                  width: 5,
                                ),
                                itemCount: movieDetail.credits!.cast!.length,
                                itemBuilder: (context, index) {
                                  Cast cast = movieDetail.credits!.cast![index];
                                  return GestureDetector(
                                    onTap: () async {
                                      late PaletteGenerator paletteGenerator;
                                      if (cast.profileString('w200') != null) {
                                        paletteGenerator =
                                            await PaletteGenerator
                                                .fromImageProvider(
                                                    CachedNetworkImageProvider(
                                                        cast.profileString(
                                                            'w200')!));
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
                                                imageUrl: cast.profileString(
                                                        'w200') ??
                                                    '',
                                                imageBuilder:
                                                    (context, imageBuilder) {
                                                  return Container(
                                                    width: 80,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                      image: DecorationImage(
                                                        image: imageBuilder,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                placeholder: (context, url) =>
                                                    Platform.isAndroid
                                                        ? Container(
                                                            width: 80,
                                                            height: 80,
                                                            color:
                                                                palette?.color,
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
                                                            color:
                                                                palette?.color,
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
                                                    color:
                                                        palette?.titleTextColor,
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
                                                  // color: Theme.of(context)
                                                  //     .selectedRowColor
                                                  //     .withOpacity(0.7),
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
                                                  // color: Colors.black54,
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
                          if (movieDetail.credits != null &&
                              movieDetail.credits!.crew != null &&
                              movieDetail.credits!.crew!.length > 0) ...[
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Equipe Técnica'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'muli',
                                    ),
                              ),
                            ),
                            Container(
                              height: 130,
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) =>
                                    VerticalDivider(
                                  color: Colors.transparent,
                                  width: 5,
                                ),
                                itemCount: movieDetail.credits!.crew!.length,
                                itemBuilder: (context, index) {
                                  Cast crew = movieDetail.credits!.crew![index];
                                  return GestureDetector(
                                    onTap: () async {
                                      late PaletteGenerator paletteGenerator;
                                      if (crew.profileString('w200') != null) {
                                        paletteGenerator =
                                            await PaletteGenerator
                                                .fromImageProvider(
                                                    CachedNetworkImageProvider(
                                                        crew.profileString(
                                                            'w200')!));
                                      } else {
                                        paletteGenerator = await PaletteGenerator
                                            .fromImageProvider(AssetImage(
                                                'assets/images/img_not_found.jpg'));
                                      }
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
                                                imageUrl: crew.profileString(
                                                        'w200') ??
                                                    '',
                                                imageBuilder:
                                                    (context, imageBuilder) {
                                                  return Container(
                                                    width: 80,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                      image: DecorationImage(
                                                        image: imageBuilder,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                placeholder: (context, url) =>
                                                    Platform.isAndroid
                                                        ? Container(
                                                            width: 80,
                                                            height: 80,
                                                            color:
                                                                palette?.color,
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
                                                            color:
                                                                palette?.color,
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
                                                      color: palette
                                                          ?.titleTextColor),
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
                                                (crew.job ?? '').toUpperCase(),
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
                          if (movieDetail.videos != null &&
                              movieDetail.videos!.results != null &&
                              movieDetail.videos!.results!.length > 0) ...[
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Trailers'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'muli',
                                    ),
                              ),
                            ),
                            Column(
                              children: movieDetail.videos!.results!.map((e) {
                                return TextButton(
                                  onPressed: () async {
                                    if (await canLaunch(e.youtubeURL!)) {
                                      await launch(e.youtubeURL!);
                                    }
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
                                          .caption
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
                    ],
                  ),
                  if (orientaion == Orientation.portrait)
                    Stack(
                      children: [
                        Card(
                          margin: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          elevation: 8,
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl:
                                  movieDetail.backdropString('original') ?? '',
                              height: MediaQuery.of(context).size.height / 3.5,
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
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                        ),
                        Positioned(
                          top: Platform.isIOS ? 50 : 30,
                          left: 0,
                          child: IconButton(
                            icon: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Platform.isAndroid
                                    ? Icons.arrow_back_rounded
                                    : Icons.navigate_before,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  if (orientaion == Orientation.landscape)
                    Positioned(
                      top: Platform.isIOS ? 50 : 30,
                      left: 0,
                      child: IconButton(
                        icon: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Platform.isAndroid
                                ? Icons.arrow_back_rounded
                                : Icons.navigate_before,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                ],
              );
            },
          );
        } else if (state is MovieDetailError) {
          return ErrorMessage(
            message: state.message,
            onTap: () {
              context
                  .read<MovieDetailBloc>()
                  .add(MovieDetailEventStated(movieId));
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
