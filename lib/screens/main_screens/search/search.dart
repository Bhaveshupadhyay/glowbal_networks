
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zeus/adapter/search_block.dart';
import 'package:zeus/screens/main_screens/search/search_cubit.dart';
import 'package:zeus/screens/main_screens/search/search_state.dart';

import '../../../utils/utils.dart';
import '../../season_details/season_details.dart';
import '../episode/pageview_cubit.dart';
import '../episode/episode_detail.dart';
import 'collection_block.dart';

class Search extends StatelessWidget {
  Search({super.key});
  final TextEditingController searchController = TextEditingController();

  final PageController _pageController= PageController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
      child: Column(
        children: [

          Container(
            padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search..',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    ),
                    style: Theme.of(context).textTheme.titleSmall,
                    onChanged: (s){
                      context.read<SearchCubit>().search(s);
                    },
                  ),
                ),
                SizedBox(width: 10.w,),
                InkWell(
                    onTap: (){
                      FocusManager.instance.primaryFocus?.unfocus();
                      context.read<SearchCubit>().search(searchController.text);
                    },
                    child: Icon(Icons.search,color: Colors.blue,size: 25.sp,)),
                SizedBox(width: 10.w,),
              ],
            ),
          ),
          SizedBox(height: 20.h,),
          BlocBuilder<SearchCubit,SearchState>(
              builder: (context,state){
                if(state is RecentLoaded){
                  return Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Recent Searches",style: Theme.of(context).textTheme.titleSmall,),
                            InkWell(
                              onTap: () {
                                context.read<SearchCubit>().clearPrefs();
                              },
                              child: Text("Clear",style: GoogleFonts.poppins(color: Colors.red,fontWeight: FontWeight.bold),),
                            )
                          ],
                        ),
                        SizedBox(height: 10.h,),
                        BlocBuilder<SearchCubit,SearchState>(
                          builder: (BuildContext context, SearchState state) {

                            if(state is RecentLoaded){
                              // print('$state ${state.list.length}');
                              return Expanded(
                                  child: ListView.separated(
                                    itemCount: state.list.length,
                                    itemBuilder: (context,index){
                                      return InkWell(
                                        onTap: (){
                                          searchController.text=state.list[index];
                                          // FocusManager.instance.primaryFocus?.unfocus();
                                        },
                                        child: Text(state.list[index],
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context,index){
                                      return SizedBox(height: 20.h,);
                                    },
                                  )
                              );
                            }
                            return Container();
                          },

                        ),
                      ],
                    ),
                  );
                }
                else if(state is SearchLoading){
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                }
                else if(state is SearchLoaded){

                  return Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 10.h,),
                        BlocBuilder<PageViewCubit,int>(
                          builder: (BuildContext context, int currentPage) {
                            try{
                              _pageController.animateToPage(
                                currentPage,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                            catch(e){}

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      context.read<PageViewCubit>().animatePage(_pageController,0);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 5.h),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: currentPage==0? 2:0,
                                                  color: Theme.of(context).brightness== Brightness.dark?
                                                  Colors.white :Colors.black
                                              )
                                          )
                                      ),
                                      child: Center(
                                        child: Text('Videos',
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                              color: _getColor(context,currentPage,0)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      context.read<PageViewCubit>().animatePage(_pageController,1);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 5.h),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: currentPage==1? 2:0,
                                                  color: Theme.of(context).brightness== Brightness.dark?
                                                  Colors.white :Colors.black
                                              )
                                          )
                                      ),
                                      child: Center(
                                        child: Text('Collections',
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                            color: _getColor(context,currentPage,1)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            );
                          },

                        ),
                        SizedBox(height: 20.h,),
                        Expanded(
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (index){
                                context.read<PageViewCubit>().pageChanged(index);
                              },
                              children: [
                                ListView.separated(
                                  itemCount: state.searchModal.episodesList.length,
                                  itemBuilder: (context,index){
                                    return InkWell(
                                      onTap: (){
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        context.read<SearchCubit>().saveToPrefs();
                                        Navigator.push(context, MaterialPageRoute(builder:
                                            (context)=>EpisodeDetail(episodeModal: state.searchModal.episodesList[index], seasonNumber: '', seasonTitle: '')));
                                      },
                                      child: SearchBlock(episodeModal: state.searchModal.episodesList[index]),
                                    );
                                  },
                                  separatorBuilder: (context,index){
                                    return SizedBox(height: 20.h,);
                                  },
                                ),
                                ListView.separated(
                                  itemCount: state.searchModal.videoList.length,
                                  itemBuilder: (context,index){
                                    return InkWell(
                                      onTap: (){
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        context.read<SearchCubit>().saveToPrefs();
                                        Navigator.push(context, MaterialPageRoute(builder:
                                            (context)=>SeasonDetails(videoModal: state.searchModal.videoList[index])
                                        ));
                                      },
                                      child: CollectionBlock(videoModal: state.searchModal.videoList[index]),
                                    );
                                  },
                                  separatorBuilder: (context,index){
                                    return SizedBox(height: 20.h,);
                                  },
                                ),
                              ],
                            )
                        )
                      ],
                    ),
                  );
                }
                return Container();
              }
          )
        ],
      ),
    );
  }

  Color _getColor(BuildContext context, int currentPage, int index) {
    Brightness brightness= Theme.of(context).brightness;
    if(currentPage==index){
      return brightness== Brightness.dark? Colors.white : Colors.black;
    }
    else{
      return brightness== Brightness.dark? Colors.white54 : Colors.black54;
    }
  }
}
