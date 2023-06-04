import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lazaft_v2/api/api_request.dart';
import 'package:lazaft_v2/entity/summaries/teacher_summary.dart';
import 'package:lazaft_v2/global/adapt.dart';
import 'package:lazaft_v2/home/index_tab/popular_teachers.dart';
import 'package:lazaft_v2/tools/always_bouncing_scroll_physics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeTeacherPage extends StatefulWidget {
  const LikeTeacherPage({Key? key}) : super(key: key);
  static const String routeName = '/like_teacher';

  @override
  State<LikeTeacherPage> createState() => _LikeTeacherPageState();
}

class _LikeTeacherPageState extends State<LikeTeacherPage> {
  List<TeacherSummary> teacherSummaries = [];

  _getLikeTeachers() async {
    print("Triger _getLikeTeachers");
    final prefs = await SharedPreferences.getInstance();
    final myEmail = prefs.getString("email") ?? '';
    try {
      final resp = await ApiRequest.getLikeTeachers(myEmail);
      if (resp.statusCode == 200) {
        final resBody = jsonDecode(resp.body);
        final teachers = (resBody['data'] as List<dynamic>)
            .map((e) => TeacherSummary.fromJson(e))
            .toList();
        print("TEACHERS: $teachers");
        setState(() {
          teacherSummaries = teachers;
        });
      }
    } catch (err) {
      print(err);
    } finally {}
  }

  @override
  void initState() {
    super.initState();
    _getLikeTeachers();
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        physics: const AlwaysBouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SizedBox(
                    child: Icon(Icons.arrow_back_ios,
                        color: const Color(0xff3D405B).withOpacity(0.5)))),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text("关注教师",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff3D405B).withOpacity(0.9),
                )),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: Adapt.pt(30)),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                crossAxisSpacing: Adapt.pt(30),
                maxCrossAxisExtent: 140,
                childAspectRatio: 9 / 14,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return TeacherCard(teacherSummary: teacherSummaries[index]);
                },
                childCount: teacherSummaries.length,
              ),
            ),
          ),
        ],
      ),
      // child: Padding(
      //   padding: EdgeInsets.symmetric(horizontal: Adapt.pt(30)),
      //   child: GridView.builder(
      //       physics: const AlwaysBouncingScrollPhysics(),
      //       gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      //         crossAxisSpacing: Adapt.pt(30),
      //         maxCrossAxisExtent: 140,
      //         childAspectRatio: 9 / 14,
      //       ),
      //       itemBuilder: (context, index) {
      //         return TeacherCard(teacherSummary: teacherSummary);
      //       }),
      // ),
    ));
  }
}
