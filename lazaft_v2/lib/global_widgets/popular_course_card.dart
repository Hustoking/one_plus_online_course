import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lazaft_v2/pages/course/course_page.dart';

import '../entity/summaries/popular_course_summary.dart';

class PopularCourseCard extends StatelessWidget {
  const PopularCourseCard({
    super.key,
    required this.courseSummary,
  });

  final PopularCourseSummary courseSummary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('CourseId: ${courseSummary.courseId}');
        Navigator.pushNamed(context, CoursePage.routeName, arguments: {
          "courseId": courseSummary.courseId,
          "title": courseSummary.title,
          "coverAddr": courseSummary.coverAddr,
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(170 * 1 / 20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(170 * 1 / 20),
              child: Image.network(
                courseSummary.coverAddr,
                height: 162,
                width: 135,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stackTrace) =>
                    Image.asset('assets/placeholder.png', width: 135),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseSummary.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff364356),
                      ),
                    ),
                    const SizedBox(height: 4),
                    GradeStars(),
                    const SizedBox(height: 6),
                    Text(
                      courseSummary.teacherName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff364356),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      courseSummary.description,
                      style: TextStyle(
                        height: 1.4,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12,
                        color: Color(0xff636D77),
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradeStars extends StatelessWidget {
  const GradeStars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SvgPicture.asset('assets/full_star.svg'),
      SvgPicture.asset('assets/full_star.svg'),
      SvgPicture.asset('assets/full_star.svg'),
      SvgPicture.asset('assets/half_star.svg'),
      SvgPicture.asset('assets/hollowed_star.svg'),
      SizedBox(width: 4),
      Text("3.5  " + "(413)",
          style: TextStyle(
              fontFamily: 'OpenSans', fontSize: 7, color: Color(0xff636D77))),
    ]);
  }
}
