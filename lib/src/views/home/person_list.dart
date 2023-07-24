import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_flutter/src/bloc/personbloc/person_bloc.dart';
import 'package:moviedb_flutter/src/model/person.dart';
import 'package:moviedb_flutter/src/views/components/error_message_screen.dart';
import 'package:moviedb_flutter/src/views/components/loading_screen.dart';
import 'package:moviedb_flutter/src/views/person/person_detail_screen.dart';
import 'package:palette_generator/palette_generator.dart';

class PersonList extends StatelessWidget {
  const PersonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonBloc, PersonState>(
      builder: (context, state) {
        if (state is PersonLoading) {
          return Container(height: 150, child: LoadingScreen());
        } else if (state is ListPersonLoaded) {
          List<Person> personList = state.personList;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Pessoas em alta nesta semana'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'muli',
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                height: 130,
                child: ListView.separated(
                  clipBehavior: Clip.antiAlias,
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  scrollDirection: Axis.horizontal,
                  itemCount: personList.length,
                  separatorBuilder: (context, index) => VerticalDivider(
                    color: Colors.transparent,
                    width: 5,
                  ),
                  itemBuilder: (context, index) {
                    Person person = personList[index];
                    Color color = Colors.grey.shade200;
                    return InkWell(
                      onTap: () async {
                        late PaletteGenerator paletteGenerator;
                        if (person.profileString('w500') != null) {
                          paletteGenerator =
                              await PaletteGenerator.fromImageProvider(
                                  CachedNetworkImageProvider(
                                      person.profileString('w500')!));
                        } else {
                          paletteGenerator =
                              await PaletteGenerator.fromImageProvider(
                                  AssetImage(
                                      'assets/images/img_not_found.jpg'));
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonDetail(
                              personId: person.id!,
                              personName: person.name ?? 'Sem Nome',
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
                                borderRadius: BorderRadius.circular(100),
                              ),
                              elevation: 3,
                              child: ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl: person.profileString('w500') ?? '',
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(100),
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                  placeholder: (context, url) => kIsWeb ||
                                          Platform.isAndroid
                                      ? Container(
                                          width: 80,
                                          height: 80,
                                          color: color,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        )
                                      : Container(
                                          width: 80,
                                          height: 80,
                                          color: color,
                                          child: CupertinoActivityIndicator(),
                                        ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: color,
                                    width: 80,
                                    height: 80,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black45,
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
                                  (person.name ?? '').toUpperCase(),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    //  color: Colors.black45,
                                    fontSize: 10,
                                    fontFamily: 'muli',
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Text(
                                  (person.knownForDepartment ?? '')
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    //  color: Colors.black45,
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
          );
        } else if (state is PersonError) {
          return ErrorMessage(
            message: state.message,
            onTap: () {
              context.read<PersonBloc>().add(PersonEventStated());
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
