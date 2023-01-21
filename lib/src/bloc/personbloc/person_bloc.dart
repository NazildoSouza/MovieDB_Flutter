import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb_flutter/src/model/person.dart';
import 'package:moviedb_flutter/src/service/api_options.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc() : super(PersonLoading()) {
    on<PersonEventStated>(_mapPersonEventStartedToState);
    on<PersonEventDetail>(_mapPersonDetailEventStartedToState);
  }

  final Dio _dio = Dio(kDioOptionsPesonDetail);
  final Dio _dio2 = Dio(kDioOptions);

  Future<void> _mapPersonEventStartedToState(
      PersonEventStated event, Emitter<PersonState> emit) async {
    emit(PersonLoading());
    try {
      final response = await _dio2.get('/trending/person/week');
      var persons = response.data['results'] as List;
      List<Person> personList = persons.map((p) => Person.fromJson(p)).toList();
      emit(ListPersonLoaded(personList));
    } on DioError catch (error) {
      if (error.response != null) {
        emit(PersonError(error.response?.data['status_message']));
      } else {
        emit(PersonError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(PersonError('Erro desconhecido.'));
    }
  }

  Future<void> _mapPersonDetailEventStartedToState(
      PersonEventDetail event, Emitter<PersonState> emit) async {
    emit(PersonLoading());
    try {
      final response = await _dio.get('/person/${event.id}');
      Person personDetail = Person.fromJson(response.data);

      // final responseCredits = await _dio.get('/person/$id/movie_credits');
      // Credits credits = Credits.fromJson(responseCredits.data);
      // personDetail.credits = credits;

      emit(PersonDetailLoaded(personDetail));
    } on DioError catch (error) {
      if (error.response != null) {
        emit(PersonError(error.response?.data['status_message']));
      } else {
        emit(PersonError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(PersonError('Erro desconhecido.'));
    }
  }
}
