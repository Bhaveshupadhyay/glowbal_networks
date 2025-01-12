import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/convert_utils.dart';
import '../../utils/utils.dart';
import '../main_screens/episode/episode_cubit.dart';
import '../main_screens/episode/episode_detail.dart';
import '../season_details/season_cubit.dart';
import '../season_details/season_state.dart';

class SeeAll extends StatelessWidget {
  final String seasonTitle;
  final String seasonNumber;
  final String videoId;
  const SeeAll({super.key, required this.seasonTitle, required this.seasonNumber, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>EpisodesCubit()..loadEpisodes(seasonNumber, videoId, seasonTitle))
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(seasonTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: false,
        ),
        body: BlocBuilder<EpisodesCubit,EpisodesState>(
          builder: (BuildContext context, EpisodesState state) {
            if(state is EpisodesLoading){
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(state is EpisodesLoaded){
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                child: ListView.separated(
                    itemBuilder: (context,index){
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: InkWell(
                          onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (builder)=>
                              EpisodeDetail(episodeModal: state.episodesList[index], seasonNumber: seasonNumber, seasonTitle:seasonTitle))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 200.h,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: CachedNetworkImage(
                                        memCacheWidth: 800,
                                        placeholder: (context, url) =>
                                            Shimmer(
                                                gradient: Theme.of(context).brightness==Brightness.dark?
                                                darkGradient : lightGradient,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),
                                                          topRight: Radius.circular(10.r)),
                                                      color: Colors.black),
                                                )),
                                        imageUrl:  state.episodesList[index].image,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.r)),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 5.w),
                                        child: Text(ConvertUtils.formatDuration(int.parse(state.episodesList[index].videoLength)),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10.h,),
                              Text(state.episodesList[index].title,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context,index)=>SizedBox(height: 30.h,),
                    itemCount: state.episodesList.length
                ),
              );
            }
            return Container();
          },

        ),
      ),
    );
  }
}
