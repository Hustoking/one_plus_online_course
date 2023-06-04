import 'package:flutter/material.dart';
import 'package:lazaft_v2/entity/summaries/popular_course_summary.dart';
import 'package:lazaft_v2/api/api_config.dart';
import 'package:lazaft_v2/entity/summaries/teacher_course_summary.dart';
import 'package:lazaft_v2/global_widgets/teacher_course_card.dart';
import 'package:lazaft_v2/home/index_tab/index_tab.dart';
import 'package:lazaft_v2/pages/course/course_page.dart';

class TeacherCourses extends StatelessWidget {
  const TeacherCourses(
      {Key? key, required this.courses, required this.isNoCourses})
      : super(key: key);

  final List<TeacherCourseSummary> courses;

  // 课程是否为空，避免在没有接收到请求时显示没有课程
  final bool isNoCourses;

  // final List<CourseSummary> courses = [
  //   CourseSummary(verticalCoverAddr: "${ApiConfig.IMAGE_URL}cover1.png", title: "哈哈", teacherName: "王哈哈", description: "1234")
  // ];

  @override
  Widget build(BuildContext context) {
    return isNoCourses ? SliverToBoxAdapter(child: Center(child: Text("还没有课程哟~"))):SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            children: [
              TeacherCourseCard(
                  courseSummary: courses[index]),
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

