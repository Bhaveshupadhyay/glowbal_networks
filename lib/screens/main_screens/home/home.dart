import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zeus/adapter/continue_watching.dart';
import 'package:zeus/adapter/movie.dart';
import 'package:zeus/modal_class/episode_modal.dart';
import 'package:zeus/modal_class/home_modal.dart';

import '../../../modal_class/continue_watching_modal.dart';
import '../../../utils/utils.dart';
import '../../season_details/season_details.dart';
import '../../see_all/see_all.dart';
import '../episode/episode_detail.dart';
import 'home_cubit.dart';
import 'home_state.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return context.read<SliderCubit>().loadSlider();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 320.h,
                  width: double.infinity,
                  child: BlocListener<SliderCubit,SliderState>(
                    listener: (BuildContext context, state) {
                      if(state is SliderDataLoaded){
                        context.read<ContinueWatchingCubit>().loadContinueEpisodes();
                      }
                    },
                    child: BlocBuilder<SliderCubit,SliderState>(
                      builder: (context,state){
                        if(state is SliderDataLoading){
                          return _sliderShimmer(context);
                        }
                        else if(state is SliderDataLoaded){
                          return CarouselSlider.builder(
                              itemCount: state.list.length,
                              itemBuilder: (itemBuilder,index,i){
                                return SizedBox(
                                    width: double.infinity,
                                    // height: 350,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,MaterialPageRoute(builder: (builder)=> SeasonDetails(videoModal: state.list[index],)));
                                      },
                                      child: Container(
                                        height: 300.h,
                                        width: double.infinity,
                                        foregroundDecoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Colors.transparent, Colors.transparent,Colors.transparent,Colors.transparent,Colors.transparent, Color(0xff0f1014), ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            )
                                        ),
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
                                          imageUrl:  state.list[index].image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                );
                              },
                              options: CarouselOptions(
                                  initialPage: 2,
                                  autoPlay: true,
                                  viewportFraction: 1,
                                  aspectRatio: 1
                              )
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),

                SizedBox(height: 30.h,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocListener<ContinueWatchingCubit,ContinueWatchingEpisodesState>(
                      listener: (BuildContext context, ContinueWatchingEpisodesState state) {
                        if(state is ContinueEpisodesLoaded){
                          context.read<HomeCubit>().loadHomeData(0);
                        }
                      },
                      child: BlocBuilder<ContinueWatchingCubit,ContinueWatchingEpisodesState>(
                          builder: (context,state){
                            // return _videoShimmer(context);
                            if(state is ContinueEpisodesLoading || state is ContinueEpisodesInitial){
                              return _videoShimmer(context);
                            }
                            else if(state is ContinueEpisodesLoaded){
                              // print(state.list.length);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...List.generate(state.list.length, (index){
                                    return _continueWatching(state.list, context);
                                  })
                                ],
                              );
                            }
                            return Container();
                          }
                      ),
                    ),
                    BlocBuilder<HomeCubit,HomeState>(
                        builder: (context,state){
                          // return _videoShimmer(context);
                          if(state is HomeDataLoading || state is HomeDataInitial){
                            return _videoShimmer(context);
                          }
                          else if(state is HomeDataLoaded){
                            // print(state.list.length);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...List.generate(state.list.length, (index){
                                  return homeWidget(state.list[index], context);
                                })
                              ],
                            );
                          }
                          return Container();
                        }
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget _continueWatching(List<ContinueWatchingModal> list,BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text('Continue Watching',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            // SizedBox(width: 5.w,),
            // const Icon(Icons.arrow_forward_ios)
          ],
        ),
        SizedBox(height:10.h),
        SizedBox(
          height: 200.h,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (context,index){
              EpisodeModal episodeModal=list[index].episodeModal;
              double progressPercentage = (int.parse(episodeModal.videoLength) > 0)
                  ? (list[index].lastWatchedPosition / int.parse(episodeModal.videoLength))
                  : 0.0;
              return Padding(
                padding: EdgeInsets.only(left: index==0?10.w: 0.w, right: 10.w),
                child: InkWell(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (builder)=>
                          EpisodeDetail(episodeModal: episodeModal, seasonNumber: '', seasonTitle:'',lastWatchedPosition: list[index].lastWatchedPosition,)));
                    },
                    child: Stack(
                      children: [
                        ContinueWatching(img: episodeModal.image, title: episodeModal.title, videoLength: episodeModal.videoLength,
                          videoWatchedProgress: MediaQuery.of(context).size.width * progressPercentage,),
                      ],
                    )
                ),
              );
            },
            separatorBuilder: (context,index)=>SizedBox(width: 20.w,),
          ),
        ),
        SizedBox(height: 30.h,),
      ],
    );
  }

  Widget homeWidget(HomeModal homeModal,BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (builder)=>
              SeeAll(seasonTitle: homeModal.videoModal.title, seasonNumber: homeModal.latestSeasonNumber, videoId: homeModal.videoModal.id))),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(homeModal.videoModal.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(width: 5.w,),
              const Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
        SizedBox(height:10.h),
        SizedBox(
          height: 200.h,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: homeModal.episodeList.length+1,
            itemBuilder: (context,index){
              return Padding(
                padding: EdgeInsets.only(left: index==0?10.w: 0.w, right: 10.w),
                child: InkWell(
                    onTap: (){
                      if(index==0){
                        Navigator.push(context,MaterialPageRoute(builder: (builder)=> SeasonDetails(videoModal: homeModal.videoModal,)));
                      }
                      else{
                        Navigator.push(context,MaterialPageRoute(builder: (builder)=>
                            EpisodeDetail(episodeModal: homeModal.episodeList[index-1], seasonNumber: homeModal.latestSeasonNumber, seasonTitle:homeModal.videoModal.title)));
                      }
                    },
                    child: Movie(img: index==0? homeModal.videoModal.image : homeModal.episodeList[index-1].image,
                      title: index==0? homeModal.videoModal.title : homeModal.episodeList[index-1].title,
                    videoLength: index==0? '':homeModal.episodeList[index-1].videoLength,)),
              );
            },
            separatorBuilder: (context,index)=>SizedBox(width: 20.w,),
          ),
        ),
        SizedBox(height: 30.h,),
      ],
    );
  }

  Widget _sliderShimmer(BuildContext context){
    return Shimmer(
        gradient: Theme.of(context).brightness==Brightness.dark?
        darkGradient : lightGradient,
        child: Container(
          height: 320.h,
          width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).brightness==Brightness.dark?
                Colors.white:Colors.black,
            )
        )
    );
  }

  Widget _videoShimmer(BuildContext c){
    return Shimmer(
      gradient: Theme.of(c).brightness==Brightness.dark?
      darkGradient : lightGradient,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            ...List.generate(5, (index){
              return Container(
                margin: EdgeInsets.only(bottom: 30.h),
                height: 200.h,
                width: double.infinity,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context,index){
                    return Container(
                        height:150.h,
                        width: 230.w,
                        decoration: BoxDecoration(
                          color: Theme.of(c).brightness==Brightness.dark?
                          Colors.white:Colors.black,
                          borderRadius: BorderRadius.circular(8.r),
                        )
                    );
                  },
                  separatorBuilder: (context,index)=>SizedBox(width: 20.w,),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
