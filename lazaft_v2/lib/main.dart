import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazaft_v2/home/home_page.dart';
import 'package:lazaft_v2/login_page/verify_screen.dart';
import 'package:lazaft_v2/pages/lesson/lesson_page.dart';
import 'package:lazaft_v2/login_page/login_screen.dart';
import 'package:lazaft_v2/login_page/register_screen.dart';
import 'package:lazaft_v2/login_page/show_screen.dart';
import 'package:lazaft_v2/pages/course/course_page.dart';
import 'package:lazaft_v2/pages/like_teacher/like_teacher_page.dart';
import 'package:lazaft_v2/pages/my_courses/my_courses_page.dart';
import 'package:lazaft_v2/pages/profile/profile_page.dart';
import 'package:lazaft_v2/pages/search/search_page.dart';
import 'package:lazaft_v2/pages/stream/stream_page.dart';
import 'package:lazaft_v2/pages/teacher/teacher_page.dart';
import 'package:lazaft_v2/providers/my_info_provider.dart';
import 'package:lazaft_v2/tteesstt/tteesstt.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // 获取是否登录
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
  if (Platform.isAndroid) {
    // 设置状态栏背景及颜色
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    // SystemChrome.setEnabledSystemUIOverlays([]); //隐藏状态栏
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MaterialColor myColor = const MaterialColor(
    0xFF5667FD,
    <int, Color>{
      50: Color(0xFFE8E9FC),
      100: Color(0xFFC5C8F9),
      200: Color(0xFF9FA4F6),
      300: Color(0xFF7980F3),
      400: Color(0xFF5D69F1),
      500: Color(0xFF5667FD),
      600: Color(0xFF4F5EE4),
      700: Color(0xFF4754CB),
      800: Color(0xFF3F4AAB),
      900: Color(0xFF353F8B),
    },
  );

  @override
  void initState() {
    debugPrint(" === MyApp.initState() === ");
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugPrint(" === MyApp.build() === ");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyInfoProvider>(create: (context) => MyInfoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          ShowScreenPage.routeName: (context) => const ShowScreenPage(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),

          // === Tabs ===
          HomePage.routeName: (context) => HomePage(),
          LessonPage.routeName: (context) => LessonPage(),

          // === Pages ===
          TeacherPage.routeName: (context) => const TeacherPage(),
          CoursePage.routeName: (context) => const CoursePage(),
          VerifyScreen.routeName: (context) => const VerifyScreen(),
          StreamPage.routeName: (context) => const StreamPage(),
          ProfilePage.routeName: (context) => const ProfilePage(),
          MyCoursesPage.routeName: (context) => const MyCoursesPage(),
          LikeTeacherPage.routeName: (context) => const LikeTeacherPage(),
          SearchPage.routeName: (context) => const SearchPage(),

          TTEESSTT.routeName: (context) => const TTEESSTT(),
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          // 设置字体为鸿蒙黑体
          fontFamily: 'HarmonyOS Sans SC',
          // useMaterial3: true,
          primarySwatch: myColor,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: myColor)
              .copyWith(background: const Color(0xffF4F5F9)),
        ),
        // TODO: 会报错，未解决
        initialRoute:
            widget.isLoggedIn ? HomePage.routeName : ShowScreenPage.routeName,
      ),
    );
  }
}
