import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/convert_utils.dart';
import '../utils/utils.dart';

class Movie extends StatelessWidget {
  final String img;
  final String title;
  final String videoLength;
  const Movie({super.key, required this.img, required this.title, required this.videoLength});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Container(
              //   height:150.h,
              //   width: 230.w,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(8.r),
              //       image:  DecorationImage(
              //           image: NetworkImage(img),
              //           fit: BoxFit.fill
              //       )
              //   ),
              // ),
              SizedBox(
                height:150.h,
                width: 230.w,
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
                    imageUrl:  img,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              if( videoLength.isNotEmpty)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.r)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 5.w),
                    child: Text(ConvertUtils.formatDuration(int.parse(videoLength)),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
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
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
