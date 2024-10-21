import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/bottom_navigation/navigation_bloc.dart';
import 'package:zeus/main_screens/account/account.dart';
import 'package:zeus/main_screens/downloads.dart';
import 'package:zeus/main_screens/episode/episode_cubit.dart';
import 'package:zeus/main_screens/home/home.dart';
import 'package:zeus/main_screens/home/home_cubit.dart';
import 'package:zeus/main_screens/search/search_cubit.dart';
import 'package:zeus/theme/dark_theme.dart';
import 'package:zeus/theme/light_theme.dart';
import 'package:zeus/theme/theme_cubit.dart';

import 'firebase_options.dart';
import 'main_screens/account/account_cubit.dart';
import 'main_screens/search/search.dart';
import 'modal_class/user_details.dart';

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs=await SharedPreferences.getInstance();
  UserDetails.id= prefs.getString('userId');
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>ThemeCubit()..getSavedTheme())
      ],
      child: BlocBuilder<ThemeCubit,ThemeMode>(
        builder: (BuildContext context, ThemeMode themeMode) {
          return ScreenUtilInit(
            designSize: const Size(430.0, 932.0),
            minTextAdapt: true,
            splitScreenMode: true,

            builder:(_,child){
              return MaterialApp(
                title: 'Glowbal Network',
                theme: LightTheme().lightTheme,
                darkTheme: DarkTheme().darkTheme,
                themeMode: themeMode,
                debugShowCheckedModeBanner: false,
                home: child,
              );
            },
            child: MyHomePage(),
          );
        },

      ),
    );
  }

}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final List<Widget> list=  [const Home(),Search(),const Downloads(),const Account()];
  final List<Widget> list=  [const Home(),Search(),const Account()];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>NavigationCubit()),
        BlocProvider(create: (create)=>SliderCubit()..loadSlider()),
        BlocProvider(create: (create)=>ContinueWatchingCubit()),
        BlocProvider(create: (create)=>HomeCubit()),
        BlocProvider(create: (create)=>SearchCubit()..loadPrefs()),
        BlocProvider(create: (create)=>PageViewCubit()),
        BlocProvider(create: (context){
          return AccountCubit()..isLoggedIn();
        }),
        BlocProvider(create: (context){
          return AppVersionCubit()..getAppDetails();
        }),
      ],
      child: BlocBuilder<NavigationCubit,int>(
        builder: (context,index){
          return Scaffold(
            appBar: AppBar(
              title: Image.asset('assets/images/logo.png',height: 100.h,width: 100.w,),
              centerTitle: true,
            ),
            body: IndexedStack(
                index: index,
                children: list
            ),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home,),
                    label: "Home"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search,),
                    label: "Search"
                ),
                // BottomNavigationBarItem(
                //     icon: Icon(Icons.list,),
                //     label: "Downloads"
                // ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_2_outlined),
                    label: "Account"
                ),
              ],
              currentIndex: index,
              onTap: (index){
                context.read<NavigationCubit>().changeIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}
