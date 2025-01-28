import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:zeus/backend/my_api.dart';
import 'package:zeus/modal_class/video_data.dart';
import 'package:zeus/screens/main_screens/episode/video_state.dart';

class VideoCubit extends Cubit<VideoState>{
  VideoCubit({this.episodeId,this.lastWatchedPosition}):super(VideoInitial());
  VideoPlayerController? _controller;
  bool _showControls=false;
  bool _isControlChecking=false;
  final String? episodeId;
  int? lastWatchedPosition;
  VideoData? videoData;
  String? currentQuality;


  Future<void> loadVideo({String? link,String? trailerId, required bool? isTrailer,}) async {
    WakelockPlus.enable();
    emit(VideoLoading());

    videoData= trailerId!=null?
    await MyApi.getInstance().getTrailerUrl(trailerId: trailerId):
    await MyApi.getInstance().getVideoUrl(videoId: link!);

    if(isClosed) return;

    if(isTrailer==true && trailerId!=null){
      link= videoData?.hlsVersions?[0].link??'';
    }
    else{
      // print(link);
      if(videoData?.isSubActive==true){
        //Todo: fix this video links
        link= videoData?.hlsVersions?[0].link??'';
      }
      else{
        emit(SubNotActive());
        return;
      }
    }

    initVideoPlayer(link: link);
  }

  Future<void> initVideoPlayer({required String link,String? quality,}) async {
    // print(link);
    emit(VideoLoading());
    // print(quality);
    try {
      _controller?.dispose();
    } catch (e) {
      // print('null');
    }
    // link="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4";

    _controller = VideoPlayerController.networkUrl(Uri.parse(
        link))
      ..initialize().then((_) {

        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        if(!isClosed) {
          if(lastWatchedPosition!=null){
            _controller!.seekTo(Duration(seconds: lastWatchedPosition??0));
          }
          _controller!.play();
          _showControls=false;
          emit(VideoInitialized(videoPlayerController: _controller!,
              showControls: _showControls,videoQualities: videoData?.qualities,currentQuality: quality));
        }
      },onError: (_){
        if(!isClosed){
          emit(VideoError(link));
        }
      });
    _controller!.addListener(() async {
      if(_controller!.value.isPlaying && _showControls && !_isControlChecking){
        _isControlChecking=true;
        await Future.delayed(const Duration(seconds: 3));
        _isControlChecking=false;
        if(_controller!.value.isPlaying && _showControls && !isClosed){
          // print("showC $_showControls");
          _showControls=!_showControls;
          emit(VideoInitialized(videoPlayerController: _controller!,
              showControls: _showControls,videoQualities: videoData?.qualities,currentQuality: quality));
        }
      }
    });
    }



  void toggleControls(){
    _showControls=!_showControls;
    emit(VideoInitialized(videoPlayerController: _controller!,
        showControls: _showControls,videoQualities: videoData?.qualities));
  }

  void toggleVideoPlay(){
    _controller!.value.isPlaying?
        _controller!.pause(): _controller!.play();

    emit(VideoInitialized(videoPlayerController: _controller!,
        showControls: _showControls,videoQualities: videoData?.qualities));
  }

  void forwardVideo(){
    final currentPosition = _controller!.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _controller!.seekTo(newPosition);
  }

  void disposePlayer(){
    if(_controller!=null) {
      _controller!.dispose();
    }
  }

  void backwardVideo(){
    final currentPosition = _controller!.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _controller!.seekTo(newPosition);
  }

  void changeSpeed(double speed){
    if(speed==_controller!.value.playbackSpeed) return;
    _controller!.setPlaybackSpeed(speed);
    emit(VideoInitialized(videoPlayerController: _controller!,
        showControls: _showControls,videoQualities: videoData?.qualities));
  }

  Future<void> changeQuality(String quality) async {
    if(quality==currentQuality) return;
    // emit(VideoLoading());
    String? link;
    List<VideoVersion>? list;
    if(quality.toLowerCase()=='adaptive'){
      list=videoData?.hlsVersions;
    }
    else if(int.parse(quality)>=720){ //hd versions
      list=videoData?.hdVersions;
    }
    else{
      list=videoData?.sdVersions;
    }
    for(VideoVersion videoVersion in list??[]){
      if(videoVersion.rendition.contains(quality)){
        link=videoVersion.link;
        break;
      }
    }
    // print(link);
    if(link!=null){
      currentQuality=quality;
      lastWatchedPosition=(await _controller?.position)?.inSeconds;
      initVideoPlayer(link: link,quality: quality,);
    }
  }

  void updateContinueWatchingEpisode(){
    if(episodeId!=null && _controller!=null) {
      MyApi.getInstance().updateContinueEpisode(episodeId!, '${_controller!.value.position.inSeconds}');
    }
  }

  @override
  Future<void> close() {
    // print('dispose');
    updateContinueWatchingEpisode();
    WakelockPlus.disable();
    if(_controller!=null) {
      _controller!.dispose();
    }
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


