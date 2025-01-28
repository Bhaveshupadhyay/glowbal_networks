import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/app_update_check.dart';
import 'package:zeus/bottom_navigation/navigation_cubit.dart';
import 'package:zeus/screens/main_screens/account/account.dart';
import 'package:zeus/screens/main_screens/account/account_cubit.dart';
import 'package:zeus/screens/main_screens/episode/pageview_cubit.dart';
import 'package:zeus/screens/main_screens/home/home.dart';
import 'package:zeus/screens/main_screens/home/home_cubit.dart';
import 'package:zeus/screens/main_screens/search/search.dart';
import 'package:zeus/screens/main_screens/search/search_cubit.dart';
import 'package:zeus/screens/subscription/subscription_cubit.dart';
import 'package:zeus/screens/task/task.dart';
import 'package:zeus/theme/dark_theme.dart';
import 'package:zeus/theme/light_theme.dart';
import 'package:zeus/theme/theme_cubit.dart';

import 'firebase_options.dart';
import 'package:rxdart/rxdart.dart';
import 'modal_class/user_details.dart';

final _messageStreamController = BehaviorSubject<RemoteMessage>();

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if(Platform.isIOS){
    _requestPermission();
  }
  _getToken();

  //todo : change this to all
  _subscribeToTopic('all');
  _setupForegroundMsg();
  final prefs=await SharedPreferences.getInstance();
  UserDetails.id= prefs.getString('userId');
  runApp(const MyApp());
}

Future<void> _requestPermission() async {
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }
}

void _setupForegroundMsg(){
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    _messageStreamController.sink.add(message);
  });
}

Future<void> _getToken() async {
  final messaging = FirebaseMessaging.instance;
  // It requests a registration token for sending messages to users from your App server or other trusted server environment.
  String? token = await messaging.getToken();

  if (kDebugMode) {
    print('Registration Token=$token');
  }
}

void _subscribeToTopic(String topic) async {
  final messaging = FirebaseMessaging.instance;

  try {
    await messaging.subscribeToTopic(topic);
    if (kDebugMode) {
      print('Subscribed to topic: $topic');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error subscribing to topic: $e');
    }
  }
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
            child: const MyHomePage(),
          );
        },

      ),
    );
  }

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // This widget is the home page of your application. It is stateful, meaning
  final List<Widget> list=  [const Home(),Task(),Search(),const Account()];

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // print("home ${message.data}");
    if (message.data['screen'] == 'video') {
      // Navigator.push(context, MaterialPageRoute(builder: (builder)=>VideoDetail(postModal: PostModal.fromJson(
      //     jsonDecode(message.data['postData'])[0]
      // ))));
    }

  }

  @override
  void initState() {
    setupInteractedMessage();
    AppUpdateCheck().checkForUpdate(context);
    super.initState();
  }

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
    // return VerifyEmail();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>NavigationCubit()),
        BlocProvider(create: (create)=>SliderCubit()..loadSlider()),
        BlocProvider(create: (create)=>ContinueWatchingCubit()),
        BlocProvider(create: (create)=>HomeCubit()),
        BlocProvider(create: (create)=>SearchCubit()..loadPrefs()),
        BlocProvider(create: (create)=>PageViewCubit()),
        BlocProvider(create: (create)=>SubscriptionCubit()..checkSubscription()),
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
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home,),
                    label: "Home"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.girl,),
                    label: "Task"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search,),
                    label: "Search"
                ),
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
