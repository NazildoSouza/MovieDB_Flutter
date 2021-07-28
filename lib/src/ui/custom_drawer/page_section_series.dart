import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_flutter/src/bloc/drawerbloc/drawer_bloc.dart';
import 'package:moviedb_flutter/src/ui/custom_drawer/page_tile.dart';

class PageSectionSeries extends StatelessWidget {
  const PageSectionSeries({Key? key}) : super(key: key);

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
                child: Text('Séries'),
              ),
              PageTile(
                  label: 'Em Exibixão Hoje',
                  iconData: Icons.movie,
                  onTap: () {
                    _handleItemClick(context, NavItem.page_six);
                  },
                  highlighted: state.selectedItem == NavItem.page_six),
              PageTile(
                  label: 'Nat TV',
                  iconData: Icons.movie,
                  onTap: () {
                    _handleItemClick(context, NavItem.page_seven);
                  },
                  highlighted: state.selectedItem == NavItem.page_seven),
              PageTile(
                  label: 'Mais Bem Avaliados',
                  iconData: Icons.movie,
                  onTap: () {
                    _handleItemClick(context, NavItem.page_eight);
                  },
                  highlighted: state.selectedItem == NavItem.page_eight),
              PageTile(
                  label: 'Populares',
                  iconData: Icons.movie,
                  onTap: () {
                    _handleItemClick(context, NavItem.page_nine);
                  },
                  highlighted: state.selectedItem == NavItem.page_nine),
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
