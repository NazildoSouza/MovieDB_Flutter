part of 'person_bloc.dart';

abstract class PersonEvent extends Equatable {
  const PersonEvent();

  @override
  List<Object> get props => [];
}

class PersonEventStated extends PersonEvent {
  @override
  List<Object> get props => [];
}

class PersonEventDetail extends PersonEvent {
  PersonEventDetail(this.id);

  final int id;

  @override
  List<Object> get props => [id];
}
