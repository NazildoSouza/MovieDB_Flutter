part of 'drawer_bloc.dart';

abstract class DrawerState extends Equatable {
  const DrawerState();

  @override
  List<Object> get props => [];
}

class DrawerInitial extends DrawerState {}

// this is the state the user is expected to see
class NavDrawerState extends DrawerState {
  const NavDrawerState(this.selectedItem);
  final NavItem selectedItem;

  @override
  List<Object> get props => [selectedItem];
}

// helpful navigation pages, you can change
// them to support your pages
enum NavItem {
  home,
  page_two,
  page_three,
  page_four,
  page_five,
  page_six,
  page_seven,
  page_eight,
  page_nine,
  pesquisa,
}

extension NavItemDesc on NavItem {
  String? get description => const {
        NavItem.home: 'The Movie DB',
        NavItem.page_two: 'Em Cartaz',
        NavItem.page_three: 'Próximas Estreias',
        NavItem.page_four: 'Mais Bem Avaliados',
        NavItem.page_five: 'Populares',
        NavItem.pesquisa: 'Pesquisar',
        NavItem.page_six: 'Em Exibição Hoje',
        NavItem.page_seven: 'Na TV',
        NavItem.page_eight: 'Mais Bem Avaliados',
        NavItem.page_nine: 'Populares',
      }[this];
}
