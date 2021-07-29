import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_flutter/src/bloc/personbloc/person_bloc.dart';
import 'package:moviedb_flutter/src/extensions/extension.dart';
import 'package:moviedb_flutter/src/model/credits.dart';
import 'package:moviedb_flutter/src/model/images.dart';
import 'package:moviedb_flutter/src/model/person.dart';
import 'package:moviedb_flutter/src/views/components/error_message_screen.dart';
import 'package:moviedb_flutter/src/views/components/galery.dart';
import 'package:moviedb_flutter/src/views/components/loading_screen.dart';
import 'package:moviedb_flutter/src/views/movie/movie_detail_screen.dart';
import 'package:moviedb_flutter/src/views/serie/serie_detail_screen.dart';
import 'package:palette_generator/palette_generator.dart';

class PersonDetail extends StatelessWidget {
  const PersonDetail(
      {Key? key,
      required this.personId,
      required this.personName,
      required this.paletteColor})
      : super(key: key);

  final String personName;
  final int personId;
  final PaletteGenerator paletteColor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PersonBloc()..add(PersonEventDetail(personId)),
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(personName),
            //  backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: _buildDetailBody(context),
        ),
        onWillPop: () async => true,
      ),
    );
  }

  _buildDetailBody(BuildContext context) {
    var palette = paletteColor.mutedColor ?? paletteColor.dominantColor;
    return BlocBuilder<PersonBloc, PersonState>(builder: (context, state) {
      if (state is PersonLoading) {
        return LoadingScreen();
      } else if (state is PersonDetailLoaded) {
        Person personDetail = state.person;

        return TabbarPerson(
            tabLenght: personDetail.tabLenght,
            personDetail: personDetail,
            palette: palette);
      } else if (state is PersonError) {
        return ErrorMessage(
          message: state.message,
          onTap: () {
            context.read<PersonBloc>().add(PersonEventDetail(personId));
          },
        );
      } else {
        return Container();
      }
    });
  }
}

class TabbarPerson extends StatefulWidget {
  TabbarPerson(
      {Key? key,
      required this.tabLenght,
      required this.personDetail,
      this.palette})
      : super(key: key);

  final int tabLenght;
  final PaletteColor? palette;
  final Person personDetail;

  @override
  _TabbarPersonState createState() => _TabbarPersonState();
}

class _TabbarPersonState extends State<TabbarPerson>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: widget.tabLenght,
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
        BiographyPerson(
          personDetail: widget.personDetail,
          palette: widget.palette,
        ),
        if (widget.personDetail.casts.length > 0)
          ListPersonMovies(
            titlePage: 'Atuação',
            personMovies: widget.personDetail.casts,
            palette: widget.palette,
          ),
        if (widget.personDetail.crews.length > 0)
          ListPersonMovies(
            titlePage: 'Equipe Técnica',
            personMovies: widget.personDetail.crews,
            palette: widget.palette,
          ),
      ],
    );
  }
}

class BiographyPerson extends StatelessWidget {
  const BiographyPerson({Key? key, required this.personDetail, this.palette})
      : super(key: key);

  final Person personDetail;
  final PaletteColor? palette;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Container(
                width: 180,
                height: 250,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: personDetail.profileString('w500') ?? '',
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
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        'Conhecido(a) por'.toUpperCase(),
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        //  overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      personDetail.knownForDepartment ?? '',
                      style: TextStyle(
                        fontFamily: 'muli',
                        color: Theme.of(context).hintColor,
                      ),
                      //  overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Text(
                          'Gênero'.toUpperCase(),
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          //   overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Text(
                      personDetail.genderString,
                      style: TextStyle(
                        fontFamily: 'muli',
                        color: Theme.of(context).hintColor,
                      ),
                      // overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    if (personDetail.birthday != null) ...[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            'Nascimento'.toUpperCase(),
                            style:
                                Theme.of(context).textTheme.caption?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                            //  overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        personDetail.birthdayString,
                        style: TextStyle(
                          fontFamily: 'muli',
                          color: Theme.of(context).hintColor,
                        ),
                        //  overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                    if (personDetail.deathday != null) ...[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            'Falecimento'.toUpperCase(),
                            style:
                                Theme.of(context).textTheme.caption?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                            //  overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        personDetail.deathDayString,
                        style: TextStyle(
                          fontFamily: 'muli',
                          color: Theme.of(context).hintColor,
                        ),
                        //  overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                    if (personDetail.placeOfBirth != null &&
                        personDetail.placeOfBirth!.isNotEmpty) ...[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            'Local de Nascimento'.toUpperCase(),
                            style:
                                Theme.of(context).textTheme.caption?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        personDetail.placeOfBirth ?? '',
                        style: TextStyle(
                          fontFamily: 'muli',
                          color: Theme.of(context).hintColor,
                        ),
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    // Container(
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 5.0),
                    //     child: Text(
                    //       'Também Conhecido(a) como'.toUpperCase(),
                    //       style:
                    //           Theme.of(context).textTheme.caption?.copyWith(
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //   ),
                    // ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: personDetail.alsoKnownAs!
                    //       .map((e) => Text(e))
                    //       .toList(),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (personDetail.biography != null &&
            personDetail.biography!.isNotEmpty) ...[
          Divider(),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Biografia'.toUpperCase(),
                style: Theme.of(context).textTheme.caption?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              child: Text(
                (personDetail.biography!),
                style: TextStyle(fontFamily: 'muli'),
              ),
            ),
          ),
        ],
        if (personDetail.images != null &&
            personDetail.images!.profiles != null &&
            personDetail.images!.profiles!.length > 0) ...[
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
              itemCount: personDetail.images!.profiles!.length,
              itemBuilder: (context, index) {
                Screenshot image = personDetail.images!.profiles![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryPhotoViewWrapper(
                          galleryItems: personDetail.images!.profiles!,
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
                                  width: 95,
                                  height: 155,
                                  color: palette?.color,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: palette?.titleTextColor,
                                  )),
                                )
                              : Container(
                                  width: 95,
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
                              Icons.person,
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
            height: 15,
          ),
        ],
      ],
    );
  }
}

class ListPersonMovies extends StatelessWidget {
  ListPersonMovies(
      {Key? key,
      required this.titlePage,
      required this.personMovies,
      this.palette})
      : super(key: key);

  final String titlePage;
  final List<Cast> personMovies;
  final PaletteColor? palette;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: personMovies.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (personMovies.first == personMovies[index])
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
              _cardPerson(context, personMovies[index]),
            ],
          );
        });
  }

  Widget _cardPerson(BuildContext context, Cast person) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              late PaletteGenerator paletteGenerator;
              if (person.posterString('w200') != null) {
                paletteGenerator = await PaletteGenerator.fromImageProvider(
                    CachedNetworkImageProvider(person.posterString('w200')!));
              } else {
                paletteGenerator = await PaletteGenerator.fromImageProvider(
                    AssetImage('assets/images/img_not_found.jpg'));
              }
              if (person.episodeCount == null && person.firstAirDate == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(
                        movieId: person.id ?? 0,
                        paletteColor: paletteGenerator),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SerieDetailScreen(
                        serieId: person.id ?? 0,
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
                        imageUrl: person.posterString('w200') ?? '',
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
                      Text(person.releaseDate?.formattedDatePerson() ??
                          person.firstAirDate?.formattedDatePerson() ??
                          '--'),
                      Text(
                        person.title ?? person.name ?? '',
                        style: TextStyle(
                            fontFamily: 'muli', fontWeight: FontWeight.bold),
                      ),
                      if (person.character != null &&
                          person.character!.isNotEmpty)
                        Wrap(
                          children: [
                            if (person.episodeCount != null &&
                                person.episodeCount! > 0)
                              Text(
                                '(${person.episodeCount} ${person.episodeCount! > 1 ? 'episódios' : 'episódio'}) ',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            Text(
                              'como ${person.character}',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                      if (person.job != null && person.job!.isNotEmpty)
                        Wrap(
                          children: [
                            if (person.episodeCount != null &&
                                person.episodeCount! > 0)
                              Text(
                                '(${person.episodeCount} ${person.episodeCount! > 1 ? 'episódios' : 'episódio'}) ',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            Text(
                              'como ${person.job}',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (personMovies.last != person) Divider(),
        ],
      ),
    );
  }
}
