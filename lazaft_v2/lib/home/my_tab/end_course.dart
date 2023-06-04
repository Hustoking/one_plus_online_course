import 'package:flutter/material.dart';
import 'package:lazaft_v2/entity/summaries/end_course_summary.dart';
import 'package:lazaft_v2/global/adapt.dart';
import 'package:lazaft_v2/api/api_config.dart';
import 'package:lazaft_v2/global_widgets/my_button.dart';

import '../../pages/course/course_page.dart';

class EndCourses extends StatelessWidget {
  const EndCourses({Key? key, required this.courses}) : super(key: key);

  final List<EndCourseSummary> courses;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("结束课程",
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: Color(0xff3D405B))),
        const SizedBox(height: 14),
        courses.isEmpty ? const Center(child: Text("还没有已经学完的课程哟~"),) :Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            courses.isNotEmpty
                ? EndCourseCard(endCourseSummary: courses[0])
                : const SizedBox(),
            courses.length > 1
                ? EndCourseCard(endCourseSummary: courses[1])
                : const SizedBox(),
            courses.length > 2
                ? EndCourseCard(endCourseSummary: courses[2])
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}

class EndCourseCard extends StatelessWidget {
  const EndCourseCard({super.key, required this.endCourseSummary});

  final EndCourseSummary endCourseSummary;

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
                    endCourseSummary.coverAddr,
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stackTrace) =>
                        Image.asset('assets/placeholder.png'),
                  )),
              Text(endCourseSummary.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3D405B))),
              Text.rich(TextSpan(children: [
                const TextSpan(
                    text: 'By ',
                    style: TextStyle(fontSize: 10, color: Color(0xff62647B))),
                TextSpan(
                    text: endCourseSummary.teacherName,
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xff3D405B))),
              ])),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Column(
          children: [
            Text('${endCourseSummary.lessonsCount.toString()} 课时',
                style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3D405B))),
            const SizedBox(height: 14),
            MyButton.small(
                onPress: () {
                  debugPrint(' === You trigger the BackStream Button === ');
                  Navigator.pushNamed(context, CoursePage.routeName,
                      arguments: {
                        "courseId": endCourseSummary.courseId,
                        "title": endCourseSummary.title,
                        "coverAddr": endCourseSummary.coverAddr,
                      });
                },
                title: '观看回放'),
            const SizedBox(height: 14),
          ],
        ),
      ],
    );
  }
}
