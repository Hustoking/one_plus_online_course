import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazaft_v2/api/api_request.dart';
import 'package:lazaft_v2/entity/summaries/popular_course_summary.dart';
import 'package:lazaft_v2/api/api_config.dart';
import 'package:lazaft_v2/global_widgets/popular_course_card.dart';
import 'package:lazaft_v2/pages/course/course_page.dart';

import 'index_tab.dart';

class PopularCourses extends StatefulWidget {
  PopularCourses({Key? key}) : super(key: key);

  @override
  State<PopularCourses> createState() => _PopularCoursesState();
}

class _PopularCoursesState extends State<PopularCourses> {
  List<PopularCourseSummary> courses = [];

  _getPopularCourses() async {
    final resp = await ApiRequest.getPopularCourses();
    if (resp.statusCode == 200) {
      // 将服务器的响应装载成 json
      var res = jsonDecode(resp.body);
      var coursess = (res['data'] as List<dynamic>).map((e) => PopularCourseSummary.fromJson(e)).toList();
      print('CourseS: $courses');
      setState(() {
        courses = coursess;
      });
    } else {
      // TODO: 加载失败处理
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPopularCourses();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            children: [
              PopularCourseCard(courseSummary: courses[index]),
              SizedBox(height: 18),
            ],
          );
        },
        childCount: courses.length,
        // addAutomaticKeepAlives: true,
        // addRepaintBoundaries: true,
        // addSemanticIndexes: true,
      ),
    );
  }
}

