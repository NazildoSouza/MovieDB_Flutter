import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isAndroid
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Carregando...',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CupertinoActivityIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Carregando...',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ],
            ),
    );
  }
}
