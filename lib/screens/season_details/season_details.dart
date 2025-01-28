import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zeus/adapter/search_block.dart';
import 'package:zeus/screens/season_details/season_cubit.dart';
import 'package:zeus/screens/season_details/season_state.dart';

import '../../modal_class/video_modal.dart';
import '../main_screens/episode/episode_cubit.dart';
import '../main_screens/episode/episode_detail.dart';
import '../main_screens/episode/landscape_video.dart';
import '../main_screens/episode/video_cubit.dart';
import 'appbar_cubit.dart';

class SeasonDetails extends StatelessWidget {
  SeasonDetails({super.key, required this.videoModal});
  final VideoModal videoModal;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (create) => AppbarCubit()..onScroll(_scrollController)),
        BlocProvider(
            create: (create) => SeasonCubit()..seasonCount(videoModal.id)),
        BlocProvider(create: (create) => EpisodesCubit()),
        BlocProvider(create: (create) => VideoCubit()),
        BlocProvider(create: (create) => VideoOrientationCubit()),
      ],
      child: BlocListener<VideoOrientationCubit, Orientation>(
        listener: (BuildContext context, orientation) {
          if (orientation == Orientation.landscape) {
            context.read<VideoCubit>().loadVideo(trailerId: videoModal.id,isTrailer: true);
          }
        },
        child: BlocBuilder<VideoOrientationCubit, Orientation>(
          builder: (BuildContext context, orientation) {
            if (orientation == Orientation.landscape) {
              return const LandscapeVideo(
                isTrailer: true,
              );
            }
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: SystemUiOverlay.values);
            return Scaffold(
              body: SafeArea(
                top: false,
                bottom: false,
                child: BlocBuilder<AppbarCubit, AppBarState>(
                  builder: (context, state) {
                    return CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 250.h, // Height when expanded
                          floating: false, // The app bar will scroll off screen
                          pinned:
                              true, // The app bar will remain visible at the top
                          centerTitle: false,
                          backgroundColor:
                              Theme.of(context).appBarTheme.backgroundColor,
                          iconTheme:
                              IconThemeData(color: Colors.white, size: 25.sp),
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: false,
                            title: AnimatedOpacity(
                              opacity: state is Collapsed ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                videoModal.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  videoModal.image,
                                  fit: BoxFit.cover,
                                ),
                                // Positioned.fill(
                                //     left: 10.w,
                                //     bottom: 20.h,
                                //     child: Align(
                                //       alignment: Alignment.bottomLeft,
                                //       child: GestureDetector(
                                //         onTap: (){
                                //           print('object');
                                //         },
                                //         child: Container(
                                //           padding: const EdgeInsets.all(15),
                                //           decoration: BoxDecoration(
                                //               color: Colors.black87,
                                //               borderRadius: BorderRadius.circular(5.r)
                                //           ),
                                //           child: Row(
                                //             mainAxisSize: MainAxisSize.min,
                                //             children: [
                                //               const Icon(Icons.play_arrow_rounded,color: Colors.white,),
                                //               Text('Trailer',
                                //                 style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),),
                                //             ],
                                //           )
                                //         ),
                                //       )
                                //     )
                                // ),
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.black12, Colors.black54],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.h, horizontal: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    videoModal.title,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                    child: TextButton.icon(
                                      icon: Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 25.sp,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<VideoOrientationCubit>()
                                            .landscape();
                                      },
                                      label: Text(
                                        'Trailer',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffE50914),
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                    child: TextButton.icon(
                                      icon: Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 25.sp,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<EpisodesCubit>()
                                            .playFirstEpisode();
                                      },
                                      label: Text(
                                        'Start Watching',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    videoModal.description,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  BlocListener<SeasonCubit, SeasonState>(
                                    listener: (BuildContext context,
                                        SeasonState state) {
                                      if (state is SeasonListLoaded) {
                                        // print(state);
                                        context
                                            .read<EpisodesCubit>()
                                            .loadEpisodes(
                                                state.selectedValue,
                                                videoModal.id,
                                                videoModal.title);
                                      }
                                    },
                                    child:
                                        BlocBuilder<SeasonCubit, SeasonState>(
                                            builder: (context, state) {
                                      if (state is SeasonLoading) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (state is SeasonListLoaded) {
                                        return DropdownButton<String>(
                                          value: state.selectedValue,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                          items: state.seasonList
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                'Season $value',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            if (state.selectedValue != value) {
                                              context
                                                  .read<SeasonCubit>()
                                                  .seasonChanged(
                                                      value!, videoModal.id);
                                            }
                                          },
                                        );
                                      }
                                      return Container();
                                    }),
                                  ),
                                ],
                              )),
                        ),
                        BlocListener<EpisodesCubit, EpisodesState>(
                          listener: (BuildContext context, state) {
                            if (state is EpisodesLoaded) {
                              if (state.isPlay) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EpisodeDetail(
                                              episodeModal:
                                                  state.episodesList[0],
                                              seasonNumber: state.seasonNumber,
                                              seasonTitle: videoModal.title,
                                            )));
                              }
                            }
                          },
                          child: BlocBuilder<EpisodesCubit, EpisodesState>(
                              builder: (context, state) {
                            if (state is EpisodesLoading) {
                              return const SliverToBoxAdapter(
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            } else if (state is EpisodesLoaded) {
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 20.w),
                                      child: InkWell(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EpisodeDetail(
                                                        episodeModal:
                                                            state.episodesList[
                                                                index],
                                                        seasonNumber:
                                                            state.seasonNumber,
                                                        seasonTitle:
                                                            videoModal.title,
                                                      ))),
                                          child: SearchBlock(
                                            episodeModal:
                                                state.episodesList[index],
                                          )),
                                    );
                                  },
                                  childCount: state.episodesList
                                      .length, // Number of items in the list
                                ),
                              );
                            }
                            return SliverToBoxAdapter(child: Container());
                          }),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
