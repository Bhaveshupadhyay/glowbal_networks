import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zeus/theme/theme_cubit.dart';

import '../../../webview/show_webview.dart';
import '../../backend/my_api.dart';
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
                TextButton.icon(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://glowbal.co.uk/terms.html')));
                  },
                  icon: Icon(Icons.policy_outlined, size:25.sp),
                  label: Text('Terms and Policy',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                SizedBox(height: 10.h,),

                Divider(height: 1.h,),
                SizedBox(height: 10.h,),

                TextButton.icon(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://glowbal.co.uk/privacy.html')));
                  },
                  icon: Icon(Icons.verified_user_outlined, size:25.sp,),
                  label: Text('Privacy Policy',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                SizedBox(height: 10.h,),

                Divider(height: 1.h,),
                SizedBox(height: 10.h,),

                TextButton.icon(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://glowbal.co.uk/dmca.html')));
                  },
                  icon: Icon(Icons.lock,size:25.sp,),
                  label: Text('DCMA',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),

                SizedBox(height: 10.h,),

                Divider(height: 1.h,),
                SizedBox(height: 10.h,),

                TextButton.icon(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://www.glowbal.co.uk/eula.html')));
                  },
                  icon: Icon(Icons.privacy_tip_outlined,size:25.sp,),
                  label: Text('EULA',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                SizedBox(height: 10.h,),

                Divider(height: 1.h,),
                SizedBox(height: 10.h,),

                TextButton.icon(
                  onPressed: (){
                    _showAlertDialog(context);
                  },
                  icon: Icon(Icons.delete, size:25.sp,),
                  label: Text('Delete Account',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                SizedBox(height: 10.h,),

                Divider(height: 1.h,),
                SizedBox(height: 10.h,),

                TextButton.icon(
                  onPressed: (){
                    context.read<AccountCubit>().logout();
                  },
                  icon: Icon(Icons.logout_rounded, size:25.sp),
                  label: Text('Logout',
                    style:Theme.of(context).textTheme.titleSmall,
                  ),
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
}
