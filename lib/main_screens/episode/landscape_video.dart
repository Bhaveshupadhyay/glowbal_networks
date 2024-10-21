import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import 'video_cubit.dart';
import 'video_state.dart';

class LandscapeVideo extends StatelessWidget {
  final bool isTrailer;
  const LandscapeVideo({super.key, required this.isTrailer});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _hideStatusBar();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_,x){
        context.read<VideoOrientationCubit>().portrait();
        if(isTrailer){
          context.read<VideoCubit>().disposePlayer();
        }
        // SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.portraitUp,
        // ]);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: BlocBuilder<VideoCubit,VideoState>(
              builder: (context,VideoState state){
                if(state is VideoInitialized){
                  // print(state.videoPlayerController.value.isBuffering);
                  return InkWell(
                    onTap: (){
                      context.read<VideoCubit>().toggleControls();
                      _hideStatusBar();
                    },
                    child: Center(
                      child: Stack(
                        children: [
                          VideoPlayer(state.videoPlayerController),

                          ValueListenableBuilder(valueListenable: state.videoPlayerController,
                            builder: (BuildContext context, VideoPlayerValue value, Widget? child) {
                              if(value.isBuffering) {
                                return const Center(child: CircularProgressIndicator(color:  Colors.white,),);
                              }
                              return Container();
                            },
                          ),


                          Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: AnimatedOpacity(
                                  opacity: state.showControls? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: ()=>state.showControls?context.read<VideoCubit>().backwardVideo():
                                        context.read<VideoCubit>().toggleControls(),

                                        child: Container(
                                            padding: EdgeInsets.all(10.r),
                                            decoration: const BoxDecoration(
                                                color: Colors.black26,
                                                shape: BoxShape.circle
                                            ),
                                            child: Icon(
                                              Icons.replay_10,size: 20.sp,color: Colors.white,)
                                        ),
                                      ),
                                      InkWell(
                                        onTap: ()=>state.showControls?context.read<VideoCubit>().toggleVideoPlay():
                                        context.read<VideoCubit>().toggleControls(),
                                        child: Container(
                                          padding: EdgeInsets.all(10.r),
                                          decoration: const BoxDecoration(
                                              color: Colors.black26,
                                              shape: BoxShape.circle
                                          ),
                                          child: Icon(
                                            state.videoPlayerController.value.isPlaying?
                                            Icons.pause:Icons.play_arrow,size: 20.sp,color: Colors.white,),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: ()=>state.showControls?context.read<VideoCubit>().forwardVideo():
                                        context.read<VideoCubit>().toggleControls(),
                                        child: Container(
                                          padding: EdgeInsets.all(10.r),
                                          decoration: const BoxDecoration(
                                              color: Colors.black26,
                                              shape: BoxShape.circle
                                          ),
                                          child: Icon(
                                            Icons.forward_10,size: 20.sp,color: Colors.white,),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ),

                          Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ValueListenableBuilder(
                                  valueListenable: state.videoPlayerController,
                                  builder: (BuildContext context, value, Widget? child) {
                                    final currentPosition = _formatDuration(value.position);
                                    final totalDuration = _formatDuration(value.duration);
                                    return AnimatedOpacity(
                                      opacity: state.showControls? 1.0 : 0.0,
                                      duration: const Duration(milliseconds: 300),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.5),
                                                        spreadRadius: 2,
                                                        blurRadius: 10,
                                                        offset: const Offset(0, 4), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text('$currentPosition : $totalDuration',
                                                    style: Theme.of(context).textTheme.titleSmall!
                                                        .copyWith(color:Colors.white,fontSize: 10.sp),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: ()=>
                                                  state.showControls?
                                                  context.read<VideoOrientationCubit>().portrait():
                                                  context.read<VideoCubit>().toggleControls(),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.5),
                                                            spreadRadius: 2,
                                                            blurRadius: 10,
                                                            offset: const Offset(0, 4), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Icon(Icons.fullscreen_exit,color:Colors.white,size: 20.sp,)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          VideoProgressIndicator(
                                              state.videoPlayerController,
                                              allowScrubbing: true
                                          ),
                                          SizedBox(height: 10.h,)
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                          ),

                          Positioned.fill(
                              child: AnimatedOpacity(
                                opacity: state.showControls? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child:  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: const Offset(0, 4), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Visibility(
                                      visible: state.showControls,
                                      child: DropdownButton<double>(
                                        value: state.videoPlayerController.value.playbackSpeed,
                                        items: [0.5, 1.0, 1.5, 2.0]
                                            .map((speed) => DropdownMenuItem(
                                          value: speed,
                                          child: Text('$speed x',style: Theme.of(context).textTheme.titleSmall!
                                            .copyWith(color:Colors.white,fontSize: 10.sp),),
                                        ))
                                            .toList(),
                                        onChanged: (value) {
                                          if (value != null && state.showControls) {
                                            context.read<VideoCubit>().changeSpeed(value);
                                          }
                                          else{
                                            context.read<VideoCubit>().toggleControls();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ),

                          Positioned.fill(
                              left: 5.w,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: AnimatedOpacity(
                                  opacity: state.showControls? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: InkWell(
                                    onTap: (){
                                      if(state.showControls) {
                                        context.read<VideoOrientationCubit>().portrait();
                                        if(isTrailer){
                                          context.read<VideoCubit>().disposePlayer();
                                        }
                                      }
                                      else{
                                        context.read<VideoCubit>().toggleControls();
                                      }
                                    },

                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 4), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.close_sharp,size: 20.sp,color: Colors.white,),
                                    ),
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  );
                }
                else if(state is VideoLoading){
                  return Stack(
                    children: [
                      Positioned.fill(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: (){
                                if(isTrailer){
                                  context.read<VideoCubit>().disposePlayer();
                                }
                                context.read<VideoOrientationCubit>().portrait();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.close_sharp,size: 20.sp,color: Colors.white,),
                              ),
                            ),
                          )
                      ),
                      const Center(child: CircularProgressIndicator(color:  Colors.white,),),
                    ],
                  );
                }
                else if(state is VideoError){
                  return Stack(
                    children: [
                      Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Playback error",style: TextStyle(color: Colors.white,fontSize: 12.sp),),
                              SizedBox(height: 5.h),
                              InkWell(
                                onTap: (){
                                  context.read<VideoCubit>().initVideoPlayer(state.videoLink);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.r)
                                  ),
                                  child: Text("Retry",
                                    style: TextStyle(color: Colors.black,fontSize: 10.sp),
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                      Positioned.fill(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: ()=>Navigator.pop(context),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios,size: 30.sp,color: Colors.white,),
                              ),
                            ),
                          )
                      )
                    ],
                  );
                }
                return Container();
              }
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  void _hideStatusBar(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom
    ]);
  }
}
