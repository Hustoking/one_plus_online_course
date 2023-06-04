import 'end_course_summary.dart';
import 'recent_course_summary.dart';

class MyTabView {
  String email;
  int courseCount;
  int likeTeachersCount;
  int coins;
  List<RecentCourseSummary> recentCourses;
  List<EndCourseSummary> endCourses;

  MyTabView.noParm({
    this.email = "",
    this.courseCount = -1,
    this.likeTeachersCount = -1,
    this.coins = -1,
    this.recentCourses = const [],
    this.endCourses = const [],
  });

  MyTabView({
    required this.email,
    required this.courseCount,
    required this.likeTeachersCount,
    required this.coins,
    required this.recentCourses,
    required this.endCourses,
  });

  factory MyTabView.fromJson(Map<String, dynamic> json) {
    return MyTabView(
      email: json['email'],
      courseCount: json['courseCount'],
      likeTeachersCount: json['likeTeachersCount'],
      coins: json['coins'],
      recentCourses: List<RecentCourseSummary>.from(json['recentCourses']
          .map((item) => RecentCourseSummary.fromJson(item))),
      endCourses: List<EndCourseSummary>.from(
          json['endCourses'].map((item) => EndCourseSummary.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'courseCount': courseCount,
      'likeTeachersCount': likeTeachersCount,
      'coins': coins,
      'recentCourses': recentCourses.map((item) => item.toJson()).toList(),
      'endCourses': endCourses.map((item) => item.toJson()).toList(),
    };
  }
}
