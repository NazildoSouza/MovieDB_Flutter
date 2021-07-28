part of 'drawer_bloc.dart';

abstract class DrawerEvent extends Equatable {
  const DrawerEvent();

  @override
  List<Object> get props => [];
}

class NavigateTo extends DrawerEvent {
  const NavigateTo(this.destination);
  final NavItem destination;

  @override
  List<Object> get props => [destination];
}
