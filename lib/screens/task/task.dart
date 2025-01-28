import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zeus/screens/task/task_write.dart';

import '../../utils/utils.dart';

class Task extends StatelessWidget {
  const Task({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> list=[
      'https://i.ibb.co/3SQpw1n/pngwing-com-5.png','https://i.ibb.co/25TZrLW/pngwing-com-4.png'];
    return Scaffold(
      body: SizedBox(
        height: 1.sh,
        child: CarouselSlider.builder(
            itemCount: list.length,
            itemBuilder: (itemBuilder,index,i){
              return Stack(
                children: [
                  CachedNetworkImage(
                    memCacheWidth: 800,
                    height: 1.sh,
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
                    imageUrl:  list[index],
                    fit: BoxFit.fitHeight,
                  ),
                  
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset('assets/images/live.gif',height: 60.h,width: 60.w,),
                  ),

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10.w,bottom: 20.h),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 60.h,
                                width: 60.w,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    heroTag: "btn1",
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>TaskWrite()));
                                    },
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.pink,
                                    child: Text('Join',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.sp,
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.h,),
                              // SizedBox(
                              //   height: 60.h,
                              //   width: 60.w,
                              //   child: FittedBox(
                              //     child: FloatingActionButton(
                              //       heroTag: "btn2",
                              //       onPressed: (){},
                              //       foregroundColor: Colors.white,
                              //       backgroundColor: Colors.red,
                              //       child: Icon(Icons.close_sharp,size: 30.sp,),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 10,
                                blurRadius: 10,
                                offset: const Offset(0, 4), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(bottom: 5.h,left: 20.w,right: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Zayn',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 5.w,),
                                  Image.asset('assets/images/social_verified.png',
                                    height: 30.h,
                                    width: 30.w,
                                  )
                                ],
                              ),

                              SizedBox(height: 3.h,),

                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    text: '20',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' years',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18.sp,
                                        ),
                                      )
                                    ]
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            options: CarouselOptions(
                initialPage: 2,
                autoPlay: false,
                viewportFraction: 1,
                aspectRatio: 1,
                enlargeCenterPage: true,
                height: 1.sh,
                enlargeFactor: 0.6
            )
        ),
      ),
    );
  }
}
