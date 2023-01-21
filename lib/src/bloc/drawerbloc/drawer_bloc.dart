import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'drawer_event.dart';
part 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, NavDrawerState> {
  DrawerBloc() : super(NavDrawerState(NavItem.home)) {
    on<NavigateTo>(_navigateTo);
  }

  void _navigateTo(NavigateTo event, Emitter<NavDrawerState> emit) {
    if (event.destination != state.selectedItem) {
      emit(NavDrawerState(event.destination));
    }
  }
}
