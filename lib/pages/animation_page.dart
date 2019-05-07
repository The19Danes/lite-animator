import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:lite_animator/bloc/bloc.dart';
import 'package:lite_animator/models/models.dart';
import 'package:lite_animator/pages/play_animation_page.dart';

class AnimationPage extends StatefulWidget {
  AnimationPage();

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  final FramesBloc _framesBloc = FramesBloc();
  int currentFrameIndex = 0;

  @override
  void initState() {
    _framesBloc.dispatch(InitializeFrameList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO add scroll controller?
    return BlocBuilder(
        bloc: _framesBloc,
        builder: (BuildContext context, BuiltList<DrawPanel> frames) {
          if (frames.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          print("in animation page, bloc's current frame index : ${_framesBloc.currentFrameIndex}");
          DrawPanel currentFrame = _framesBloc.currentFrame;
          currentFrameIndex = _framesBloc.currentFrameIndex;

          return Scaffold(
            persistentFooterButtons: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => currentFrame.painterBloc.dispatch(Clear()),
                ),
                IconButton(
                  icon: Icon(Icons.undo),
                  onPressed: () =>
                      currentFrame.painterBloc.dispatch(UndoStroke()),
                ),
                IconButton(
                  icon: Icon(Icons.redo),
                  //color: currentFrame.painterBloc.undoHistory.isEmpty ? Colors.grey : Colors.black,
                  onPressed: () =>
                      currentFrame.painterBloc.dispatch(RedoStroke()),
                ),
//                //TODO implement saving
//                  IconButton(
//                    icon: Icon(Icons.save),
//                    onPressed: () {
//                      List<Future<Image>> frameImages = getFrames(frames);
//                      Future.wait(frameImages).then((value) => _framesBloc.dispatch(SaveGIF(value)));
//                    },
//                  ),
              ],
            ),
            Row(children: <Widget>[
              IconButton(
                tooltip: "New Frame To Left",
                icon: Icon(Icons.flip_to_back),
                onPressed: () => _framesBloc.dispatch(NewFrameToLeft(currentFrameIndex)),
              ),
              IconButton(
                tooltip: "New Frame To Right",
                icon: Icon(Icons.flip_to_front),
                onPressed: () => _framesBloc.dispatch(NewFrameToRight(currentFrameIndex)),
              ),
              IconButton(
                tooltip: "Duplicate",
                icon: Icon(Icons.control_point_duplicate),
                onPressed: () => _framesBloc.dispatch(CopyFrameToRight(currentFrameIndex)),
              ),
              IconButton(
                tooltip: "Copy to Clipboard",
                icon: Icon(Icons.content_copy),
                onPressed: () => _framesBloc.dispatch(CopyFrameToClipboard(currentFrameIndex)),
              ),
              IconButton(
                tooltip: "Paste",
                icon: Icon(Icons.content_paste),
                onPressed: () => _framesBloc.dispatch(PasteFrameFromClipboardToRight(currentFrameIndex)),
              ),
            ],),
            ],
            appBar: AppBar(
              title: Text('Animation'),
            ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.black,
                child: Icon(Icons.play_arrow),
                onPressed: () {
                  playButtonPress(frames, context);
                },
              ),
              body: Center(
                child: currentFrame,
              ),
              bottomNavigationBar: Container(
                height: 75,
                margin: EdgeInsets.all(0),
                child: BlocProvider(
                  bloc: _framesBloc,
                  child: FramesList(frames: frames,),
                ),
              ));
        });
  }

  List<Future<Image>> getFrames(BuiltList<DrawPanel> frames) {
    List <Future<Image>> frameImages = [];
    for(var frame in frames){
    frameImages.add(frame.getPanelImage());
    }
    return frameImages;
  }

  Future pushPlayPageRoute(BuildContext context, List<Image> value) {
    return Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => PlayAnimationPage(value))
                );
  }

  void playButtonPress(BuiltList<DrawPanel> frames, BuildContext context) {
    List<Future<Image>> frameImages = getFrames(frames);
    Future.wait(frameImages).then((value) => pushPlayPageRoute(context, value));
  }
}

class CreateNewFrameButton extends StatelessWidget {
  const CreateNewFrameButton({
    Key key,
    @required FramesBloc framesBloc,
  }) : _framesBloc = framesBloc, super(key: key);

  final FramesBloc _framesBloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(10),
        width: 75,
        color: Colors.grey,
        child: IconButton(
          icon: Icon(
            Icons.add,
            size: 40,
            color: Colors.white,
          ),
          onPressed: () {
            _framesBloc.dispatch(AddFrame());
          },
        ),
      ),
    );
  }
}


class FramesList extends StatefulWidget {
  final BuiltList<DrawPanel> frames;

  FramesList({Key key, this.frames}) : super(key: key);

  @override
  _FramesListState createState() => _FramesListState();
}

class _FramesListState extends State<FramesList> {
  int currentFrameIndex = 0;

  @override
  Widget build(BuildContext context) {
    FramesBloc _framesBloc = BlocProvider.of<FramesBloc>(context);
    BuiltList<DrawPanel> frames = widget.frames;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: frames == null ? 0 : frames.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == frames.length) {
          //new frame button
          return CreateNewFrameButton(framesBloc: _framesBloc);
        } else {
          // existing frame
          Future<Image> frameThumbnail =
          _framesBloc.frames[index].getPanelImage();
          return FutureBuilder(
            future: frameThumbnail,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('Error in the snapshot!! ${snapshot.error}');
              }
              return GestureDetector(
                onDoubleTap: () {
                  _framesBloc.dispatch(DeleteFrame(index));
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  width: 75,
                  color: index == _framesBloc.currentFrameIndex
                      ? Colors.redAccent.withAlpha(100)
                      : Colors.grey,
                  child: snapshot.data ?? Container(),
                ),
                onTap: () {
                  _framesBloc.dispatch(ChangeFrame(index));
                  setState(() {
                    currentFrameIndex = index;
                  });
                },
              );
            },
          );
        }
      },
    );
  }
}

