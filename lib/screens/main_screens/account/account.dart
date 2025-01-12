import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeus/screens/subscription/subscription_cubit.dart';
import 'package:zeus/screens/subscription/subscription_state.dart';
import 'package:zeus/screens/verify_email/verifyEmail.dart';
import 'package:zeus/theme/theme_cubit.dart';

import '../../../backend/my_api.dart';
import '../../../webview/show_webview.dart';
import '../login/login.dart';
import 'account_cubit.dart';
import 'account_state.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit,AccountState>(
      builder: (context,state){
        if(state is AccountInitial){
          return const Center(child: CircularProgressIndicator(),);
        }
        else if(state is AccountUserDetails){
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                  padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w),
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness==Brightness.dark ?
                      Colors.black54 : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                        )
                      ]
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      state.userDetails.image!=null?
                      Container(
                        height: 80.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(state.userDetails.image??''),
                                fit: BoxFit.cover
                            ),
                            shape: BoxShape.circle
                        ),
                      ):
                      Container(
                        height: 80.h,
                        width: 80.w,
                        padding: EdgeInsets.all(10.r),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          color: Colors.pink
                        ),
                        child: Center(
                          child: Text(state.userDetails.name?.substring(0,1).toUpperCase()??'U',
                          style: Theme.of(context).textTheme.titleLarge,),
                        ),
                      ),
                      SizedBox(width: 20.w,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.userDetails.name??'',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),

                            Text(state.userDetails.email??'',
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.h,),

                BlocBuilder<ThemeCubit,ThemeMode>(
                  builder: (BuildContext context, ThemeMode themeMode) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Dark Theme',style: TextStyle(fontSize: 15.sp),),
                          Switch(
                            value: themeMode == ThemeMode.dark,
                            onChanged: (value){
                              context.read<ThemeCubit>().changeTheme();
                            },
                            thumbIcon: WidgetStatePropertyAll(Icon(Theme.of(context).brightness== Brightness.light? Icons.light_mode : Icons.dark_mode)),
                          ),
                        ],
                      ),
                    );
                  },

                ),

                SizedBox(height: 20.h,),
                _title(context: context, text: 'Contact'),

                SizedBox(height: 10.h,),
                _textBtn(
                    context: context,
                    onTap: (){
                      _launchWhatsApp('15154974913');
                    },
                    icon: Bootstrap.whatsapp,
                    text: 'Whatsapp'
                ),
                SizedBox(height: 10.h,),

                Divider(height: 1.h,),
                SizedBox(height: 10.h,),
                _textBtn(
                    context: context,
                    onTap: (){
                      _launchEmail(subject: '',body: '');
                    },
                    icon: Icons.email,
                    text: 'Email'
                ),
                SizedBox(height: 10.h,),

                Divider(height: 1.h,),

                SizedBox(height: 20.h,),
                Center(child: _title(context: context, text: 'Follow us on:')),
                SizedBox(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                        onTap: ()=>_launchURL('https://www.instagram.com/theglowbalnetwork/'),
                        child: Icon(Bootstrap.instagram,size: 35.sp,))
                    ,
                    InkWell(
                        onTap: ()=>_launchURL('https://www.youtube.com/@theglowbalnetwork'),
                        child: Icon(Bootstrap.youtube,size: 35.sp,)
                    ),
                    InkWell(
                      onTap: ()=>_launchURL('https://www.tiktok.com/@theglowbalnetwork?_t=ZG-8sYz3lMN54D&_r=1'),
                      child: Icon(
                        Bootstrap.tiktok,size: 35.sp,),
                    ),
                    // Image.asset('assets/images/instagram.png',height: 35.h,width: 35.w,),
                    // Image.asset('assets/images/youtube.png',height: 35.h,width: 35.w,),
                    // Image.asset('assets/images/twitter.png',height: 35.h,width: 35.w,),
                  ],
                ),
                SizedBox(height: 30.h,),

                Divider(height: 1.h,),
                SizedBox(height: 20.h,),
                _title(context: context, text: 'App policies'),

                SizedBox(height: 10.h,),
                _textBtn(
                    context: context,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://glowbal.co.uk/terms.html')));
                    },
                    icon: Icons.policy_outlined,
                    text: 'Terms and Policy'
                ),
                SizedBox(height: 10.h,),

                Divider(height: 1.h,),
                SizedBox(height: 10.h,),

                _textBtn(
                    context: context,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://glowbal.co.uk/privacy.html')));
                    },
                    icon: Icons.verified_user_outlined,
                    text: 'Privacy Policy'
                ),
                SizedBox(height: 10.h,),

                Divider(height: 1.h,),
                SizedBox(height: 10.h,),

                _textBtn(
                    context: context,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://glowbal.co.uk/dmca.html')));
                    },
                    icon: Icons.lock,
                    text: 'DCMA'
                ),

                SizedBox(height: 10.h,),

                Divider(height: 1.h,),
                SizedBox(height: 10.h,),

                _textBtn(
                    context: context,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://www.glowbal.co.uk/eula.html')));
                    },
                    icon: Icons.privacy_tip_outlined,
                    text: 'EULA'
                ),
                SizedBox(height: 10.h,),

                Divider(height: 1.h,),

                SizedBox(height: 30.h,),

                BlocBuilder<SubscriptionCubit,SubscriptionState>(
                  builder: (BuildContext context, SubscriptionState state) {
                    if(state is SubscriptionActive){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _title(context: context, text: 'Subscription'),
                          SizedBox(height: 10.h,),

                          _textBtn(
                              context: context,
                              onTap: (){
                                MyApi.getInstance().sendCancelEmail();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>const VerifyEmail(isCancelSub: true,)));
                              },
                              icon: Icons.free_cancellation_outlined,
                              text: 'Cancel'
                          ),
                          SizedBox(height: 10.h,),

                          Divider(height: 1.h,),

                          SizedBox(height: 30.h,),
                        ],
                      );
                    }
                    return Container();
                  },),

                _title(context: context, text: 'Settings'),

                SizedBox(height: 10.h,),
                _textBtn(
                    context: context,
                    onTap: (){
                      _showAlertDialog(context);
                    },
                    icon: Icons.delete,
                    text: 'Delete Account'
                ),
                SizedBox(height: 10.h,),

                Divider(height: 1.h,),
                SizedBox(height: 10.h,),

                _textBtn(
                    context: context,
                    onTap: (){
                      context.read<AccountCubit>().logout();
                    },
                    icon: Icons.logout_rounded,
                    text: 'Logout'
                ),

                SizedBox(height: 10.h,),
                BlocBuilder<AppVersionCubit,String>(
                  builder: (BuildContext context, state) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('App Version: $state',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).brightness==Brightness.dark ?
                            Colors.white24 : Colors.black26,
                        ),
                      ),
                    );
                  },

                ),
                SizedBox(height: 10.h,),
              ],
            ),
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('Please Login to continue',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(height: 10.h,),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>Login()));
                },
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.cyan),
                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10.h,horizontal: 30.w))),
                child: Text('Login',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                ),
              ),
            ),

          ],
        );
      },
    );
  }

  Widget _title({required BuildContext context, required String text}){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
      child: Text(text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 22.sp),
      ),
    );
  }

  Widget _textBtn({required BuildContext context,required VoidCallback onTap,
    required IconData icon, required String text}){
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size:25.sp,),
      label: Text(text,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(double.infinity,40.h)),
          alignment: Alignment.topLeft
      ),
    );
  }

  void _showAlertDialog(BuildContext context1) {
    showDialog(
      context: context1,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete account",),
          content: const Text("Are you sure want to delete account?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Handle any action for the confirm button
                Navigator.of(context).pop(); // Close the dialog
                // You can add more logic here if needed
                bool isSuccess= await MyApi.getInstance().deleteAccount();
                if(isSuccess){
                  context1.read<AccountCubit>().logout();
                }
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final url = "https://wa.me/$phoneNumber";  // WhatsApp URL scheme
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchEmail({required String subject,required String body}) async {
    final emailUrl = Uri.encodeFull('mailto:glowbalnetworkltd@gmail.com?subject=$subject&body=$body');
    if (await canLaunchUrl(Uri.parse(emailUrl))) {
      await launchUrl(Uri.parse(emailUrl));
    } else {
      throw 'Could not launch $emailUrl';
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
