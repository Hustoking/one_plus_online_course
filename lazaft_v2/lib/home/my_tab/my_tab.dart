import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lazaft_v2/api/api_request.dart';
import 'package:lazaft_v2/entity/summaries/my_tab_view.dart';
import 'package:lazaft_v2/global/adapt.dart';
import 'package:lazaft_v2/global/global_style.dart';
import 'package:lazaft_v2/global_widgets/my_button.dart';
import 'package:lazaft_v2/home/my_tab/end_course.dart';
import 'package:lazaft_v2/home/my_tab/recent_course.dart';
import 'package:lazaft_v2/login_page/login_screen.dart';
import 'package:lazaft_v2/pages/like_teacher/like_teacher_page.dart';
import 'package:lazaft_v2/pages/my_courses/my_courses_page.dart';
import 'package:lazaft_v2/pages/profile/profile_page.dart';
import 'package:lazaft_v2/providers/my_info_provider.dart';
import 'package:lazaft_v2/tools/always_bouncing_scroll_physics.dart';
import 'package:lazaft_v2/tools/ui_tools.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTab extends StatefulWidget {
  const MyTab({Key? key}) : super(key: key);

  @override
  State<MyTab> createState() => MyTabState();
}

class MyTabState extends State<MyTab> {
  final double avatarSize = 120;

  late String myAvatarAddr = "";
  late String myNickName = "";
  late String myEmail = "";

  late SharedPreferences _prefs;

  late MyTabView myTabView = MyTabView.noParm();

  // 滚动控制器
  ScrollController scrollController = ScrollController();

  _loadMyInfo() async {
    print("My_Tab => _loadMyInfo()");
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      myAvatarAddr = _prefs.getString("myAvatarAddr") ?? "";
      myNickName = _prefs.getString("myNickName") ?? "";
      myEmail = _prefs.getString("email") ?? "";
    });

    // TODO: request & error handle
    try {
      final resp = await ApiRequest.getMyTabView(myEmail);
      if (resp.statusCode == 200) {
        print("My_Tab => resp: " + resp.body);
        print("resp.body.data: ");
        final respBody = jsonDecode(resp.body);
        print(respBody['data']);
        print(" === COINS COUNT === ");

        // 设置 coinsCount <= MyInfoState
        print(respBody['data']['coins']);
        final coursesCount = respBody['data']['courseCount'] as int;
        final likeTeachersCount = respBody['data']['likeTeachersCount'] as int;
        final coinsCount = respBody['data']['coins'] as int;
        final myInfoProvider =
        Provider.of<MyInfoProvider>(context, listen: false);

        // 通过 MyInfoProvider 设置 myInfo
        myInfoProvider.setStatistics(
            coursesCount: coursesCount,
            likeTeachersCount: likeTeachersCount,
            coinsCount: coinsCount);

        setState(() {
          myTabView = MyTabView.fromJson(respBody['data']);
        });
        print("My_Tab => myTabView: " + myTabView.toString());
      }
    } catch (err) {
      UiTools.showCustomDialog(context, "提示", "网络错误", "");
    }
  }

  @override
  void initState() {
    print(" === My Tab Init State === ");
    super.initState();
    _loadMyInfo();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(" === Build My Tab === ");
    debugPrint("Height:" + MediaQuery.of(context).size.height.toString());
    debugPrint("Width:" + MediaQuery.of(context).size.width.toString());
    Adapt.initialize(context);

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysBouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              leading: const SizedBox(),
              // backgroundColor: Color(0xffDDE1FF),
              backgroundColor: Theme.of(context).colorScheme.background,
              stretch: true,
              collapsedHeight: GlobalStyle.MY_TAB_APP_BAR_HEIGHT,
              expandedHeight: GlobalStyle.MY_TAB_APP_BAR_HEIGHT,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: const Alignment(0, 1),
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // color: Theme.of(context).colorScheme.background,
                        color: GlobalStyle.MY_TAB_COLOR,
                        // 120 为圆角头像的高度
                        height: (GlobalStyle.MY_TAB_APP_BAR_HEIGHT +
                                MediaQuery.of(context).padding.top) -
                            120 / 2,
                      ),
                    ),
                    Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(100)),
                        padding: const EdgeInsets.all(6),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              myAvatarAddr,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stackTrace) =>
                                  Image.asset('assets/place_user.png'),
                            ))),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(children: [
                Text("${myNickName}",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        color: Color(0xff3D405B))),
                const SizedBox(height: 2),
                Text("${myEmail.toUpperCase()}",
                    style: TextStyle(fontSize: 14, color: Color(0xff3D405B))),
                const SizedBox(height: 22),
                MyButton.middle(
                    onPress: () {
                      debugPrint(' === You trigger the edit button ===');
                      Navigator.pushNamed(context, ProfilePage.routeName,
                          arguments: {
                            "myAvatarAddr": myAvatarAddr,
                            "email": myEmail,
                          });
                    },
                    title: "编辑资料"),
                const SizedBox(height: 22),
              ]),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                  Adapt.pt(28), 0, Adapt.pt(28), Adapt.pt(60)),
              sliver: SliverToBoxAdapter(
                child: myTabView.courseCount == -1
                    ? Center(child: Text("正在加载..."))
                    : Column(
                        children: [
                          StatisticInfo(
                              // courseCount: myTabView.courseCount,
                              // likeTeacherCount: myTabView.likeTeacherCount,
                              // coins: myTabView.coins
                              ),
                          // coins: Provider.of<MyInfoState>(context)
                          //     .coinsCount),
                          const SizedBox(height: 30),
                          RecentCourses(courses: myTabView.recentCourses),
                          const SizedBox(height: 30),
                          EndCourses(courses: myTabView.endCourses),
                          const SizedBox(height: 50),
                          HollowButton.middle(
                              onPress: () {
                                debugPrint(
                                    ' === You trigger the logout button === ');
                                UiTools.showCustomDialog(
                                    context, "提示", "确定要退出登录吗？", "取消",
                                    onPressed: () async {
                                      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                                      final prefs = await SharedPreferences.getInstance();
                                      prefs.remove("email");
                                      prefs.remove("myAvatarAddr");
                                      prefs.remove("myNickName");
                                      prefs.setBool("isLoggedIn", false);
                                    });
                              },
                              title: '退出登录',
                              fontColor: Color(0xff3D405B).withOpacity(0.8)),
                        ],
                      ),
              ),
            ),
          ],
        ));
  }
}

// TODO: Component encapsulation
class StatisticInfo extends StatelessWidget {
  const StatisticInfo({
    super.key,
    // required this.courseCount,
    // required this.likeTeacherCount,
    // required this.coins,
  });

  // final int courseCount;
  // final int likeTeacherCount;
  // final int coins;

  @override
  Widget build(BuildContext context) {
    final myInfoProvider = Provider.of<MyInfoProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("统计信息",
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: Color(0xff3D405B))),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, MyCoursesPage.routeName);
                },
                child: Column(
                  children: [
                    Text(myInfoProvider.coursesCount.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3D405B).withOpacity(0.9))),
                    Text("己购课程",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3D405B).withOpacity(0.9))),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, LikeTeacherPage.routeName);
                },
                child: Column(
                  children: [
                    Text(myInfoProvider.likeTeachersCount.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3D405B).withOpacity(0.9))),
                    Text("订阅教师",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3D405B).withOpacity(0.9))),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(myInfoProvider.coinsCount.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3D405B).withOpacity(0.9))),
                  Text("硬币余额",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3D405B).withOpacity(0.9))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
