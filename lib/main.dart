import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviedb_flutter/src/bloc/simple_bloc_server.dart';
import 'package:moviedb_flutter/src/ui/custom_drawer/main_drawer.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  Bloc.observer = SimpleBlocObserver();
  runApp(MainContainerWidget());
}
