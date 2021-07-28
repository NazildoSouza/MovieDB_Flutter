import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'drawer_event.dart';
part 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, NavDrawerState> {
  // DrawerBloc(NavDrawerState initialState) : super(initialState);

  DrawerBloc() : super(NavDrawerState(NavItem.home));

  @override
  Stream<NavDrawerState> mapEventToState(
    DrawerEvent event,
  ) async* {
    if (event is NavigateTo) {
      // only route to a new location if the new location is different
      if (event.destination != state.selectedItem) {
        yield NavDrawerState(event.destination);
      }
    }
  }
}
