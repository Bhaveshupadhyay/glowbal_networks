import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:zeus/backend/my_api.dart';
import 'package:zeus/main_screens/episode/video_state.dart';

class VideoCubit extends Cubit<VideoState>{
  VideoCubit({this.episodeId,this.lastWatchedPosition}):super(VideoInitial());
  late VideoPlayerController _controller;
  bool _showControls=false;
  bool _isControlChecking=false;
  final String? episodeId;
  final int? lastWatchedPosition;

  void initVideoPlayer(String link){
    // print(link);
    // link="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4";
    WakelockPlus.enable();
    emit(VideoLoading());
    try {
      _controller.dispose();
    } catch (e) {
      // print('null');

    }

    _controller = VideoPlayerController.networkUrl(Uri.parse(
        link))
      ..initialize().then((_) {

        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        if(!isClosed) {
          if(lastWatchedPosition!=null){
            _controller.seekTo(Duration(seconds: lastWatchedPosition??0));
          }
          _controller.play();
          _showControls=false;
          emit(VideoInitialized(_controller,_showControls));
        }
      },onError: (_){
        if(!isClosed){
          emit(VideoError(link));
        }
      });
    _controller.addListener(() async {
      if(_controller.value.isPlaying && _showControls && !_isControlChecking){
        _isControlChecking=true;
        await Future.delayed(const Duration(seconds: 3));
        _isControlChecking=false;
        if(_controller.value.isPlaying && _showControls && !isClosed){
          // print("showC $_showControls");
          _showControls=!_showControls;
          emit(VideoInitialized(_controller,_showControls));
        }
      }
    });

    }

  void toggleControls(){
    _showControls=!_showControls;
    emit(VideoInitialized(_controller,_showControls));
  }

  void toggleVideoPlay(){
    _controller.value.isPlaying?
        _controller.pause(): _controller.play();

    emit(VideoInitialized(_controller,_showControls));
  }

  void forwardVideo(){
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  void disposePlayer(){
    _controller.dispose();
  }

  void backwardVideo(){
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  void changeSpeed(double speed){
    _controller.setPlaybackSpeed(speed);
    emit(VideoInitialized(_controller,_showControls));
  }

  void updateContinueWatchingEpisode(){
    if(episodeId!=null) {
      MyApi.getInstance().updateContinueEpisode(episodeId!, '${_controller.value.position.inSeconds}');
    }
  }

  @override
  Future<void> close() {
    // print('dispose');
    updateContinueWatchingEpisode();
    WakelockPlus.disable();
    _controller.dispose();
    return super.close();
  }

}

class VideoOrientationCubit extends Cubit<Orientation>{
  VideoOrientationCubit():super(Orientation.portrait);

  void landscape(){
    emit(Orientation.landscape);
  }

  void portrait(){
    emit(Orientation.portrait);
  }
}


