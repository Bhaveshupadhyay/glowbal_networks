import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zeus/screens/task/gift_dialog.dart';

class TaskWrite extends StatefulWidget {
  const TaskWrite({super.key});

  @override
  State<TaskWrite> createState() => _TaskWriteState();
}

class _TaskWriteState extends State<TaskWrite> with SingleTickerProviderStateMixin{
  final TextEditingController _emailController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  late Timer timer;

  double offset=50;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  bool _isVisible = true;

  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse('https://video.glowbal.co.uk'));

  @override
  void initState() {
    timer= Timer.periodic(Duration(seconds: 1), (timer){
      if(timer.isActive && !_scrollController.position.outOfRange &&
          _scrollController.position.pixels != _scrollController.position.maxScrollExtent){
        // print(_scrollController.position);
        _scrollController.animateTo(_scrollController.offset+50, duration: Duration(seconds: 1), curve: Curves.easeInOut,);
        offset+=50;
      }
    });
    _controller = AnimationController(
      duration: Duration(seconds: 5), // Set animation duration
      vsync: this,
    );



    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isVisible = false;  // Hide the widget when animation is complete
        });
      }
    });
    super.initState();
  }
  final List<String> list=['https://i.giphy.com/Te1AWoObwoR5aCjzn4.webp',
    'https://i.giphy.com/SiEsfvfh3gixSwYV5F.webp',
    'https://media2.giphy.com/media/l0K3Z8xWzy0MzbVlK/giphy.webp?cid=ecf05e47ywzl8q4t465b2rwpaok67u6qo0vd9hs944dy5r7t&ep=v1_gifs_search&rid=giphy.webp',
    'https://i.giphy.com/3o85gaCV88we8SYJOM.webp',
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
          builder: (context){
            return Column(
              children: [
                SizedBox(
                  child: Stack(
                    children: [
                      SizedBox(
                          height: 0.89.sh,
                          child: WebViewWidget(controller: controller)
                      ),

                      // CachedNetworkImage(
                      //   memCacheWidth: 800,
                      //   height: 0.89.sh,
                      //   placeholder: (context, url) =>
                      //       Shimmer(
                      //           gradient: Theme.of(context).brightness==Brightness.dark?
                      //           darkGradient : lightGradient,
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),
                      //                     topRight: Radius.circular(10.r)),
                      //                 color: Colors.black),
                      //           )),
                      //   // imageUrl:  list[Random().nextInt(3)],
                      //   imageUrl:  list[3],
                      //   fit: BoxFit.fitHeight,
                      // ),

                      Positioned.fill(
                        child: SafeArea(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                              child: SizedBox(
                                height: 400.h,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: 12,
                                  itemBuilder: (context,index){
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 40.h,
                                          width: 40.w,
                                          padding: EdgeInsets.all(10.r),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.pink
                                          ),
                                          child: Center(
                                            child: Text('U',
                                              style: Theme.of(context).textTheme.titleSmall,),
                                          ),
                                        ),
                                        SizedBox(width: 15.w,),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('$index Zayn',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 2.h,),
                                              Text('hi looks good',
                                                style: TextStyle(
                                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                                    fontSize: 15.sp,
                                                    color: Colors.white
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),

                                              SizedBox(height: 15.h,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned.fill(
                        child: SafeArea(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 25.sp,),
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(Colors.black26)
                              ),
                            ),
                          ),
                        ),
                      ),

                      ...List.generate(10, (index){
                        double x=(Random().nextInt(10)) * 0.1;
                        return Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Opacity(
                              opacity: _isVisible?1: 0,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(x, 5), // Starting from the bottom (1 on the Y-axis)
                                  end: Offset(x, -5),   // Ending at the top (0 on the Y-axis)
                                ).animate(CurvedAnimation(
                                  parent: _controller,
                                  curve: Curves.easeOut, // You can change this to any curve you like
                                )),
                                child: CachedNetworkImage(
                                  width: 80.w,
                                  height: 80.h,
                                  memCacheWidth: 500,
                                  // imageUrl:  list[Random().nextInt(3)],
                                  imageUrl:  'https://i.giphy.com/LOnt6uqjD9OexmQJRB.webp',
                                ),
                              ),
                            ),
                          ),
                        );
                      })

                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                          margin: EdgeInsets.symmetric(horizontal: 15.w,),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Write your task...',
                                    hintStyle: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: GoogleFonts.poppins().fontFamily,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                                  ),

                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold

                                  ),
                                ),
                              ),
                              Icon(Icons.send,color: Colors.black,size: 25.sp,),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          _triggerAnimation();
                          // _showDialog(context: context,);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/gift.png',
                              height: 40.h,
                              width: 40.w,
                            ),
                            Text('Gift',
                              style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  color: Colors.white
                              ),)
                          ],
                        ),
                      ),
                      SizedBox(width: 20.w,)
                    ],
                  ),
                ),
              ],
            );
          }
      ),
    );
  }

  void _showDialog({required BuildContext context,}){

    showBottomSheet(
        context: context,
        constraints: BoxConstraints.expand(
            width: double.infinity,
            height: 400.h
        ),
        clipBehavior: Clip.none,
        shape: const LinearBorder(),
        builder: (context){
          return GiftDialog();
        }
    );
  }

  void _triggerAnimation() {
    setState(() {
      _isVisible = true;  // Make the widget visible again when clicked
    });
    _controller.reset(); // Reset the controller to start animation from the beginning
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _emailController.dispose();
    _scrollController.dispose();
    _controller.dispose();
    timer.cancel();
    super.dispose();
  }
}


