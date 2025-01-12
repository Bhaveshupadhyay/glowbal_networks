import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../backend/my_api.dart';
import '../verify_email/verifyEmail.dart';

class SubscriptionRenew extends StatelessWidget {
  const SubscriptionRenew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_sharp,size: 30.sp), // Custom icon
          onPressed: () {
            // Custom action on back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 30.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/renewal.png',height: 80.h,width: 80.w,),
              SizedBox(height: 10.h,),
              Text('Your subscription has expired'
                ,style: Theme.of(context).textTheme.titleMedium,),
              // SizedBox(height: 5.h,),
              Text(
              "We miss you! Renew now to unlock exclusive series and continue enjoying all the amazing content. "
                  "Let’s get you back to your favorite shows!",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,),
              SizedBox(height: 20.h,),
              ElevatedButton(
                  onPressed: (){
                    MyApi.getInstance().sendVerifyEmail();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>const VerifyEmail(isCancelSub: false,)));
                  },
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(Colors.pink),
                    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10.h,horizontal: 30.w)),
                  ),
                  child: Text('Renew',
                    style: TextStyle(color: Colors.white,fontSize: 18.sp),)
              )
            ],
          ),
        ),
      )
      // subState is SubscriptionNotActive || subState is SubscriptionNotExist?
      // Center(
      //   child: Padding(
      //     padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 30.w),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Image.asset('assets/images/renewal.png',height: 80.h,width: 80.w,),
      //         SizedBox(height: 10.h,),
      //         Text(subState is SubscriptionNotActive?
      //         'Your subscription has expired':'Ready for the next level?'
      //           ,style: Theme.of(context).textTheme.titleMedium,),
      //         // SizedBox(height: 5.h,),
      //         Text(subState is SubscriptionNotActive?
      //         "We miss you! Renew now to unlock exclusive series and continue enjoying all the amazing content. "
      //             "Let’s get you back to your favorite shows!" : "Subscribe now to unlock exclusive series and enjoy all the premium content."
      //             " Don’t wait—start watching your favorite shows today!",
      //           style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic),
      //           textAlign: TextAlign.center,),
      //         SizedBox(height: 20.h,),
      //         ElevatedButton(
      //             onPressed: (){
      //               Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>const VerifyEmail()));
      //             },
      //             style: ButtonStyle(
      //               backgroundColor: const WidgetStatePropertyAll(Colors.pink),
      //               padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10.h,horizontal: 30.w)),
      //             ),
      //             child: Text(subState is SubscriptionNotActive? 'Renew' : 'Subscribe',
      //               style: TextStyle(color: Colors.white,fontSize: 18.sp),)
      //         )
      //       ],
      //     ),
      //   ),
      // ):
      // const Center(child: CircularProgressIndicator(),),
    );
  }
}
