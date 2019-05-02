import 'package:flutter/material.dart';

import 'package:lite_animator/globals/globals.dart';

const int framesPerSecond = 12;

class PlayAnimationPage extends StatelessWidget {
  final List<Image> frames;

  PlayAnimationPage(this.frames);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                  color: CANVAS_COLOR,
                  height: CANVAS_HEIGHT,
                  width: CANVAS_WIDTH,
                  child: AnimationFrame(frames: frames,),
                ),
              ),

          ]),

      bottomSheet: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
          icon: Icon(Icons.stop),
          onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class AnimationFrame extends StatefulWidget {
  final List<Image> frames;

  const AnimationFrame({Key key, this.frames}) : super(key: key);

  @override
  _AnimationFrameState createState() => _AnimationFrameState();
}

class _AnimationFrameState extends State<AnimationFrame> with SingleTickerProviderStateMixin {
  Animation<int> animation;
  AnimationController controller;

  @override
  void initState() {
    double secondsInDouble = (widget.frames.length / 12);
    double milliseconds = secondsInDouble * 1000;
    print('milliseconds : $milliseconds');

    controller =
        AnimationController(duration: Duration(milliseconds: milliseconds.ceil()), vsync: this);
    animation = StepTween(begin: 0, end: widget.frames.length).animate(controller)
      ..addStatusListener((status) {
        if(status == AnimationStatus.completed){
          controller.repeat();
        }
      });
    super.initState();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedFrameChanger(widget.frames, animation: animation,);


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}


class AnimatedFrameChanger extends AnimatedWidget {
  final List<Image> frames;

  AnimatedFrameChanger(this.frames, {Key key, Animation<int> animation})
      : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    final Animation<int> animation = listenable;
    final int currentFrameIndex = animation.value;
    return frames[currentFrameIndex] ?? Container();
  }

}
