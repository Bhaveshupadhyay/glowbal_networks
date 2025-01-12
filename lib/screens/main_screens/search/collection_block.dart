import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zeus/modal_class/episode_modal.dart';
import 'package:zeus/modal_class/video_modal.dart';
import 'package:zeus/utils/convert_utils.dart';

import '../../../utils/utils.dart';


class CollectionBlock extends StatelessWidget {
  final VideoModal videoModal;
  const CollectionBlock({super.key, required this.videoModal});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedNetworkImage(
                memCacheWidth: 300,
                fit: BoxFit.fill,
                height: 90.h,
                width: 120.w,
                // memCacheHeight: 200,
                placeholder: (context, url){
                  return Shimmer(
                      gradient: Theme.of(context).brightness==Brightness.dark?
                      darkGradient : lightGradient,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),
                                topRight: Radius.circular(10.r)),
                            color: Colors.black),
                      ));
                },
                errorWidget: (context,s,d){
                  return Shimmer(
                      gradient: Theme.of(context).brightness==Brightness.dark?
                      darkGradient : lightGradient,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),
                                topRight: Radius.circular(10.r)),
                            color: Colors.black),
                      ));
                },
                imageUrl: videoModal.image,
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
                  child: Text(ConvertUtils.formatDuration(int.parse(videoModal.videoLength)),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
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
        SizedBox(width: 20.w,),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(videoModal.title,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(videoModal.description,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
        )
      ],
    );
  }
}
