import 'package:flutter/material.dart';
import 'package:moviedb_flutter/src/circle_progress/circle_progress.dart';

class RadialChart extends StatelessWidget {
  const RadialChart({Key? key, required this.voteAverage}) : super(key: key);

  final double voteAverage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.black87,
        ),
        CustomPaint(
          foregroundPainter: CircleProgress(
              voteAverage * 10), // this will add custom painter after child
          child: Container(
            width: 200,
            height: 200,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "${(voteAverage * 10).truncate()}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "%",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 6,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
