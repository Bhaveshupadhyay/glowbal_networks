import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zeus/screens/main_screens/register/register_state.dart';
import 'package:zeus/screens/main_screens/register/regsiter_cubit.dart';

import '../../../webview/show_webview.dart';
import '../../profile/profile.dart';
import '../login/login.dart';
import '../login/login_cubit.dart';
import '../login/login_state.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>PasswordCubit()),
        BlocProvider(create: (create)=>RegisterCubit()),
      ],
      child: Scaffold(
        appBar:AppBar(
          title: Image.asset('assets/images/logo.png', height: 25.h,),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.h,),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Sign'.toUpperCase(),
                        style: TextStyle(
                            fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
                            fontSize: 35.sp,
                            color: Colors.red
                        ),
                        children: [
                          TextSpan(
                            text: ' Up'.toUpperCase(),
                            style: TextStyle(
                                fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
                                fontSize: 35.sp,
                                color: const Color(0xff00e5fa)
                            ),
                          )
                        ]
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness==Brightness.light?
                      Colors.black12 : Colors.white12,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.w)
                      ),
                      style: TextStyle(
                          color: Theme.of(context).brightness==Brightness.light?
                          Colors.black : Colors.white,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold

                      ),
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness==Brightness.light?
                      Colors.black12 : Colors.white12,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                    child: BlocBuilder<PasswordCubit,PasswordState>(
                      builder: (context,state){
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _passController,
                                obscureText: state is PasswordInvisible,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w)
                                ),
                                style: TextStyle(
                                    color: Theme.of(context).brightness==Brightness.light?
                                    Colors.black : Colors.white,
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold

                                ),
                              ),
                            ),

                            InkWell(
                                onTap: (){
                                  context.read<PasswordCubit>().toggle();
                                },
                                child: Icon(state is PasswordInvisible? Icons.visibility_off: Icons.visibility)),
                            SizedBox(width: 5.w,),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 30.h,),
                  BlocBuilder<RegisterCubit,RegisterState>(
                      builder: (context,state){
                        if(state is RegisterFailed){
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  state.errorMsg,
                                  style: GoogleFonts.poppins(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                        }
                        else if(state is RegisterSuccess){
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                                Profile(email: _emailController.text, password: _passController.text, isUserExist: false)));
                          });
                        }
                        else if(state is RegisterLoading){
                          return const CircularProgressIndicator();
                        }
                        return TextButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.read<RegisterCubit>().validate(_emailController.text, _passController.text);
                          },
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(Colors.red),
                              padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w)),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0.r),
                                  )
                              )
                          ),
                          child: Text('Sign Up',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp
                            ),
                          ),
                        );
                      }
                  ),

                  SizedBox(height: 10.h,),
                  RichText(
                    text: TextSpan(
                        text: "By clicking Sign Up, you agree to the Glowbal Networks",
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          TextSpan(
                              text: ' Terms of Use, '.toUpperCase(),
                              style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 12.sp,
                                  color: Colors.blue
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap= (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://glowbal.co.uk/terms.html')));
                                }
                          ),
                          TextSpan(
                            text: 'acknowledge that you have read the',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                              text: ' Privacy Policy'.toUpperCase(),
                              style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 12.sp,
                                  color: Colors.blue
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap= (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://glowbal.co.uk/privacy.html')));
                                }
                          ),

                          TextSpan(
                            text: ' and accept the',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                              text: ' End User License Agreement (EULA)'.toUpperCase(),
                              style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 12.sp,
                                  color: Colors.blue
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap= (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://www.glowbal.co.uk/eula.html')));
                                }
                          ),
                        ]
                    ),
                  ),

                  SizedBox(height: 30.h,),

                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>Login()));
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Already have an account?",
                          style: TextStyle(
                              fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
                              fontSize: 15.sp,
                            color: Theme.of(context).brightness==Brightness.light?
                            Colors.black : Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: ' Log in'.toUpperCase(),
                              style: TextStyle(
                                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
                                  fontSize: 15.sp,
                                  color: Colors.red
                              ),
                            )
                          ]
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
