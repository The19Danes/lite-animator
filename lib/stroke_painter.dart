import 'package:flutter/material.dart';

import 'package:lite_animator/models/models.dart';

class StrokePainter extends CustomPainter {
  final Stroke stroke;

  StrokePainter({@required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Color.fromARGB(255, 0, 0, 0);
    paint.strokeCap = StrokeCap.butt;
    paint.strokeWidth = 7.0;
    List<Offset> offsetsList = stroke.locations.map((location) => Offset(location.x, location.y) ).toList();
    for (var i = 0; i < stroke.locations.length - 1; i++) {
      final from = offsetsList[i];
      final to = offsetsList[i + 1];
      canvas.drawLine(from, to, paint);
    }
  }

  @override
  bool shouldRepaint(StrokePainter oldDelegate) => stroke != oldDelegate.stroke;

}