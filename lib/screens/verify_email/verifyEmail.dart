import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/widget/continue_watching.dart';
import 'package:zeus/backend/my_api.dart';
import 'package:zeus/main.dart';

class VerifyEmail extends StatefulWidget {
  final bool isCancelSub;
  const VerifyEmail({super.key, required this.isCancelSub});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  String message='';
  String? email;
  bool isLoading=false;
  int _seconds=0;
  Timer? timer;

  _resendOtp(String number) async {
    setState(() {
      isLoading=true;
    });
    // Map<String,dynamic> data=await MyApi().sendOtp(number);
    // message=data['errorMessage'];
    // if(data['isSuccess']){
    //   _seconds=60;
    //   _startTimer();
    // }
    _seconds=60;
    _startTimer();
    setState(() {
      isLoading=false;
    });
  }

  _startTimer(){
    timer=Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  @override
  void initState() {
    _getEmail();
    _seconds=60;
    _startTimer();
    super.initState();
  }

  _getEmail() async {
    final prefs=await SharedPreferences.getInstance();
    setState(() {
      email= prefs.getString('email');
    });
  }

  @override
  void dispose() {
    if(timer!=null){
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _manageSubscription();
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>MyHomePage()),(Route<dynamic> route) => false);
                      },
                      child: Icon(Icons.close_sharp,size: 26.sp,)
                  ),
                ),
                Center(
                    child: Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                          color: const Color(0xffe6f0f5).withOpacity(0.2),
                          shape: BoxShape.circle,
                      ),

                      child: Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                              color: const Color(0xffa4bdd6).withOpacity(0.3),
                              shape: BoxShape.circle
                          ),
                          child: Image.asset('assets/images/email.png',height: 50.h,)),
                    )
                ),
                SizedBox(height: 20.h,),
                Text('Verify your Email',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 23.sp),),
                SizedBox(height: 20.h,),
                Text(widget.isCancelSub? "We've sent a cancellation request to" : "We've sent a verification email to",style: Theme.of(context).textTheme.bodyMedium,),
                SizedBox(height: 5.h,),
                Text("$email",style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.blue),),
                SizedBox(height: 5.h,),
                Text(widget.isCancelSub? "Please click the cancel button in the email to cancel subscription." :
                "Please click the verify button in the email to continue." ,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const Spacer(),
                InkWell(
                  onTap: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>const MyHomePage()),(Route<dynamic> route) => false);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 30.w),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(10.r),

                    ),
                    child: Center(child: Text('Continue',style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18.sp),)),
                  ),
                ),
                SizedBox(height: 20.h,),
                InkWell(
                  onTap: (){
                    if(_seconds==0 && !isLoading){
                      _resendOtp('widget.email');
                      widget.isCancelSub?
                      MyApi.getInstance().sendCancelEmail() :
                      MyApi.getInstance().sendVerifyEmail();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Email sent. Check your spam or junk folder if not received.",
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      });
                    }
                  },
                  child: Text( _seconds!=0? 'Resend link after 00:$_seconds' : "Resend Email",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall!
                        .copyWith(fontSize: 16.sp,
                      decoration: _seconds!=0? TextDecoration.none: TextDecoration.underline,
                      fontWeight: _seconds!=0? FontWeight.normal : FontWeight.bold,
                      letterSpacing:  _seconds!=0? 0: 2
                    ),
                  )
                ),

              ],
            ),
          )
      ),
    );
  }

  Widget _manageSubscription(){
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>MyHomePage()),(Route<dynamic> route) => false);
                      },
                      child: Icon(Icons.close_sharp,size: 26.sp,)
                  ),
                ),
                Center(
                    child: Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: const Color(0xffe6f0f5).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),

                      child: Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                              color: const Color(0xffa4bdd6).withOpacity(0.3),
                              shape: BoxShape.circle
                          ),
                          child: Image.asset('assets/images/email.png',height: 50.h,)),
                    )
                ),
                SizedBox(height: 20.h,),
                Text('Verify your Email',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 23.sp),),
                SizedBox(height: 20.h,),
                Text(widget.isCancelSub? "We've sent a cancellation request to" : "We've sent a verification email to",style: Theme.of(context).textTheme.bodyMedium,),
                SizedBox(height: 5.h,),
                Text("$email",style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.blue),),
                SizedBox(height: 5.h,),
                Text(widget.isCancelSub? "Please click the cancel button in the email to cancel subscription." :
                "Please click the verify button in the email to continue." ,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 10.h,),
                RichText(
                  text: TextSpan(
                      text: 'Or\n',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 20.sp
                      ),
                      children: [
                        TextSpan(
                            text: 'Login to Glowbal.co.uk',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 25.sp,
                            color: Colors.green,
                          ),
                        )
                      ]
                  ),
                  textAlign: TextAlign.center,

                ),
                const Spacer(),
                InkWell(
                  onTap: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>const MyHomePage()),(Route<dynamic> route) => false);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 30.w),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(10.r),

                    ),
                    child: Center(child: Text('Continue',style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18.sp,color: Colors.white),)),
                  ),
                ),
                SizedBox(height: 20.h,),
                InkWell(
                    onTap: (){
                      if(_seconds==0 && !isLoading){
                        _resendOtp('widget.email');
                        widget.isCancelSub?
                        MyApi.getInstance().sendCancelEmail() :
                        MyApi.getInstance().sendVerifyEmail();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Email sent. Check your spam or junk folder if not received. OR Login to Glowbal.co.uk",
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        });
                      }
                    },
                    child: Text( _seconds!=0? 'Resend link after 00:$_seconds' : "Resend Email",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall!
                          .copyWith(fontSize: 16.sp,
                          decoration: _seconds!=0? TextDecoration.none: TextDecoration.underline,
                          fontWeight: _seconds!=0? FontWeight.normal : FontWeight.bold,
                          letterSpacing:  _seconds!=0? 0: 2
                      ),
                    )
                ),

              ],
            ),
          )
      ),
    );
  }
}
