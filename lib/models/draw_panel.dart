import 'dart:typed_data';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;

import 'package:lite_animator/bloc/bloc.dart';
import 'package:lite_animator/globals/globals.dart';
import 'package:lite_animator/models/stroke.dart';
import 'package:lite_animator/models/touch_location.dart';
import 'package:lite_animator/strokes_painter.dart';

class DrawPanel extends StatefulWidget {
  final PainterBloc painterBloc;
  final String existingProjectURL;

  DrawPanel(this.painterBloc, this.existingProjectURL);

  Future<Uint8List> _getImageBuffer(ui.Image capturedImage) async {
    var imageBytes =
        await capturedImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List buffer = imageBytes.buffer
        .asUint8List(imageBytes.offsetInBytes, imageBytes.lengthInBytes);
    return buffer;
  }

  ///Helper function for creating a gif.
  ///Existing packages and resources for making a gif seem difficult to use.
  ///Thus I may not implement saving gifs. Then this function can be deleted
  Future<Uint8List> getPanelImageBuffer() async {
    if (!painterBloc.isEmpty) {
      ui.Image capturedImage = await painterBloc.captureCanvas();
      try {
        Uint8List buffer = await _getImageBuffer(capturedImage);
        return buffer;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<Image> getPanelImage() async {
    if (!painterBloc.isEmpty) {
      ui.Image capturedImage = await painterBloc.captureCanvas();
      try {
        Uint8List buffer = await _getImageBuffer(capturedImage);
        Image image = Image.memory(buffer);
        return image;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  @override
  _DrawPanelState createState() => _DrawPanelState();
}

class _DrawPanelState extends State<DrawPanel> {
  _DrawPanelState() {
    PainterBloc().dispatch(Clear());
  }

  Future<ui.Image> get capturedImage => widget.painterBloc.captureCanvas();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget.painterBloc,
      builder: (BuildContext context, BuiltList<Stroke> strokes) {
        return ClipRect(
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: CANVAS_WIDTH,
            width: CANVAS_HEIGHT,
            color: CANVAS_COLOR,
            child: LayoutBuilder(
              builder: (context, constraint) {
                return GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) {
                    final translation = context
                        ?.findRenderObject()
                        ?.getTransformTo(null)
                        ?.getTranslation();
//                    widget.painterBloc.dispatch(ContinueStroke(TouchLocation(
//                        x: details.globalPosition.dx - translation.x,
//                        y: details.globalPosition.dy - translation.y)));
                      widget.painterBloc.dispatch(ContinueStroke(TouchLocation( (b) => b
                          ..x = details.globalPosition.dx - translation.x
                          ..y = details.globalPosition.dy - translation.y)));
                  },
                  onPanEnd: (DragEndDetails details) =>
                      widget.painterBloc.dispatch(EndStroke()),
                  behavior: HitTestBehavior.translucent,
                  dragStartBehavior: DragStartBehavior.start,
                  child: CustomPaint(
                    painter: StrokesPainter(
                        strokes: strokes,
                        existingProjectURL: widget.existingProjectURL),
                    size: Size.infinite,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
