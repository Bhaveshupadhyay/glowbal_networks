import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/utils.dart';

class GiftDialog extends StatelessWidget {
  const GiftDialog({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> list=['https://i.giphy.com/3ohhwjCvlkO6qGX6Ra.webp',
    'https://i.giphy.com/ZoZk28cjtWWBZdFVtL.webp',
    'https://i.giphy.com/LOnt6uqjD9OexmQJRB.webp',
    'https://i.giphy.com/rVUgg2B0PPyIq6PQSf.webp',
    'https://i.giphy.com/XEyXIfu7IRQivZl1Mw.webp',
    ];
    return Container(
      color: Colors.grey.shade900,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Define the width of each grid item
          double itemWidth = 100.w;
          // Calculate the number of items that can fit in a row
          int crossAxisCount = (constraints.maxWidth / itemWidth).floor();

          return Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close_sharp,
                      size: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 100.w/150.h
                  ),
                  itemCount: list.length *10,
                  itemBuilder: (context, index) {
                    return Gift(gifLink: list[2]);
                  },
                ),
              ),
              SafeArea(
                minimum: EdgeInsets.only(bottom: 20.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Colors.black
                        ),
                        child: Row(
                          spacing: 2.w,
                          children: [
                            Icon(Icons.currency_bitcoin,
                              size: 15.sp,
                              color: Colors.yellow,
                            ),
                            Text('Recharge',
                              style: GoogleFonts.poppins(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                              maxLines: 1,
                            ),
                            Icon(Icons.arrow_forward_ios,
                              size: 15.sp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

}

class Gift extends StatefulWidget {
  final String gifLink;
  const Gift({super.key, required this.gifLink});

  @override
  State<Gift> createState() => _GiftState();
}

class _GiftState extends State<Gift> {
  
  bool isSelected=false;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          isSelected=!isSelected;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(top: 0.h),
        child: Column(
          children: [
            CachedNetworkImage(
              width: 80.w,
              height: 80.h,
              memCacheWidth: 500,
              placeholder: (context, url) =>
                  Shimmer(
                      gradient: Theme.of(context).brightness==Brightness.dark?
                      darkGradient : lightGradient,
                      child: Container(
                        width: 80.w,
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: Colors.black),
                      )),
              // imageUrl:  list[Random().nextInt(3)],
              imageUrl:  widget.gifLink,
            ),
            if(!isSelected)
              Text('Love Painting',
                style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: Colors.white
                ),
                maxLines: 1,
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.currency_bitcoin,
                  size: 15.sp,
                  color: Colors.yellow,
                ),
                Flexible(
                  child: Text('1',
                    style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),

            if(isSelected)
              GestureDetector(
                onTap: (){
                  print('sent');
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.r),
                          bottomRight: Radius.circular(10.r)
                      )
                  ),
                  child: Center(
                    child: Text('Send',
                      style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}
