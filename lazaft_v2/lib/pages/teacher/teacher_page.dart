import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lazaft_v2/api/api_request.dart';
import 'package:lazaft_v2/entity/summaries/teacher_course_summary.dart';
import 'package:lazaft_v2/entity/teacher_view.dart';
import 'package:lazaft_v2/global/adapt.dart';
import 'package:lazaft_v2/api/api_config.dart';
import 'package:lazaft_v2/global_widgets/my_button.dart';
import 'package:lazaft_v2/pages/teacher/teacher_courses.dart';
import 'package:lazaft_v2/providers/my_info_provider.dart';
import 'package:lazaft_v2/tools/always_bouncing_scroll_physics.dart';
import 'package:lazaft_v2/tools/ui_tools.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({Key? key}) : super(key: key);
  static const String routeName = '/teacher';

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  TeacherView teacherView = TeacherView.noParm();
  late String teacherEmail = "";
  late List<TeacherCourseSummary> teacherCourses = [];
  bool isNoCourses = false;
  late String userEmail = "";

  bool isLikeButtonLoading = false;

  late MyInfoProvider myInfoProvider;

  _getTeacherView() async {
    myInfoProvider = Provider.of<MyInfoProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('email') ?? "";
    final resp = await ApiRequest.getTeacherView(userEmail, teacherEmail);
    // TODO: error handle
    if (resp.statusCode == 200) {
      // 将服务器的响应装载成 json
      final res = jsonDecode(resp.body);
      print('res: $res');
      final teacherViewV = TeacherView.fromJson(res['data']);
      print('teacherViewV: ${teacherViewV.toJson()}');
      setState(() {
        teacherView = teacherViewV;
      });
    } else {
      print('RESP CODE: ${resp.statusCode}');
    }
  }

  _getTeacherCourses(email) async {
    final resp = await ApiRequest.getTeacherCourses(email);
    if (resp.statusCode == 200) {
      // 将服务器的响应装载成 json
      final res = jsonDecode(resp.body);
      print('res: $res');
      List<TeacherCourseSummary> teacherCoursesS = [];

      // 教师课程不为空
      if (res['data'] != null) {
        teacherCoursesS = List<TeacherCourseSummary>.from(
            res['data'].map((x) => TeacherCourseSummary.fromJson(x)));
      } else {
        isNoCourses = true;
      }
      print('teacherCoursesS: ${teacherCoursesS}');
      setState(() {
        teacherCourses = teacherCoursesS;
      });
      print('teacherCourses: ${teacherCourses}');
    }
  }

  _likeTeacher() async {
    setState(() {
      isLikeButtonLoading = true;
    });
    try {
      final resp = await ApiRequest.likeTeacher(userEmail, teacherEmail);
      if (resp.statusCode == 200) {
        // 将服务器的响应装载成 json
        final resBody = jsonDecode(resp.body);
        print('res: $resBody');
        if (resBody['code'] == 200) {
          UiTools.showCustomDialog(context, "提示", "关注成功！", "");
          setState(() {
            teacherView.followerCount += 1;
            teacherView.isFollowed = true;
          });
          myInfoProvider
              .setLikeTeachersCount(myInfoProvider.likeTeachersCount + 1);
        } else {
          UiTools.showCustomDialog(context, "提示", resBody['msg'], "");
        }
      }
    } catch (err) {
      UiTools.showCustomDialog(context, "提示", "网络错误", "");
    } finally {
      setState(() {
        isLikeButtonLoading = false;
      });
    }
  }

  _dislikeTeacher() async {
    setState(() {
      isLikeButtonLoading = true;
    });
    try {
      final resp = await ApiRequest.dislikeTeacher(userEmail, teacherEmail);
      if (resp.statusCode == 200) {
        // 将服务器的响应装载成 json
        final resBody = jsonDecode(resp.body);
        print('res: $resBody');
        if (resBody['code'] == 200) {
          UiTools.showCustomDialog(context, "提示", "已取消关注~", "");
          setState(() {
            teacherView.followerCount -= 1;
            teacherView.isFollowed = false;
          });
          myInfoProvider
              .setLikeTeachersCount(myInfoProvider.likeTeachersCount - 1);
        } else {
          UiTools.showCustomDialog(context, "提示", resBody['msg'], "");
        }
      }
    } catch (err) {
      UiTools.showCustomDialog(context, "提示", "网络错误", "");
    } finally {
      setState(() {
        isLikeButtonLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 帧渲染完回调
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 获取路由参数
      final route = ModalRoute.of(context);
      if (route != null) {
        final args = route.settings.arguments as Map<String, dynamic>;
        teacherEmail = args['email'] ?? "";
        setState(() {
          teacherView.avatarAddr = args['teacherAvatarAddr'] ??
              "${ApiConfig.IMAGE_URL}place_user.png";
          teacherView.teacherName = args['teacherName'] ?? "XXX";
        });
        print('teacherName: $teacherView.teacherName');
        // print('teacherAvatarAddr: $teacherAvatarAddr');
        print("========================================WIDGETSBINDING");
        _getTeacherView();
        _getTeacherCourses(teacherEmail);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        physics: const AlwaysBouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(teacherView.teacherName,
                style: TextStyle(
                    color: Color(0xff3D405B), fontWeight: FontWeight.w800)),
            leading: Row(
              children: [
                const SizedBox(width: 12),
                GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child:
                        Icon(Icons.arrow_back_ios, color: Color(0xff3D405B))),
                Text('')
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            sliver: SliverToBoxAdapter(
              child: Column(children: [
                TeacherHeader(
                    teacherAvatarAddr: teacherView.avatarAddr,
                    teachingDuration: teacherView.teachingDuration,
                    courseCount: teacherView.courseCount,
                    followerCount: teacherView.followerCount),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: Adapt.pt(10)),
                  padding: EdgeInsets.symmetric(
                      horizontal: Adapt.pt(18), vertical: Adapt.pt(14)),
                  // height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xffE8E9FC),
                    border: Border.all(color: Color(0xff3D405B), width: 3),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset:
                            const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                        teacherView.description != null &&
                                teacherView.description != ""
                            ? teacherView.description
                            : "这个老师很懒，什么都没有留下",
                        style: TextStyle(
                          height: 1.4,
                          color: Color(0xff3D405B),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                ),
                const SizedBox(height: 26),
                // 关注&取关 按钮
                teacherView.courseCount == -1
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          teacherView.isFollowed
                              ? HollowButton.middle(
                                  isLoading: isLikeButtonLoading,
                                  title: "已关注",
                                  onPress: () {
                                    debugPrint(
                                        ' === You trigger Dislike button === ');
                                    _dislikeTeacher();
                                  },
                                )
                              : MyButton.middle(
                                  isLoading: isLikeButtonLoading,
                                  onPress: () {
                                    debugPrint(
                                        ' === You trigger Like button === ');
                                    _likeTeacher();
                                  },
                                  title: '关 注'),
                          MyButton.middle(
                              onPress: () {
                                debugPrint(' === You trigger Chat button === ');
                                UiTools.showCustomDialog(
                                    context, "提示", "留言功能暂未开放", "");
                              },
                              title: '留 言'),
                        ],
                      ),
                const SizedBox(height: 26),
              ]),
            ),
          ),
          SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              sliver: TeacherCourses(
                  courses: teacherCourses, isNoCourses: isNoCourses)),
        ],
      ),
    );
  }
}

// TODO: To be encapsulated
class TeacherHeader extends StatelessWidget {
  const TeacherHeader({
    super.key,
    required this.teacherAvatarAddr,
    required this.courseCount,
    required this.followerCount,
    required this.teachingDuration,
  });

  final String teacherAvatarAddr;
  final int courseCount;
  final int followerCount;
  final int teachingDuration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 教师头像
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100 * 2 / 10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            // 20% 圆角
            borderRadius: BorderRadius.circular(100 * 2 / 10),
            child: Container(
              color: Colors.white,
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular((100 - 10) * 2 / 10),
                      child: Image.network(
                        teacherAvatarAddr,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stackTrace) =>
                            Image.asset('assets/place_user.png'),
                      ))),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(courseCount == -1 ? "" : courseCount.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3D405B))),
                    Text('课程数',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3D405B))),
                  ],
                ),
                Column(
                  children: [
                    Text(followerCount == -1 ? "" : followerCount.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3D405B))),
                    Text('粉丝数',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3D405B))),
                  ],
                ),
                Column(
                  children: [
                    Text(
                        teachingDuration == -1
                            ? ""
                            : teachingDuration.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3D405B))),
                    Text('教学时长',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3D405B))),
                  ],
                ),
              ],
            )),
      ],
    );
  }
}
