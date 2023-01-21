import 'package:flutter/material.dart';
import 'package:moviedb_flutter/src/views/custom_drawer/page_section.dart';
import 'package:moviedb_flutter/src/views/custom_drawer/page_section_movies.dart';
import 'package:moviedb_flutter/src/views/custom_drawer/page_section_series.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(50)),
      child: OrientationBuilder(
        builder: (context, orientation) {
          return SizedBox(
            width: MediaQuery.of(context).size.width *
                (orientation == Orientation.portrait ? 0.75 : 0.50),
            child: Drawer(
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset('assets/images/logo_tmdb.png'),
                    ),
                    Divider(),
                    Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          PageSection(),
                          PageSectionMovies(),
                          Divider(),
                          PageSectionSeries(),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
