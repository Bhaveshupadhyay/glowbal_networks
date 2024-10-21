import 'package:video_player/video_player.dart';

abstract class VideoState{}

 class VideoInitial extends VideoState{}

 class VideoLoading extends VideoState{}
 class VideoInitialized extends VideoState{
  final VideoPlayerController videoPlayerController;
  final bool showControls;
  VideoInitialized(this.videoPlayerController, this.showControls);
}

class VideoError extends VideoState{
 final String videoLink;

 VideoError(this.videoLink);
}

 class VideoPaused extends VideoState{}


