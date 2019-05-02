import 'dart:collection';
import 'dart:ui' as ui;
import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:lite_animator/bloc/bloc.dart';
import 'package:lite_animator/models/models.dart';
import 'package:lite_animator/strokes_painter.dart';
import 'package:lite_animator/globals/globals.dart';

class PainterBloc extends Bloc<PainterEvent, BuiltList<Stroke>> {
  // Completed strokes
  BuiltList<Stroke> strokes;

  // In progress stroke
  BuiltList<TouchLocation> locations = BuiltList<TouchLocation>();

  //Dart doesn't have a stack, using queue operations for restoring undone strokes
  Queue<Stroke> undoHistory = Queue<Stroke>();

  bool get isEmpty => strokes.isEmpty;

  PainterBloc({this.strokes}) {
    if(this.strokes == null){
      this.strokes = BuiltList<Stroke>();
    }
}

//  PainterBloc copy(){
//    return PainterBloc(
//      strokes: this.strokes,
//    );
//  }

  @override
  BuiltList<Stroke> get initialState => strokes ?? BuiltList<Stroke>();

  @override
  Stream<BuiltList<Stroke>> mapEventToState(PainterEvent event) async* {
    if(event is ContinueStroke){
      print("Continuing a stroke at ${event.strokePoint}");
      locations = locations.rebuild((b) => b.add(event.strokePoint));
      print("locations count while continuing a stroke: ${locations.length}");
      final allStrokes = strokes.rebuild((b) => b.add(Stroke(locations: locations)));
      yield allStrokes;
    }
    else if(event is EndStroke){
      print("Ended a stroke");
      if (locations.length > 0) {
        strokes = strokes.rebuild((b) => b.add(Stroke(locations: locations)));
        locations = BuiltList<TouchLocation>();
        print("On stroke end, strokes count is: ${strokes.length}");
      }
      // After finishing a stroke, it should not be possible to redo any strokes.
      // Clear the history of undone strokes
        undoHistory.clear();
        yield strokes;
    }
    else if(event is Clear){
      print("Clearing all strokes");
      strokes = BuiltList<Stroke>();
      locations = BuiltList<TouchLocation>();
      undoHistory.clear();
      yield strokes;
    }
    else if(event is UndoStroke){
      print("Undoing a stroke");
      if(strokes.length != 0){
        undoHistory.addLast(strokes.last);
        strokes = strokes.rebuild((b) => b..removeLast());
      }
      yield strokes;
    }
    else if(event is RedoStroke){
      if(undoHistory.length > 0) {
        print("Redoing a stroke");
        Stroke restoredStroke = undoHistory.removeLast();
        strokes = strokes.rebuild((b) => b..add(restoredStroke));
        yield strokes;
      }
    }
    else if(event is RenderPainting){
      print("saving this file: ${event.drawingName}");
      ui.Image image = await captureCanvas();
      await storeImagePNG(image, event);
    }
  }

  Future storeImagePNG(ui.Image image, RenderPainting event) async {
    var pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final buffer = pngBytes.buffer;
    try{
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseUser firebaseUser = await _auth.currentUser();
      final StorageReference storageRef = FirebaseStorage.instance.ref();
      final usersDirectoryRef = storageRef.child('user/${firebaseUser.uid}/');
      final newDrawingRef = usersDirectoryRef.child('${event.drawingName}.png');
      final uploadTask = newDrawingRef.putData(buffer.asUint8List(pngBytes.offsetInBytes, pngBytes.lengthInBytes));
      final StorageTaskSnapshot downloadUrl =
      (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      print('URL Is $url');

      Firestore.instance.collection('users').document('${firebaseUser.uid}').updateData({
        'projects.${event.drawingName}': url,
      });
    } catch(e) {
      print(e);
    }
  }

  Future<ui.Image> captureCanvas() async {
    ui.PictureRecorder picRecorder = ui.PictureRecorder();
    Canvas canvas = Canvas(picRecorder, Rect.fromLTRB(0, 0, CANVAS_HEIGHT, CANVAS_WIDTH));
    StrokesPainter painter = StrokesPainter(strokes: strokes, );
    painter.paint(canvas, Size.infinite);
    ui.Image image = await picRecorder.endRecording().toImage(CANVAS_HEIGHT.round(), CANVAS_WIDTH.round());
    return image;
  }
}