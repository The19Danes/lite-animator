import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FramesEvent extends Equatable {
  FramesEvent([List props = const []]) : super(props);
}

class InitializeFrameList extends FramesEvent {
  @override
  String toString() => 'InitializeFrameList';
}

class AddFrame extends FramesEvent {
  @override
  String toString() => 'AddFrame';
}

class ChangeFrame extends FramesEvent {
  final int frameIndex;

  ChangeFrame(this.frameIndex);

  @override
  String toString() => 'ChangeFrame { frameIndex: $frameIndex }';
}

class DeleteFrame extends FramesEvent {
  final int frameIndex;

  DeleteFrame(this.frameIndex);

  @override
  String toString() => 'DeleteFrame { frameIndex: $frameIndex }';
}

class SaveGIF extends FramesEvent {
  final List<Image> frameImages;

  SaveGIF(this.frameImages);

  @override
  String toString() => 'SaveGIF { frameImages.length: ${frameImages.length} }';
}

class SaveAnimationProject extends FramesEvent {
  @override
  String toString() => 'SaveAnimationProject';
}

class NewFrameToLeft extends FramesEvent {
  final int frameIndex;

  NewFrameToLeft(this.frameIndex);

  @override
  String toString() => 'NewFrameToLeft { frameIndex: $frameIndex }';
}

class NewFrameToRight extends FramesEvent {
  final int frameIndex;

  NewFrameToRight(this.frameIndex);

  @override
  String toString() => 'NewFrameToRight { frameIndex: $frameIndex }';
}

class CopyFrameToLeft extends FramesEvent {
  final int frameIndex;

  CopyFrameToLeft(this.frameIndex);

  @override
  String toString() => 'CopyFrameToLeft { frameIndex: $frameIndex }';
}

class CopyFrameToRight extends FramesEvent {
  final int frameIndex;

  CopyFrameToRight(this.frameIndex);

  @override
  String toString() => 'CopyFrameToRight { frameIndex: $frameIndex }';
}

class CopyFrameToClipboard extends FramesEvent {
  final int frameIndex;

  CopyFrameToClipboard(this.frameIndex);

  @override
  String toString() => 'CopyFrame { frameIndex: $frameIndex }';
}

class PasteFrameFromClipboardToRight extends FramesEvent {
  final int frameIndex;

  PasteFrameFromClipboardToRight(this.frameIndex);

  @override
  String toString() => 'PasteFrameFromClipboard { frameIndex: $frameIndex }';
}