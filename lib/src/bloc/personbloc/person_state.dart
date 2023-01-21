part of 'person_bloc.dart';

abstract class PersonState extends Equatable {
  const PersonState();

  @override
  List<Object> get props => [];
}

class PersonLoading extends PersonState {}

class PersonError extends PersonState {
  final String message;
  const PersonError(this.message);

  @override
  String toString() {
    return '''MovieDetailError { error: $message }''';
  }

  @override
  List<Object> get props => [message];
}

class ListPersonLoaded extends PersonState {
  final List<Person> personList;
  const ListPersonLoaded(this.personList);

  @override
  String toString() {
    return '''PersonLoaded { personList: ${personList.length} }''';
  }

  @override
  List<Object> get props => [personList];
}

class PersonDetailLoaded extends PersonState {
  final Person person;
  const PersonDetailLoaded(this.person);

  @override
  String toString() {
    return '''PersonDetailLoaded { person: $person }''';
  }

  @override
  List<Object> get props => [person];
}
