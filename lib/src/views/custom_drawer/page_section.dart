import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_flutter/src/bloc/drawerbloc/drawer_bloc.dart';
import 'package:moviedb_flutter/src/views/custom_drawer/page_tile.dart';

class PageSection extends StatelessWidget {
  const PageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerBloc, NavDrawerState>(
      builder: (BuildContext context, NavDrawerState state) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTile(
                  label: 'Início',
                  iconData: Icons.movie,
                  onTap: () {
                    _handleItemClick(context, NavItem.home);
                  },
                  highlighted: state.selectedItem == NavItem.home),
              PageTile(
                  label: 'Pesquisar',
                  iconData: Icons.search,
                  onTap: () {
                    _handleItemClick(context, NavItem.pesquisa);
                  },
                  highlighted: state.selectedItem == NavItem.pesquisa),
              Divider(),
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
