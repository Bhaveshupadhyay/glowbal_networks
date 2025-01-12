import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:zeus/adapter/search_block.dart';
import 'package:zeus/modal_class/episode_modal.dart';
import 'package:zeus/modal_class/user_details.dart';
import 'package:zeus/screens/main_screens/episode/potrait_video.dart';
import 'package:zeus/screens/main_screens/episode/video_cubit.dart';
import 'package:zeus/screens/subscription/plans.dart';
import 'package:zeus/screens/subscription/subscription_cubit.dart';
import 'package:zeus/screens/subscription/subscription_state.dart';
import 'package:zeus/screens/verify_email/verifyEmail.dart';

import '../../../modal_class/comment_modal.dart';
import '../../../modal_class/reply_modal.dart';
import '../../season_details/season_cubit.dart';
import '../../season_details/season_state.dart';
import '../login/login.dart';
import 'comment_reply/comm_reply_cubit.dart';
import 'comment_reply/comm_reply_state.dart';
import 'comment_reply/comment_widget.dart';
import 'comment_reply/reply_widget.dart';
import 'episode_cubit.dart';
import 'pageview_cubit.dart';
import 'landscape_video.dart';

class EpisodeDetail extends StatelessWidget {
  final EpisodeModal episodeModal;
  final String seasonNumber;
  final String seasonTitle;
  final int? lastWatchedPosition;
  EpisodeDetail({super.key, required this.episodeModal, required this.seasonNumber, required this.seasonTitle, this.lastWatchedPosition});

  final PageController _pageController = PageController();
  final TextEditingController _commentController=TextEditingController();
  final TextEditingController _replyController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(UserDetails.id==null){
      return Login();
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>VideoCubit(episodeId: episodeModal.episodeId,lastWatchedPosition: lastWatchedPosition)..initVideoPlayer(link: episodeModal.video, isTrailer: false)),
        // BlocProvider(create: (create)=>SubscriptionCubit()..checkSubscription()),
        BlocProvider(create: (create)=>VideoOrientationCubit()),
        BlocProvider(create: (create)=>EpisodesCubit()
          ..loadNextEpisodes(seasonNumber,seasonTitle,episodeModal.seasonId, episodeModal.episodeId)),
        BlocProvider(create: (create)=>PageViewCubit()),
        BlocProvider(create: (context)=>DesCommCubit()),
        BlocProvider(create: (context)=>CommentCubit(episodeModal.episodeId)..fetchComments()),
        BlocProvider(create: (context)=>ReplyCubit()),
      ],
      child: BlocBuilder<VideoOrientationCubit,Orientation>(
        builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.landscape) {
            return const LandscapeVideo(isTrailer: false,);
          }
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
          return Scaffold(
            body: SafeArea(
                child: Column(
                  children: [
                    const PortraitVideo(),

                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index){
                          context.read<PageViewCubit>().pageChanged(index);
                        },

                        children: [
                          SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(seasonTitle,
                                    style: Theme.of(context).textTheme.bodyMedium,),

                                  Text(episodeModal.title,
                                    style: Theme.of(context).textTheme.titleLarge,),

                                  Text('Season $seasonNumber',
                                    style: Theme.of(context).textTheme.bodySmall,),

                                  SizedBox(height: 25.h,),

                                  Text(episodeModal.description,
                                    style: Theme.of(context).textTheme.bodyMedium,),

                                  SizedBox(height: 30.h,),

                                  BlocBuilder<EpisodesCubit,EpisodesState>(
                                    builder: (BuildContext context, EpisodesState state) {
                                      if(state is EpisodesLoaded){
                                        if(state.episodesList.isNotEmpty){
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Up Next',
                                                style: Theme.of(context).textTheme.titleSmall,),
                                              SizedBox(height: 20.h,),
                                              ...List.generate(state.episodesList.length, (index){
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                                  child: InkWell(
                                                      onTap: ()=>Navigator.pushReplacement(context,
                                                          MaterialPageRoute(builder: (builder)=>EpisodeDetail(episodeModal: state.episodesList[index],
                                                            seasonNumber: seasonNumber,seasonTitle: seasonTitle,))),
                                                      child: SearchBlock(episodeModal: state.episodesList[index])),
                                                );
                                              }),
                                            ],
                                          );
                                        }
                                      }
                                      return Container();
                                    },

                                  )
                                ],
                              ),
                            ),
                          ),
                          BlocBuilder<DesCommCubit,CommentReplyState>(
                            builder: (BuildContext context, CommentReplyState state) {
                              if(state is CommentShow){
                                return _showComments(context);
                              }
                              else if(state is ReplyShow){
                                return _showReplies(state.commentModal,context);
                              }
                              return Container();
                            },

                          )
                        ],
                      ),
                    ),
                    BlocListener<PageViewCubit,int>(
                      listener: (BuildContext context, int currentPage) {
                        // print('currentPage $currentPage');
                        if(currentPage==1){
                          context.read<DesCommCubit>().showComment();
                        }
                      },
                      child: BlocBuilder<PageViewCubit,int>(
                        builder: (BuildContext context, int currentPage) {
                          try{
                            _pageController.animateToPage(
                              currentPage,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                          catch(e){}

                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 2.w),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Theme.of(context).brightness== Brightness.dark? Colors.grey :Colors.grey.shade500,width: 2),
                                borderRadius: BorderRadius.circular(30.r)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: (){
                                    context.read<PageViewCubit>().animatePage(_pageController,0);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w),
                                      decoration: BoxDecoration(
                                          color: currentPage==0?
                                          Theme.of(context).brightness==Brightness.dark? Colors.grey: Colors.grey.shade300
                                              :Colors.transparent,
                                          borderRadius: BorderRadius.circular(30.r)
                                      ),
                                      child: Icon(Icons.play_circle,size: 30.sp,)
                                  ),
                                ),

                                InkWell(
                                  onTap: (){
                                    context.read<PageViewCubit>().animatePage(_pageController,1);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w),
                                      decoration: BoxDecoration(
                                          color: currentPage==1?
                                          Theme.of(context).brightness==Brightness.dark? Colors.grey: Colors.grey.shade300
                                              :Colors.transparent,
                                          borderRadius: BorderRadius.circular(30.r)
                                      ),
                                      child: Icon(Icons.comment,size: 30.sp,)
                                  ),
                                ),
                              ],
                            ),
                          );
                        },

                      ),
                    )
                  ],
                )
            ),
          );
        },
      ),
    );
  }

  Widget _showComments(BuildContext context){
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.75,
      child: BlocListener<CommentCubit,FetchCommentState>(
        listener: (context,state){
          // print(state);
        },
        child: BlocBuilder<CommentCubit,FetchCommentState>(
          builder: (BuildContext context, FetchCommentState state) {
            if(state is CommentLoading){
              return const Center(child: CircularProgressIndicator());
            }
            else if(state is CommentLoaded){
              // List<CommentModal> list=state as
              // print('$state ${state.list.length}');
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Comments',
                          style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        // InkWell(
                        //     onTap: (){
                        //       context.read<DesCommCubit>().hideComment();
                        //     },
                        //     child: Icon(Icons.close_sharp,color: Colors.black,size: 30.r,))
                      ],
                    ),
                    SizedBox(height: 5.h,),
                    const Divider(),
                    SizedBox(height: 5.h,),
                    if(state.list.isNotEmpty)
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (scrollInfo) {
                            if (!state.hasReachedMax &&
                                scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent) {
                              context.read<CommentCubit>().fetchComments();
                            }
                            return true;
                          },
                          child: ListView.separated(
                              itemCount: state.list.length+(state.hasReachedMax?0:1),
                              itemBuilder: (context,index){
                                if(index<state.list.length){
                                  CommentModal commentModal= state.list[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    child: CommentWidget(commentModal: commentModal,isReplyScreen: false,),
                                  );
                                }
                                else{
                                  return Column(
                                    children: [
                                      SizedBox(height: 5.h,),
                                      const CircularProgressIndicator(),
                                      SizedBox(height: 5.h,),
                                    ],
                                  );
                                }
                              },
                              separatorBuilder: (BuildContext context, int index){
                                return SizedBox(height: 25.h,);
                              }
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: 20.h,),
                            Center(
                              child: Text('No comments yet',
                                style: GoogleFonts.poppins(
                                    fontSize: 15.sp
                                ),),
                            ),
                            Text('Say something to start the conversation',
                              style: GoogleFonts.poppins(
                                  color: Theme.of(context).brightness==Brightness.light?
                                  Colors.black54 : Colors.white54,
                                  fontSize: 15.sp
                              ),),

                          ],
                        ),
                      ),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness==Brightness.light?
                              Colors.black12 : Colors.white12,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: TextFormField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Add a comment',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w)
                              ),
                              style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold

                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w,),
                        if(state is CommentInsertLoading)
                          const CircularProgressIndicator()
                        else
                          InkWell(
                              onTap: (){
                                FocusManager.instance.primaryFocus?.unfocus();
                                context.read<CommentCubit>().insertComments(_commentController.text);
                                _commentController.text='';
                              },
                              child: Icon(Icons.send,color: Colors.blue,size: 25.sp,)
                          ),
                      ],
                    )
                  ],
                ),
              );
            }
            else if(state is NotLoggedIn){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>Login()));
              });
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _showReplies(CommentModal commentModal,BuildContext context){
    context.read<ReplyCubit>().fetchReply(commentModal);
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.75,
      child: BlocBuilder<ReplyCubit,FetchReplyState>(
        builder: (context, state) {
          if(state is ReplyLoading){
            return const Center(child: CircularProgressIndicator());
          }
          else if(state is ReplyLoaded){
            // List<CommentModal> list=state as
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: (){
                            context.read<DesCommCubit>().showComment();
                          },
                          child: Icon(Icons.arrow_back_ios,size: 30.r,)),
                      SizedBox(width: 5.w,),

                      Text('Replies',
                        style: TextStyle(

                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const Spacer(),
                      // InkWell(
                      //     onTap: (){
                      //       context.read<DesCommCubit>().hideReply();
                      //     },
                      //     child: Icon(Icons.close_sharp,color: Colors.black,size: 30.r,))
                    ],
                  ),
                  SizedBox(height: 5.h,),
                  const Divider(),
                  SizedBox(height: 5.h,),
                  CommentWidget(commentModal: state.commentModal,isReplyScreen: true,),

                  const Divider(),
                  SizedBox(height: 5.h,),

                  if(state.list.isNotEmpty)
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (!state.hasReachedMax &&
                              scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent) {
                            context.read<ReplyCubit>().loadMoreReply(commentModal);
                          }
                          return true;
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 25.w),
                          child: ListView.separated(
                              itemCount: state.list.length+(state.hasReachedMax?0:1),
                              itemBuilder: (context,index){
                                if(index<state.list.length){
                                  ReplyModal replyModal= state.list[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    child: ReplyWidget(replyModal: replyModal,),
                                  );
                                }
                                else{
                                  return Column(
                                    children: [
                                      SizedBox(height: 5.h,),
                                      const CircularProgressIndicator(
                                        ),
                                      SizedBox(height: 5.h,),
                                    ],
                                  );
                                }
                              },
                              separatorBuilder: (BuildContext context, int index){
                                return SizedBox(height: 20.h,);
                              }
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 20.h,),
                          Center(
                            child: Text('No Reply yet',
                              style: GoogleFonts.poppins(
                                  fontSize: 15.sp
                              ),),
                          ),
                          Text('Say something to start the conversation',
                            style: GoogleFonts.poppins(
                                color: Theme.of(context).brightness==Brightness.light?
                                Colors.black54 : Colors.white54,
                                fontSize: 15.sp
                            ),),

                        ],
                      ),
                    ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness==Brightness.light?
                            Colors.black12 : Colors.white12,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                          child: TextFormField(
                            controller: _replyController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Add a reply',
                                contentPadding: EdgeInsets.symmetric(horizontal: 10.w)
                            ),
                            style: TextStyle(

                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold

                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w,),
                      InkWell(
                          onTap: (){
                            context.read<ReplyCubit>().insertReply(commentModal, _replyController.text);
                            _replyController.text='';
                          },
                          child: state is ReplyInsertLoading? const CircularProgressIndicator():
                          Icon(Icons.send,color: Colors.blue,size: 25.sp,)
                      )
                    ],
                  )
                ],
              ),
            );
          }
          else if(state is UserNotLoggedIn){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>Login()));
            });
          }
          return Container();
        },
      ),
    );
  }
}
