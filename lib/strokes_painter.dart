import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';
import 'package:lite_animator/globals/globals.dart';
import 'dart:ui' as ui;


import 'package:lite_animator/models/models.dart';
import 'package:lite_animator/stroke_painter.dart';

/// Ref: https://github.com/SnakeyHips/drawapp
class StrokesPainter extends CustomPainter {
  final BuiltList<Stroke> strokes;
  final String existingProjectURL;
  Image existingImage;

  StrokesPainter({this.existingProjectURL, @required this.strokes})
//  {
//     existingImage = Image(image: CachedNetworkImageProvider(existingProjectURL,));
//  }
  ;

  @override
  void paint(Canvas canvas, Size size) {
    if(existingImage != null){
      print("returning to project with url : $existingProjectURL");
     //TODO paint image on canvas before painting new strokes
      //paintImage(canvas: canvas, rect: Rect.fromLTRB(0, 0, CANVAS_HEIGHT, CANVAS_WIDTH), image: existingImage);
    }
    if (strokes != null) {
      for (final stroke in strokes) {
        StrokePainter(stroke: stroke).paint(canvas, size);
      }
    }
  }

  @override
  bool shouldRepaint(StrokesPainter oldPainter) => strokes != oldPainter.strokes;
}