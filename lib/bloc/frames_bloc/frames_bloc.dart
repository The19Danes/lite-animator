import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';

import 'package:lite_animator/bloc/frames_bloc/frames_event.dart';
import 'package:lite_animator/bloc/painter_bloc/painter_bloc.dart';
import 'package:lite_animator/models/models.dart';

class FramesBloc extends Bloc<FramesEvent, BuiltList<DrawPanel>>{
  BuiltList<DrawPanel> frames = BuiltList<DrawPanel>();
  int currentFrameIndex = 0;
  PainterBloc clipboardFramePainterBloc;

   DrawPanel get currentFrame => frames[currentFrameIndex];

  @override
  BuiltList<DrawPanel> get initialState => frames;

  @override
  Stream<BuiltList<DrawPanel>> mapEventToState(FramesEvent event) async* {
    if(event is InitializeFrameList){
      final DrawPanel initialFrame = DrawPanel(PainterBloc(), null);
      frames = frames.rebuild((b) => b.add(initialFrame));
      currentFrameIndex = 0;
      yield frames;
    }
    else if(event is AddFrame){
      print('Adding a frame');
      frames = frames.rebuild((b) => b.add(DrawPanel(PainterBloc(), null)));
      currentFrameIndex = frames.length - 1;
      yield frames;
    }
    else if(event is ChangeFrame){
      print('changing to frame : ${event.frameIndex}');
      currentFrameIndex = event.frameIndex;
      yield frames;
    }
    else if(event is DeleteFrame){
      print('Deleting frame : ${event.frameIndex}, current frame is : $currentFrameIndex');
      if(currentFrameIndex >= event.frameIndex){//TODO check if bug fixed by adding '&& currentFrameIndex > 0'
        currentFrameIndex--;
      }
      frames = frames.rebuild((b) => b.removeAt(event.frameIndex));
      if(frames.isEmpty){
        frames = frames.rebuild((b) => b.add(DrawPanel(PainterBloc(), null)));
        currentFrameIndex = 0;
      }
      print('after deleting frame  ${event.frameIndex}, current frame in bloc is : $currentFrameIndex');
      yield frames;
    }
    else if(event is SaveGIF){
      print('saving a .gif : ');
    }
    else if(event is NewFrameToLeft){
      int indexToLeft = event.frameIndex;
      print('New frame to left of ${event.frameIndex} at index : $indexToLeft');
      frames = frames.rebuild((b) => b.insert(indexToLeft, DrawPanel(PainterBloc(), null)));
      currentFrameIndex = indexToLeft;
      yield frames;
    }
    else if(event is NewFrameToRight){
      int indexToRight = event.frameIndex + 1;
      print('New frame to left of ${event.frameIndex} at index : $indexToRight');
      frames = frames.rebuild((b) => b.insert(indexToRight, DrawPanel(PainterBloc(), null)));
      currentFrameIndex = indexToRight;
      yield frames;
    }
    ///CopyFrameToLeft is somewhat redundant. Result is still two adjacent copies.
    ///Difference is minor: what becomes the current frame.
//    else if(event is CopyFrameToLeft){
//      int indexToLeft = event.frameIndex;
//      print('Copying frame to left of ${event.frameIndex} at index : $indexToLeft');
//      BuiltList<Stroke> copy = BuiltList.from(frames[event.frameIndex].painterBloc.strokes);
//      PainterBloc dupPainterBloc = PainterBloc(strokes: copy);
//      frames = frames.rebuild((b) => b.insert(indexToLeft, DrawPanel(dupPainterBloc, null)));
//      currentFrameIndex = indexToLeft;
//      yield frames;
//    }
    else if(event is CopyFrameToRight){
      int indexToRight = event.frameIndex + 1;
      print('Copying frame to left of ${event.frameIndex} at index : $indexToRight');
      BuiltList<Stroke> copy = BuiltList.from(frames[event.frameIndex].painterBloc.strokes);
      PainterBloc dupPainterBloc = PainterBloc(strokes: copy);
      frames = frames.rebuild((b) => b.insert(indexToRight, DrawPanel(dupPainterBloc, null)));
      currentFrameIndex = indexToRight;
      yield frames;
    }
    else if(event is CopyFrameToClipboard){
      print('copying frame ${event.frameIndex} to clipboard');
      BuiltList<Stroke> copy = BuiltList.from(frames[event.frameIndex].painterBloc.strokes);
      clipboardFramePainterBloc = PainterBloc(strokes: copy);
      print('clipboardFramePainterBloc after copy: $clipboardFramePainterBloc');
      yield frames;
    }
    else if(event is PasteFrameFromClipboardToRight){
      int indexToRight = event.frameIndex + 1;
      print('pasting frame from clipboard to right of ${event.frameIndex} at index: $indexToRight');
      if(clipboardFramePainterBloc == null){
        print('nothing to paste');
      }
      else{
        frames = frames.rebuild((b) => b.insert(indexToRight, DrawPanel(clipboardFramePainterBloc, null)));
        //clipboardFramePainterBloc = null; //uncomment to allow frame to only be pasted once
        yield frames;
      }
    }
  }


}
