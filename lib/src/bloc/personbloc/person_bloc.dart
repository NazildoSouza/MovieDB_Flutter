import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb_flutter/src/model/person.dart';
import 'package:moviedb_flutter/src/service/api_options.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc() : super(PersonLoading());

  final Dio _dio = Dio(kDioOptionsPesonDetail);
  final Dio _dio2 = Dio(kDioOptions);

  @override
  Stream<PersonState> mapEventToState(
    PersonEvent event,
  ) async* {
    if (event is PersonEventStated) {
      yield* _mapPersonEventStartedToState();
    } else if (event is PersonEventDetail) {
      yield* _mapPersonDetailEventStartedToState(event.id);
    }
  }

  Stream<PersonState> _mapPersonEventStartedToState() async* {
    yield PersonLoading();
    try {
      final response = await _dio2.get('/trending/person/week');
      var persons = response.data['results'] as List;
      List<Person> personList = persons.map((p) => Person.fromJson(p)).toList();
      yield ListPersonLoaded(personList);
    } on DioError catch (error) {
      if (error.response != null) {
        yield PersonError(error.response?.data['status_message']);
      } else {
        yield PersonError('Erro de conexão, verifique sua internet!!');
      }
    } on Exception catch (_) {
      yield PersonError('Erro desconhecido.');
    }
  }

  Stream<PersonState> _mapPersonDetailEventStartedToState(int id) async* {
    yield PersonLoading();
    try {
      final response = await _dio.get('/person/$id');
      Person personDetail = Person.fromJson(response.data);

      // final responseCredits = await _dio.get('/person/$id/movie_credits');
      // Credits credits = Credits.fromJson(responseCredits.data);
      // personDetail.credits = credits;

      yield PersonDetailLoaded(personDetail);
    } on DioError catch (error) {
      if (error.response != null) {
        yield PersonError(error.response?.data['status_message']);
      } else {
        yield PersonError('Erro de conexão, verifique sua internet!!');
      }
    } on Exception catch (_) {
      yield PersonError('Erro desconhecido.');
    }
  }
}
