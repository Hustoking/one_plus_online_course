import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lazaft_v2/api/api_request.dart';
import 'package:lazaft_v2/entity/course_view.dart';
import 'package:lazaft_v2/entity/summaries/lesson_summary.dart';
import 'package:lazaft_v2/global/adapt.dart';
import 'package:lazaft_v2/global_widgets/my_button.dart';
import 'package:lazaft_v2/pages/lesson/lesson_page.dart';
import 'package:lazaft_v2/pages/teacher/teacher_page.dart';
import 'package:lazaft_v2/providers/my_info_provider.dart';
import 'package:lazaft_v2/tools/always_bouncing_scroll_physics.dart';
import 'package:lazaft_v2/tools/ui_tools.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key}) : super(key: key);
  static const routeName = '/course';

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  // 为了在 await 后使用 BuildContext
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late String email;
  late String coverAddr = "";
  CourseView courseView = CourseView.noParm();

  bool isBuyButtonLoading = false;

  late MyInfoProvider myInfoProvider;

  Future<String> buyCourse() async {
    print(" === You trigger Buy Course === ");
    try {
      setState(() {
        isBuyButtonLoading = true;
      });
      final resp = await ApiRequest.buyCourse(courseView.courseId, email);
      // TODO: handle error
      if (resp.statusCode == 200) {
        final respBody = jsonDecode(resp.body);
        if (respBody['code'] == 200) {
          myInfoProvider
              .setCoinsCount(myInfoProvider.coinsCount - courseView.price);
          myInfoProvider.setCoursesCount(myInfoProvider.coursesCount + 1);
          return "购买成功";
        }
        return respBody['msg'];
      } else {
        return "请求失败";
      }
    } catch (e) {
      return "网络错误";
    } finally {
      setState(() {
        isBuyButtonLoading = false;
      });
    }
  }

  _getCourseView() async {
    final _prefs = await SharedPreferences.getInstance();
    // 获取我的 email
    email = await _prefs.getString('email') ?? '';
    print("email: $email");
    final resp = await ApiRequest.getCourseInfo(email, courseView.courseId);
    if (resp.statusCode == 200) {
      // 将服务器的响应装载成 json
      final res = jsonDecode(resp.body);
      print(res['data']);
      final courseViewV = CourseView.fromJson(res['data']);
      print(courseViewV.toString());
      setState(() {
        courseView = courseViewV;
      });
    }
  }

  _unsubscribeCourse() async {
    refreshRouterStack() {
      // 刷新路由栈
      Navigator.popUntil(context, (route) {
        return route.isFirst || route.settings.name == TeacherPage.routeName;
      });
      Navigator.pushNamed(context, CoursePage.routeName, arguments: {
        "courseId": courseView.courseId,
        "title": courseView.title,
        "coverAddr": coverAddr,
      });
    }

    setState(() {
      isBuyButtonLoading = true;
    });
    try {
      final resp =
          await ApiRequest.unsubscribeCourse(email, courseView.courseId);
      // 将服务器的响应装载成 json
      final resBody = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        UiTools.showCustomDialog(context, "提示", "退订成功", "", onPressed: () {
          refreshRouterStack();
        });
      } else {
        UiTools.showCustomDialog(context, "提示", resBody['msg'], "",
            onPressed: () {
          refreshRouterStack();
        });
      }
    } catch (err) {
      UiTools.showCustomDialog(context, "提示", "网络错误", "", onPressed: () {
        refreshRouterStack();
      });
    } finally {
      setState(() {
        isBuyButtonLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myInfoProvider = Provider.of<MyInfoProvider>(context, listen: false);
      // 获取路由参数
      // courseId, title, coverAddr
      final route = ModalRoute.of(context);
      if (route != null) {
        final args = route.settings.arguments as Map<String, dynamic>;
        courseView.courseId = args['courseId'];
        setState(() {
          courseView.title = args['title'];
          coverAddr = args['coverAddr'];
        });
      }
      _getCourseView();
    });
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.background,
        backgroundColor: Colors.white,
        body: CustomScrollView(
          // physics: const BouncingScrollPhysics(),
          physics: const AlwaysBouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              stretch: true,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop;
                },
                icon: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_ios)),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    UiTools.showCustomDialog(context, "提示", "未开放分享功能，敬请期待", "");
                  },
                  icon: const Icon(Icons.share),
                ),
              ],
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Image.network(
                  coverAddr,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stackTrace) =>
                      Image.asset('assets/placeholder.png'),
                ),
              ),
            ),
            // SliverToBoxAdapter(
            //   child: Image.network('${GlobalApi.IMAGE_URL}write.png'),
            // ),
            SliverPadding(
              padding: EdgeInsets.all(Adapt.pt(20)),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseView.title,
                      style: TextStyle(
                          fontSize: 20,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff242B42).withOpacity(0.9)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            courseView.totalDurationMinutes == -1
                                ? '正在加载...'
                                : '${courseView.totalDurationMinutes}min  ·  ${courseView.totalLessons} 课时',
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0xff4E74FA))),
                        // 如果没请求到数据则不渲染按钮
                        if (courseView.totalDurationMinutes != -1)
                          Container(
                            child: courseView.isSubscribed
                                ? HollowButton.middle(
                                    onPress: () {
                                      debugPrint(
                                          ' === You trigger the TD Button === ');
                                      UiTools.showCustomDialog(
                                          context,
                                          "提示",
                                          "确定退订该门课程吗，不会返回任何费用噢~",
                                          "取消", onPressed: () {
                                        Navigator.pop(context);
                                        _unsubscribeCourse();
                                      });
                                    },
                                    title: "退订",
                                    backgroundColor: Colors.white,
                                  )
                                : MyButton.middle(
                                    isLoading: isBuyButtonLoading,
                                    onPress: () async {
                                      // TODO: xxx
                                      UiTools.showCustomDialog(
                                          context,
                                          "提示",
                                          "价格:${courseView.price} \t 余额:${myInfoProvider.coinsCount}\n确定购买么？",
                                          "取消", onPressed: () async {
                                        final respString = await buyCourse();

                                        Navigator.pop(context);
                                        UiTools.showCustomDialog(
                                            context, "提示", respString, "",
                                            onPressed: () {
                                          // 刷新路由栈
                                          Navigator.popUntil(context, (route) {
                                            return route.isFirst ||
                                                route.settings.name ==
                                                    TeacherPage.routeName;
                                          });
                                          Navigator.pushNamed(
                                              context, CoursePage.routeName,
                                              arguments: {
                                                "courseId": courseView.courseId,
                                                "title": courseView.title,
                                                "coverAddr": coverAddr,
                                              });
                                        });
                                      });
                                    },
                                    title: "购买",
                                  ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(Adapt.pt(20)),
              sliver: courseView.totalLessons == 0
                  ? SliverToBoxAdapter(
                      child: Center(
                      child: Text("目前还没有课程哟~"),
                    ))
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: courseView.lessons.length,
                          (BuildContext context, int index) {
                        return LessonCard(
                          lessonCardSummary: LessonSummary(
                              lessonId: courseView.lessons[index].lessonId,
                              title: "${courseView.lessons[index].title}",
                              durationMinutes:
                                  courseView.lessons[index].durationMinutes),
                          number: index + 1,
                          coverAddr: coverAddr,
                          isSubscribed: courseView.isSubscribed,
                        );
                      }),
                    ),
            ),
          ],
        ));
  }
}

class LessonCard extends StatelessWidget {
  const LessonCard(
      {super.key,
      required this.lessonCardSummary,
      required this.number,
      required this.coverAddr,
      required this.isSubscribed});

  final int number;
  final LessonSummary lessonCardSummary;

  final String coverAddr;
  final bool isSubscribed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (isSubscribed) {
              Navigator.pushNamed(context, LessonPage.routeName, arguments: {
                'lessonId': lessonCardSummary.lessonId,
                'coverAddr': coverAddr,
                'title': lessonCardSummary.title,
              });
            } else {
              UiTools.showCustomDialog(context, "提示", "请先购买", "");
            }
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(
                Adapt.pt(8), Adapt.pt(18), Adapt.pt(16), Adapt.pt(18)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color(0xffF6F7FA),
            ),
            child: Row(
              children: [
                Container(
                  width: Adapt.pt(27),
                  child: Text(
                    '$number',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Color(0xff242B42)),
                  ),
                ),
                SizedBox(width: Adapt.pt(8)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${lessonCardSummary.title}',
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff242B42))),
                      const SizedBox(height: 4),
                      Text(
                        '${lessonCardSummary.durationMinutes} min',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff8693A5)),
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  'assets/pause.svg',
                  width: Adapt.pt(20),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
