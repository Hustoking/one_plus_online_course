import 'package:flutter/material.dart';
import 'package:lazaft_v2/entity/summaries/recent_course_summary.dart';
import 'package:lazaft_v2/global/adapt.dart';
import 'package:lazaft_v2/global_widgets/my_button.dart';
import 'package:lazaft_v2/pages/course/course_page.dart';
import 'package:lazaft_v2/tools/ui_tools.dart';

class RecentCourses extends StatelessWidget {
  const RecentCourses({Key? key, required this.courses}) : super(key: key);

  final List<RecentCourseSummary> courses;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("最近课程",
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: Color(0xff3D405B))),
        const SizedBox(height: 14),
        courses.isEmpty
            ? const Center(child: Text("最近没有学习过课程哟~"))
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  courses.length > 0
                      ? RecentCourseCard(recentCourseSummary: courses[0])
                      : const SizedBox(),
                  courses.length > 1
                      ? RecentCourseCard(recentCourseSummary: courses[1])
                      : const SizedBox(),
                  courses.length > 2
                      ? RecentCourseCard(recentCourseSummary: courses[2])
                      : const SizedBox(),
                ],
              ),
      ],
    );
  }
}

class RecentCourseCard extends StatelessWidget {
  const RecentCourseCard({super.key, required this.recentCourseSummary});

  final RecentCourseSummary recentCourseSummary;

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Column(
      children: [
        Container(
          height: 216,
          width: Adapt.pt(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(
                    recentCourseSummary.coverAddr,
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stackTrace) =>
                        Image.asset('assets/placeholder.png'),
                  )),
              Text(recentCourseSummary.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3D405B))),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: 'By ',
                    style: TextStyle(fontSize: 10, color: Color(0xff62647B))),
                TextSpan(
                    text: recentCourseSummary.teacherName,
                    style: TextStyle(fontSize: 10, color: Color(0xff3D405B))),
              ])),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Column(
          children: [
            Text(
                '${recentCourseSummary.learnedCount.toString()} / ${recentCourseSummary.lessonsCount.toString()}',
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3D405B).withOpacity(0.8))),
            const SizedBox(height: 14),
            MyButton.small(
                onPress: () {
                  debugPrint('===== You trigger the continue button =====');
                  Navigator.pushNamed(context, CoursePage.routeName,
                      arguments: {
                        "courseId": recentCourseSummary.courseId,
                        "title": recentCourseSummary.title,
                        "coverAddr": recentCourseSummary.coverAddr,
                      });
                },
                title: '继续'),
            const SizedBox(height: 14),
            GestureDetector(
              // TODO: to be implemented
              onTap: () {
                debugPrint('===== You trigger the TD button =====');
                UiTools.showCustomDialog(context, "提示", "无法退订", "");
              },
              child: Text('退订',
                  style: TextStyle(
                      fontSize: 11, color: Color(0xffD00000).withOpacity(0.8))),
            ),
          ],
        ),
      ],
    );
  }
}
