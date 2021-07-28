import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_flutter/src/bloc/drawerbloc/drawer_bloc.dart';
import 'package:moviedb_flutter/src/ui/custom_drawer/page_tile.dart';

class PageSectionMovies extends StatelessWidget {
  const PageSectionMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerBloc, NavDrawerState>(
      builder: (BuildContext context, NavDrawerState state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text('Filmes'),
              ),
              PageTile(
                  label: 'Em Cartaz',
                  iconData: Icons.movie,
                  onTap: () {
                    _handleItemClick(context, NavItem.page_two);
                  },
                  highlighted: state.selectedItem == NavItem.page_two),
              PageTile(
                  label: 'Próximas Estreias',
                  iconData: Icons.movie,
                  onTap: () {
                    _handleItemClick(context, NavItem.page_three);
                  },
                  highlighted: state.selectedItem == NavItem.page_three),
              PageTile(
                  label: 'Mais Bem Avaliados',
                  iconData: Icons.movie,
                  onTap: () {
                    _handleItemClick(context, NavItem.page_four);
                  },
                  highlighted: state.selectedItem == NavItem.page_four),
              PageTile(
                  label: 'Populares',
                  iconData: Icons.movie,
                  onTap: () {
                    _handleItemClick(context, NavItem.page_five);
                  },
                  highlighted: state.selectedItem == NavItem.page_five),
            ],
          ),
        );
      },
    );
  }

  void _handleItemClick(BuildContext context, NavItem item) {
    BlocProvider.of<DrawerBloc>(context).add(NavigateTo(item));
    Navigator.pop(context);
  }
}
