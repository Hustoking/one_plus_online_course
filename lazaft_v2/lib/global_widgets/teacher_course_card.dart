import 'package:flutter/material.dart';
import 'package:lazaft_v2/entity/summaries/teacher_course_summary.dart';
import 'package:lazaft_v2/pages/course/course_page.dart';

import 'popular_course_card.dart';
class TeacherCourseCard extends StatelessWidget {
  const TeacherCourseCard({
    super.key,
    required this.courseSummary,
  });

  final TeacherCourseSummary courseSummary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CoursePage.routeName, arguments: {
          'title': courseSummary.title,
          'courseId': courseSummary.courseId,
          'coverAddr': courseSummary.coverAddr,
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(160 * 1 / 20),
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
              borderRadius: BorderRadius.circular(160 * 1 / 20),
              child: Image.network(
                courseSummary.coverAddr,
                width: 130,
                height: 152,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stackTrace) =>
                    Image.asset('assets/placeholder.png', width: 130),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    const SizedBox(height: 4),
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
