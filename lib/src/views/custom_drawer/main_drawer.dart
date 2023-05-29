import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_flutter/src/bloc/drawerbloc/drawer_bloc.dart';
import 'package:moviedb_flutter/src/bloc/searchbloc/search_bloc.dart';
import 'package:moviedb_flutter/src/views/components/error_message_screen.dart';
import 'package:moviedb_flutter/src/views/home/home_screen.dart';
import 'package:moviedb_flutter/src/views/movie/now_playing.dart';
import 'package:moviedb_flutter/src/views/movie/popular.dart';
import 'package:moviedb_flutter/src/views/movie/top_rated.dart';
import 'package:moviedb_flutter/src/views/movie/upcoming.dart';
import 'package:moviedb_flutter/src/views/search/sarch_screen.dart';
import 'package:moviedb_flutter/src/views/serie/serie_airingtoday.dart';
import 'package:moviedb_flutter/src/views/serie/serie_onair.dart';
import 'package:moviedb_flutter/src/views/serie/serie_popular.dart';
import 'package:moviedb_flutter/src/views/serie/serie_toprated.dart';

import 'custom_drawer.dart';

class MainContainerWidget extends StatefulWidget {
  const MainContainerWidget({Key? key}) : super(key: key);

  @override
  _MainContainerWidgetState createState() => _MainContainerWidgetState();
}

class _MainContainerWidgetState extends State<MainContainerWidget> {
  late DrawerBloc _bloc;
  late Widget _content;

  ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: AppBarTheme().copyWith(
      titleTextStyle: TextStyle().copyWith(
        fontSize: 20,
        color: Colors.black,
      ),
      color: Colors.white,
      iconTheme: IconThemeData().copyWith(
        color: Colors.black,
      ),
    ),
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
  );

  ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      color: Colors.grey[850],
    ),
    brightness: Brightness.dark,
    primaryColor: Colors.grey[850],
  );

  @override
  void initState() {
    super.initState();
    _bloc = DrawerBloc();
    _content = _getContentForState(_bloc.state);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DrawerBloc>(
          create: (_) => _bloc,
        ),
        BlocProvider<SearchBloc>(
          // lazy: false,
          create: (_) => SearchBloc(),
        ),
        // BlocProvider<MovieBloc>(
        //   // lazy: false,
        //   create: (_) => MovieBloc(),
        // ),
      ],
      child: BlocListener<DrawerBloc, NavDrawerState>(
        listener: (BuildContext context, NavDrawerState state) {
          setState(() {
            _content = _getContentForState(state);
          });
        },
        child: BlocBuilder<DrawerBloc, NavDrawerState>(
          builder: (BuildContext context, NavDrawerState state) =>
              ThemeProvider(
            initTheme: View.of(context).platformDispatcher.platformBrightness ==
                    Brightness.dark
                ? _darkTheme
                : _lightTheme,
            builder: (context, myTheme) {
              return MaterialApp(
                theme: myTheme,
                home: ThemeSwitchingArea(
                  child: Scaffold(
                    drawer: CustomDrawer(),
                    appBar: AppBar(
                      elevation: 0,
                      centerTitle: true,
                      actions: [
                        ThemeSwitcher(
                          clipper: ThemeSwitcherCircleClipper(),
                          builder: (context) {
                            var brightness = Theme.of(context).brightness;
                            return IconButton(
                              icon: Icon(brightness == Brightness.light
                                  ? Icons.dark_mode
                                  : Icons.light_mode),
                              onPressed: () {
                                ThemeSwitcher.of(context).changeTheme(
                                  theme: brightness == Brightness.light
                                      ? _darkTheme
                                      : _lightTheme,
                                  isReversed: brightness == Brightness.dark
                                      ? true
                                      : false,
                                );
                              },
                            );
                          },
                        )
                      ],
                      title: Text(
                        state.selectedItem.description!.toUpperCase(),
                      ),
                    ),
                    body: AnimatedSwitcher(
                      // switchInCurve: Curves.easeInExpo,
                      // switchOutCurve: Curves.easeOutExpo,
                      duration: Duration(milliseconds: 500),
                      child: _content,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _getContentForState(NavDrawerState state) {
    switch (state.selectedItem) {
      case NavItem.home:
        return HomeScreen();
      case NavItem.page_two:
        return NowPlaying();
      case NavItem.page_three:
        return Upcoming();
      case NavItem.page_four:
        return TopRated();
      case NavItem.page_five:
        return Popular();
      case NavItem.page_six:
        return SerieAiringToday();
      case NavItem.page_seven:
        return SerieOnAir();
      case NavItem.page_eight:
        return SerieTopRated();
      case NavItem.page_nine:
        return SeriePopular();
      case NavItem.pesquisa:
        return SearchScreen();
      default:
        return ErrorMessage(message: 'Erro ao exibir página');
    }
  }
}
